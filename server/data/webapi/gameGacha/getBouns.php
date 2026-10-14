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

function checkBouns($Bouns, $type) {
    // Chuyển đổi chuỗi thành mảng
    $arrBons = explode(', ', $Bouns);
    // Kiểm tra phần tử có trong mảng hay không
    return in_array($type, $arrBons);
}

function addBounsLog($bons, $phanTuMoi) {
    // Kiểm tra nếu $bons là null hoặc rỗng
    if (is_null($bons) || $bons === '') {
        // Nếu $bons là null hoặc rỗng, chỉ gán phần tử mới
        return $phanTuMoi;
    } else {
        // Nếu không, chuyển chuỗi thành mảng
        $arrBons = explode(', ', $bons);
        
        // Thêm phần tử mới vào mảng
        $arrBons[] = $phanTuMoi;
        
        // Chuyển mảng lại thành chuỗi
        return implode(', ', $arrBons);
    }
}





if ($type == "") {
    $json['status'] = 0;
    $json['msg'] = "Vui lòng nhập đầy đủ thông tin";
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
// switch type to get bouns 10, 20, 30, 50, 100, 200, 300, 500, 700, 1000, 2000, 3000, 4000, 5000
//check type in array
$bounsList = [10, 20, 30, 50, 100, 200, 300, 500, 700, 1000, 2000, 3000, 4000, 5000];
if (!in_array($type, $bounsList)) {
    $json['status'] = 0;
    $json['msg'] = "Không hợp lệ";
    echo json_encode($json);
    exit();
}
$bounsData = $getData['bouns'];
if (checkBouns($bounsData, $type)) {
    $json['status'] = 0;
    $json['msg'] = "Bạn đã nhận ưu đãi này rồi";
    echo json_encode($json);
    exit();
}
// bouns 20,40,80 check type i
$luotquay_count = $getData['luotquay_count'];
if ($luotquay_count>=$type)
{
    $bouns = $type/10;
    $database->update("event_gacha", [
        "luotquay[+]" => $bouns,
        "bouns" => addBounsLog($bounsData, $type)
    ], [
        "username" => $username
    ]);
    $json['status'] = 1;
    $json['msg'] = "Thành công";
    echo json_encode($json);
    exit();
}else
{
    $json['status'] = 0;
    $json['msg'] = "Không đủ điều kiện";
    echo json_encode($json);
    exit();

}



?>