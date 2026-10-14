<?php
if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

    include('../../config/config.php');
    $code = $_REQUEST['code'];
    $id = $_REQUEST['id'];

    $getPackInfo = $database->get("event_tichluy_pack", '*', [
        "id" => $id
    ]);

    if($getPackInfo == null){
        $return['type'] = 1;
        $return['msg'] =  "Gói không tồn tại";
        echo json_encode($return);
        exit();
    }
    $name = $getPackInfo['name'];
    $price = $getPackInfo['price'];

    if ($code == "" || $id == "") {
        $return['type'] = 1;
        $return['msg'] =  "Chưa nhập đủ nội dung";
        echo json_encode($return);
        exit();
    }
    //split code by line
    $code = explode("\n", $code);
    foreach ($code as $item) {
        $insertData = $database->insert("event_tichluy_code", [
            "code" => $item,
            "status" => 0,
            "id_pack" => $id,
            "name" => $name,
            "price" => $price
        ]);
    }
    if ($insertData) {
        $admin = $_SESSION['username_admin'];
        $content = "Thêm code $code, Gói: $id";
        //logAdmin($admin, $content);
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
