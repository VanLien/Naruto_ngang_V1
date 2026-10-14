<?php
header('Content-Type: application/json; charset=utf-8');

// Đảm bảo PHP sử dụng UTF-8
mb_internal_encoding('UTF-8');


//1 : open | 0 close
// Xử lý logic của bạn ở đây
$message = "12h-12.03.2025";
$response = array(
    'code' => 1,
    'msg' => $message
);

echo json_encode($response);
?>