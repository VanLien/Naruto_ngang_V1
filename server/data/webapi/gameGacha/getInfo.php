<?php
include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';
// Tạo đối tượng từ lớp JWTHandler
$jwtHandler = new JWTHandler();
$type = str_text($_REQUEST['type']);
$token = $jwtHandler->getBearerToken();
$checkToken = $jwtHandler->validateToken($token);
$date = date('d-m-Y');
$username = $checkToken['data']->username;
if(!$username){
    $json['status'] = 0;
    $json['msg'] = "Vui lòng đăng nhập";
    echo json_encode($json);
    exit();
}

$getData = $database->get("event_gacha", [
    "id",
    "username",
    "point",
    "luotquay",
    "luotquay_count",
    "bouns",
    "bindbox"
], [
"username" => $username
]);

$count = $database->count("event_gacha_free", [
    "username" => $username,
    "time" => $date
]);
if($count>0)
{
//push free to array
    $getData['free'] = 1; // đã nhận free
}else {
    $getData['free'] = 0; // chưa nhận free
}


$json['status'] = 1;
$json['msg'] = "Thành công";
$json['data'] = $getData;
echo json_encode($json);





?>