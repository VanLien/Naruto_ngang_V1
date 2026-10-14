<?php
if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

    include('../../config/config.php');
    $code = $_REQUEST['code'];
    $box = $_REQUEST['box'];
    if ($code == "" || $box == "") {
        $return['type'] = 1;
        $return['msg'] =  "Chưa nhập đủ nội dung";
        echo json_encode($return);
        exit();
    }
    //split code by line
    $code = explode("\n", $code);
    foreach ($code as $item) {
        $insertData = $database->insert("event_gacha_boxcode", [
            "code" => $item,
            "status" => 0,
            "box" => $box
        ]);
    }
    if ($insertData) {
        $admin = $_SESSION['username_admin'];
        $content = "Thêm code $code, Gói: $box";
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
