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



$getData = $database->get("event_gacha", [
    "id",
    "username",
    "point",
    "luotquay",
    "luotquay_count",
    "bouns"
], [
"username" => $username
]);
// switch type to get bouns 20 , 30, 50

//get date today
$date = date('d-m-Y');
//get date last get free
$count = $database->count("event_gacha_free", [
    "username" => $username,
    "time" => $date
]);
if($count>0)
{
    $json['status'] = 0;
    $json['msg'] = "Hôm nay bạn đã nhận lượt miễn phí rồi";
    echo json_encode($json);
    exit();
}
$database->insert("event_gacha_free", [
    "username" => $username,
    "time" => $date
]);

//update luotquay_count
$database->update("event_gacha", [
    "luotquay[+]" => 5
], [
    "username" => $username
]);



$json['status'] = 1;
$json['msg'] = "Thành công";
echo json_encode($json);
exit();
//check type



?>