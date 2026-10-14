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
if(!$username){
    $json['status'] = 0;
    $json['msg'] = "Vui lòng đăng nhập";
    echo json_encode($json);
    exit();
}

//get history event_gacha_exchangebox_log
$getData = $database->query("SELECT * FROM event_gacha_exchangebox_log WHERE username = '$username' ORDER BY `time` DESC LIMIT 10")->fetchAll();
// convert getData to array
$getData = array_map(function($item){
    return [
        'id' => $item['id'],
        'username' => $item['username'],
        'box' => $item['box'],
        'code' => $item['code'],
        'time' => $item['time']
    ];
}, $getData);

$json['status'] = 1;
$json['msg'] = "Thành công";
$json['data'] = $getData;
echo json_encode($json);


?>