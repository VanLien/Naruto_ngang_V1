<?php
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
{
    include('../config/config.php');

    // Kiểm tra đăng nhập
    if (!isset($_SESSION['username']) || empty($_SESSION['username'])) {
        echo json_encode(['draw' => 0, 'recordsTotal' => 0, 'recordsFiltered' => 0, 'data' => []]);
        exit();
    }

    $username = $_SESSION['username'];

    // Nhận tham số từ DataTables
    $draw = isset($_REQUEST['draw']) ? intval($_REQUEST['draw']) : 0;
    $start = isset($_REQUEST['start']) ? intval($_REQUEST['start']) : 0;
    $length = isset($_REQUEST['length']) ? intval($_REQUEST['length']) : 10;

    // Giới hạn length để tránh abuse
    if ($length > 100) $length = 100;
    if ($length < 1) $length = 10;

    // Đếm tổng số bản ghi
    $totalRecords = $database->count("invoice", [
        "username" => $username
    ]);
    $totalFiltered = $totalRecords;

    // Truy vấn dữ liệu an toàn với Medoo
    $data = $database->select("invoice", "*", [
        "username" => $username,
        "ORDER" => ["created_at" => "DESC"],
        "LIMIT" => [$start, $length]
    ]);

    foreach($data as $key => $row) {
        $data[$key]['amount'] = number_format($row['amount']) . 'đ';
        $data[$key]['xu_receive'] = number_format($row['xu_receive']);
        $data[$key]['created_at'] = date('d/m/Y H:i', strtotime($row['created_at']));

        switch ($row['status']) {
            case 0:
                $data[$key]['status'] = "<span style='background:#fff3cd;color:#856404;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-clock-o'></i> Đang xử lý</span>";
                break;
            case 1:
                $data[$key]['status'] = "<span style='background:#d4edda;color:#155724;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-check'></i> Hoàn tất</span>";
                break;
            case 2:
                $data[$key]['status'] = "<span style='background:#f8d7da;color:#721c24;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-times'></i> Đã hủy</span>";
                break;
            default:
                $data[$key]['status'] = "<span style='background:#e9ecef;color:#666;padding:3px 8px;border-radius:10px;font-size:11px;'>N/A</span>";
                break;
        }
    }

    $response = [
        "draw" => $draw,
        "recordsTotal" => $totalRecords,
        "recordsFiltered" => $totalFiltered,
        "data" => $data
    ];

    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($response);
} else {
    header('Location: ../index.html');
    exit();
}
?>

