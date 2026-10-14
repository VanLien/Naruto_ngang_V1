<?php
/**
 * API Kiểm tra trạng thái hóa đơn
 * GET: invoice_code
 */

if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    include('../config/config.php');

    // Kiểm tra đăng nhập
    if (!isset($_SESSION['username']) || empty($_SESSION['username'])) {
        echo json_encode(['status' => 1, 'msg' => 'Vui lòng đăng nhập']);
        exit();
    }

    $username = $_SESSION['username'];
    $invoice_code = isset($_GET['invoice_code']) ? trim($_GET['invoice_code']) : '';

    if (empty($invoice_code)) {
        echo json_encode(['status' => 1, 'msg' => 'Mã hóa đơn không hợp lệ']);
        exit();
    }

    // Lấy thông tin hóa đơn
    $invoice = $database->get("invoice", "*", [
        "AND" => [
            "invoice_code" => $invoice_code,
            "username" => $username
        ]
    ]);

    if (!$invoice) {
        echo json_encode(['status' => 1, 'msg' => 'Không tìm thấy hóa đơn']);
        exit();
    }

    // Kiểm tra hết hạn (nếu đang pending)
    if ($invoice['status'] == 0 && strtotime($invoice['expired_at']) < time()) {
        // Cập nhật trạng thái hủy
        $database->update("invoice", [
            "status" => 2,
            "cancelled_at" => date("Y-m-d H:i:s"),
            "note" => "Tự động hủy do hết hạn"
        ], ["id" => $invoice['id']]);

        $invoice['status'] = 2;
    }

    // Tính thời gian còn lại
    $time_remaining = 0;
    if ($invoice['status'] == 0) {
        $time_remaining = strtotime($invoice['expired_at']) - time();
        if ($time_remaining < 0) $time_remaining = 0;
    }

    echo json_encode([
        'status' => 0,
        'msg' => 'Thành công',
        'data' => [
            'invoice_code' => $invoice['invoice_code'],
            'amount' => intval($invoice['amount']),
            'xu_receive' => intval($invoice['xu_receive']),
            'invoice_status' => intval($invoice['status']),
            'status_text' => getInvoiceStatusText($invoice['status']),
            'created_at' => $invoice['created_at'],
            'expired_at' => $invoice['expired_at'],
            'paid_at' => $invoice['paid_at'],
            'time_remaining' => $time_remaining
        ]
    ]);

} else {
    header('Location: ../index.html');
    exit();
}

/**
 * Lấy text trạng thái hóa đơn
 */
function getInvoiceStatusText($status) {
    switch ($status) {
        case 0: return 'Đang xử lý';
        case 1: return 'Hoàn tất';
        case 2: return 'Đã hủy';
        default: return 'Không xác định';
    }
}
?>

