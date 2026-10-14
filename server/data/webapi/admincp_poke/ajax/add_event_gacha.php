<?php
if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

    include('../../config/config.php');
    $price = $_REQUEST['price'];
    $name = $_REQUEST['name'];

    if ($price == "" || $name == "") {
        $return['type'] = 1;
        $return['msg'] =  "Chưa nhập đủ nội dung";
        echo json_encode($return);
        exit();
    }

    $insertData = $database->insert("event_gacha_box", [
        "boxPrice" => $price,
        "boxName" => $name,
        
    ]);
    if ($insertData) {
        $admin = $_SESSION['username_admin'];
        $content = "Thêm gói điểm gacha $name, Giá: $price";
        logAdmin($admin, $content);
        $return['type'] = 0;
        $return['msg'] =  "Thêm thành công";
        echo json_encode($return);
        exit();
    } else {
        $return['type'] = 1;
        $return['msg'] =  "Thêm  thất bại";
        echo json_encode($return);
        exit();
    }
} else {
    header('Location: index.html');
    exit();
}
