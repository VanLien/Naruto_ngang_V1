<?php
include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';
// Tạo đối tượng từ lớp JWTHandler
$jwtHandler = new JWTHandler();
$type = str_text($_REQUEST['type']);
$token = $jwtHandler->getBearerToken();
$checkToken = $jwtHandler->validateToken($token);
$username = $checkToken['data']->username;
$date = date("Y-m-d h:i:sa");
$type = str_text($_REQUEST['type']);
if($type == "blindbox"){
    $itemList = $database->query("SELECT * FROM event_gacha_item WHERE box = -1")->fetchAll();
    $vp = array();
    foreach ($itemList as $item) {
        $vp[] = array(
            'name' => $item['itemName'],
            'image' => $item['itemImage'],
            'number' => $item['itemNum']
        );
    }
    
    // Trả về JSON response
    header('Content-Type: application/json');
    echo json_encode($vp, JSON_UNESCAPED_UNICODE);
}else{
    //get box list from event_gacha_box
    $boxList = $database->query("SELECT * FROM event_gacha_box where boxPrice > 0 order by boxPrice asc")->fetchAll();
    $response = array();
foreach ($boxList as $box) {
    $itemList = $database->query("SELECT * FROM event_gacha_item WHERE box = " . $box['boxPrice'])->fetchAll();
    $vp = array();
    foreach ($itemList as $item) {
        $vp[] = array(
            'name' => $item['itemName'],
            'image' => $item['itemImage'],
            'number' => $item['itemNum']
        );
    }
    
    $response[] = array(
        'gift' => $box['boxPrice'],
        'vp' => $vp
        );
    }

    // Trả về JSON response
    header('Content-Type: application/json');
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}
?>