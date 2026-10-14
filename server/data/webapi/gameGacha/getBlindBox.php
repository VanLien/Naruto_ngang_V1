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
    "bindbox"
], [
"username" => $username
]);

$bindbox = $getData['bindbox']; // data point
if($bindbox < 1){
    $json['status'] = 0;
    $json['msg'] = "Bạn không có Box";
    echo json_encode($json);
    exit();
}

// sử lý API lấy quà
$getCodeBox =  $data = $database->query("SELECT  code FROM `event_gacha_boxcode` WHERE `box` = '-1' and `status` = '0' LIMIT 0,1")->fetchAll();
if (!$getCodeBox) {
    $json['status'] = 1;
    $json['msg'] = "Loại code này đã hết vui lòng liên hệ BQT";
    echo json_encode($json);
    exit();
}
foreach ($getCodeBox as $codearr) {
    $code = $codearr['code'];
}

$updateCode = $database->update(
    "event_gacha_boxcode",
    [
        "status" => 1,
        "dateTime"=> $date
    ],
    [
        "code" => $code
    ]
);

$updateBindbox = $database->update(
    "event_gacha",
    [
        "bindbox" => $bindbox - 1
    ],
    [   
        "username" => $username
    ]
);


$logBox = $database->insert("event_gacha_exchangebox_log", [
    "username" => $username,
    "box" => $box,
    "time" => $date,
    "code" => $code
]);

$json['status'] = 1;
$json['msg'] = "Nhận quà thành công mã code: ".$code;
echo json_encode($json);
exit();







?>