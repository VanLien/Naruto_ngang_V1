<?php
/**
 * API Tạo hóa đơn nạp tiền
 * POST: amount (số tiền, bội số 10,000)
 */

if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    include('../config/config.php');
    require_once('../config/bank_config.php');

    // Kiểm tra đăng nhập
    if (!isset($_SESSION['username']) || empty($_SESSION['username'])) {
        echo json_encode(['status' => 1, 'msg' => 'Vui lòng đăng nhập']);
        exit();
    }

    $username = $_SESSION['username'];
    $amount = isset($_POST['amount']) ? intval($_POST['amount']) : 0;

    // =====================================================
    // RATE LIMITING - Giới hạn 5 hóa đơn / 10 phút
    // =====================================================
    $rateLimitMinutes = 10;
    $rateLimitMax = 5;

    $recentInvoices = $database->count("invoice", [
        "AND" => [
            "username" => $username,
            "created_at[>]" => date("Y-m-d H:i:s", strtotime("-{$rateLimitMinutes} minutes"))
        ]
    ]);

    if ($recentInvoices >= $rateLimitMax) {
        echo json_encode([
            'status' => 1,
            'msg' => "Bạn đã tạo quá nhiều hóa đơn. Vui lòng đợi {$rateLimitMinutes} phút."
        ]);
        exit();
    }

    // Validate số tiền
    if ($amount < 10000) {
        echo json_encode(['status' => 1, 'msg' => 'Số tiền tối thiểu là 10,000đ']);
        exit();
    }

    if ($amount > 50000000) {
        echo json_encode(['status' => 1, 'msg' => 'Số tiền tối đa là 50,000,000đ']);
        exit();
    }

    if ($amount % 10000 != 0) {
        echo json_encode(['status' => 1, 'msg' => 'Số tiền phải là bội số của 10,000đ']);
        exit();
    }

    // Kiểm tra có hóa đơn pending không
    $pendingInvoice = $database->get("invoice", ["id", "invoice_code"], [
        "AND" => [
            "username" => $username,
            "status" => 0,
            "expired_at[>]" => date("Y-m-d H:i:s")
        ]
    ]);

    if ($pendingInvoice) {
        echo json_encode([
            'status' => 1, 
            'msg' => 'Bạn đang có hóa đơn chưa thanh toán. Vui lòng thanh toán hoặc hủy hóa đơn cũ.',
            'invoice_code' => $pendingInvoice['invoice_code']
        ]);
        exit();
    }

    // Tính số xu nhận được (theo tỷ lệ từ bank_config.php)
    $xu_receive = intval($amount * $bank_tyle_xu);

    // Thời gian hết hạn: 30 phút
    $expired_at = date("Y-m-d H:i:s", strtotime("+30 minutes"));

    // Insert hóa đơn trước để lấy ID
    $insert = $database->insert("invoice", [
        "invoice_code" => "TEMP", // Tạm thời
        "username" => $username,
        "amount" => $amount,
        "xu_receive" => $xu_receive,
        "status" => 0,
        "created_at" => date("Y-m-d H:i:s"),
        "expired_at" => $expired_at
    ]);

    if ($insert) {
        // Lấy ID vừa insert
        $invoiceId = $database->id();

        // Tạo mã hóa đơn: $bank_code_trans + random 8 số
        $randomNumber = str_pad(mt_rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        $invoice_code = $bank_code_trans . $randomNumber;

        // Kiểm tra trùng mã (nếu trùng thì tạo lại)
        while ($database->has("invoice", ["invoice_code" => $invoice_code, "id[!]" => $invoiceId])) {
            $randomNumber = str_pad(mt_rand(0, 99999999), 8, '0', STR_PAD_LEFT);
            $invoice_code = $bank_code_trans . $randomNumber;
        }

        // Cập nhật lại mã hóa đơn
        $database->update("invoice", [
            "invoice_code" => $invoice_code
        ], ["id" => $invoiceId]);

        // Ghi log
        AddUserHistory($username, "Tạo hóa đơn nạp tiền: $invoice_code - " . number_format($amount) . "đ", 'Invoice');

        echo json_encode([
            'status' => 0,
            'msg' => 'Tạo hóa đơn thành công',
            'data' => [
                'invoice_code' => $invoice_code,
                'amount' => $amount,
                'xu_receive' => $xu_receive,
                'expired_at' => $expired_at
            ]
        ]);
    } else {
        echo json_encode(['status' => 1, 'msg' => 'Lỗi tạo hóa đơn, vui lòng thử lại']);
    }

} else {
    header('Location: ../index.html');
    exit();
}
?>

