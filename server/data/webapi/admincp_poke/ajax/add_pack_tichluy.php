<?php
if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

    include('../../config/config.php');
    $price = $_REQUEST['price'];
    $content = $_REQUEST['content'];
    $name = $_REQUEST['name'];
    $id_code = $_REQUEST['id_code'];

    if ($price == "" || $content == "" || $name == "" || $id_code == "") {
        $return['type'] = 1;
        $return['msg'] =  "Chưa nhập đủ nội dung";
        echo json_encode($return);
        exit();
    }

    $insertData = $database->insert("event_tichluy_pack", [
        "price" => $price,
        "content" => $content,
        "name" => $name,
        "id_code" => $id_code
    ]);
    if ($insertData) {
        $admin = $_SESSION['username_admin'];
        $content = "Thêm gói tích lũy  $name, Nội dung: $content, Giá: $price";
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
