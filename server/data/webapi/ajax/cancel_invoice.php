<?php
/**
 * API Hủy hóa đơn
 * POST: invoice_code
 */

if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    include('../config/config.php');

    // Kiểm tra đăng nhập
    if (!isset($_SESSION['username']) || empty($_SESSION['username'])) {
        echo json_encode(['status' => 1, 'msg' => 'Vui lòng đăng nhập']);
        exit();
    }

    $username = $_SESSION['username'];
    $invoice_code = isset($_POST['invoice_code']) ? trim($_POST['invoice_code']) : '';

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

    // Chỉ hủy được hóa đơn đang xử lý
    if ($invoice['status'] != 0) {
        $statusText = $invoice['status'] == 1 ? 'đã hoàn tất' : 'đã bị hủy';
        echo json_encode(['status' => 1, 'msg' => "Hóa đơn $statusText, không thể hủy"]);
        exit();
    }

    // Cập nhật trạng thái hủy
    $update = $database->update("invoice", [
        "status" => 2,
        "cancelled_at" => date("Y-m-d H:i:s"),
        "note" => "User tự hủy"
    ], ["id" => $invoice['id']]);

    if ($update) {
        AddUserHistory($username, "Hủy hóa đơn: $invoice_code", 'Invoice');
        echo json_encode(['status' => 0, 'msg' => 'Hủy hóa đơn thành công']);
    } else {
        echo json_encode(['status' => 1, 'msg' => 'Lỗi hủy hóa đơn, vui lòng thử lại']);
    }

} else {
    header('Location: ../index.html');
    exit();
}
?>

