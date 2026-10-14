<?php
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
{
    include('../config/config.php');
    require_once('../config/bank_config.php');

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

    $totalRecords = $database->count("card", [
        "username" => $username
    ]);
    $totalFiltered = $totalRecords;

    // Truy vấn dữ liệu an toàn với Medoo
    $data = $database->select("card", "*", [
        "username" => $username,
        "ORDER" => ["created_at" => "DESC"],
        "LIMIT" => [$start, $length]
    ]);

    foreach($data as $key => $row) {
        // Lấy xu_receive từ database nếu có, nếu không thì tính theo tỷ lệ hiện tại
        if (isset($row['xu_receive']) && $row['xu_receive'] > 0) {
            $xu_receive = intval($row['xu_receive']);
        } else {
            // Dùng tỷ lệ card cho thẻ cào, bank cho chuyển khoản
            $tyle = ($row['loaithe'] == 'Bank') ? $bank_tyle_xu : $card_tyle_xu;
            $xu_receive = intval($row['menhgia'] * $tyle);
        }
        $data[$key]['xu_receive'] = number_format($xu_receive);
        $data[$key]['menhgia'] = number_format($row['menhgia']);

        switch ($row['trangthai']) {
            case 4:
                $data[$key]['trangthai'] = "<span style='background:#fff3cd;color:#856404;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-clock-o'></i> Đang chờ</span>";
                break;
            case 3:
                $data[$key]['trangthai'] = "<span style='background:#f8d7da;color:#721c24;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-times'></i> Thẻ sai</span>";
                break;
            case 2:
                $data[$key]['trangthai'] = "<span style='background:#d4edda;color:#155724;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-check'></i> Đã duyệt</span>";
                break;
            default:
                $data[$key]['trangthai'] = "<span style='background:#e9ecef;color:#666;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'>N/A</span>";
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