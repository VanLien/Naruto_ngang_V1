<?php
if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

    include('../../config/config.php');
    $itemName = $_REQUEST['itemName'];
    $itemImage = $_REQUEST['itemImage'];
    $itemNum = $_REQUEST['itemNum'];
    $box = $_REQUEST['box'];

    if ($itemName == "" || $itemImage == "" || $itemNum == "" || $box == "") {
        $return['type'] = 1;
        $return['msg'] =  "Chưa nhập đủ nội dung";
        echo json_encode($return);
        exit();
    }
    $baseURL = "https://nap.bavuongdaichien.com/images/";
    $itemImage = $baseURL . $itemImage;
    $insertData = $database->insert("event_gacha_item", [
        "itemName" => $itemName,
        "itemImage" => $itemImage,
        "itemNum" => $itemNum,
        "box" => $box
    ]);
    if ($insertData) {
        $admin = $_SESSION['username_admin'];
        $content = "Thêm item $itemName, Hình ảnh: $itemImage, Số lượng: $itemNum, Gói: $box";
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
