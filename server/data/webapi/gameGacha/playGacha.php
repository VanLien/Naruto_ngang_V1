<?php
include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';
// Tạo đối tượng từ lớp JWTHandler
$jwtHandler = new JWTHandler();
$type = str_text($_REQUEST['type']);
$token = $jwtHandler->getBearerToken();
$checkToken = $jwtHandler->validateToken($token);
$date = date("Y-m-d h:i:sa");
$username = $checkToken['data']->username;
$bindbox = false;
function random_weighted() {
    //return 0;
   // Tạo một mảng với các số lặp lại theo trọng số
    $weighted_numbers = array_merge(
        array_fill(0, 10, range(1, 10)),   // Tỷ lệ 1-10 = 10%
        array_fill(0, 10, range(11, 20)),  // Tỷ lệ 11-20 = 10%
        array_fill(0, 10, range(21, 30)),  // Tỷ lệ 21-30 = 10%
        array_fill(0, 11, range(31, 40)),  // Tỷ lệ 31-40 = 11%
        array_fill(0, 11, range(41, 50)),  // Tỷ lệ 41-50 = 11%
        array_fill(0, 11, range(51, 60)),  // Tỷ lệ 51-60 = 11%
        array_fill(0, 10, range(61, 70)),  // Tỷ lệ 61-70 = 10%
        array_fill(0, 9, range(71, 80)),   // Tỷ lệ 71-80 = 9%
        array_fill(0, 9, range(81, 90)),   // Tỷ lệ 81-90 = 9%
        array_fill(0, 10, range(91, 100))   // Tỷ lệ 91-100 = 5%
    );

    // Gộp tất cả các khoảng số thành một mảng phẳng
    $flat_numbers = [];
    foreach ($weighted_numbers as $subarray) {
        $flat_numbers = array_merge($flat_numbers, $subarray);
    }

    // Lấy ngẫu nhiên một phần tử từ mảng đã có trọng số
    return $flat_numbers[array_rand($flat_numbers)];
}




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
    "luotquay_count"
], [
"username" => $username
]);


if ($type == "") {
	$json['status'] = 0;
	$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
	echo json_encode($json);
	exit();
}

if ($type == "1") {
    $point = $getData['point'];
    $luotquay = $getData['luotquay'];
    if ($luotquay<1) {
        $json['status'] = 0;
        $json['msg'] = "Bạn không đủ số lươt quay";
        echo json_encode($json);
        exit();
    }
    $luotquay = $luotquay - 1;
    $luotquay_count = $getData['luotquay_count'];
    $luotquay_count = $luotquay_count + 1;
    $point_reward = random_weighted();

    $database->update("event_gacha", [
        "point[+]" => $point_reward,
        "luotquay" => $luotquay,
        "luotquay_count" => $luotquay_count
    ], [
        "username" => $username
    ]);

    // Kiểm tra xem có vượt qua mốc 50 nào không
    $old_count = $getData['luotquay_count'];
    $new_count = $luotquay_count;
    
    // Tính số blindbox cần thưởng
    $old_blindbox = floor($old_count / 50);
    $new_blindbox = floor($new_count / 50);
    $blindbox_to_add = $new_blindbox - $old_blindbox;
    
    if ($blindbox_to_add > 0) {
        $bindbox = true;
        $database->update("event_gacha", [
            "bindbox[+]" => $blindbox_to_add
        ], [
            "username" => $username
        ]);
    }

    //insert history
    $database->insert("event_gacha_log", [
        "username" => $username,
        "point" => $point_reward,
        "playTime" => $date,
        "playType" => 1
    ]);

    $json['status'] = 1;
    $json['msg'] = "Quay thành công";
    $json['point_reward'] = $point_reward;
    $json['bindbox'] = $bindbox;
    echo json_encode($json);
    exit();
}
if ($type == "10")
{
    $point = $getData['point'];
    $luotquay = $getData['luotquay'];
    if ($luotquay<10) {
        $json['status'] = 0;
        $json['msg'] = "Bạn không đủ số lượt quay";
        echo json_encode($json);
        exit();
    }
    $luotquay = $luotquay - 10;
    $luotquay_count = $getData['luotquay_count'];
    $luotquay_count = $luotquay_count + 10;

    // lấy ra tổng số điểm của 10 lần random
    $point_reward = 0;
    for ($i = 0; $i < 10; $i++) {
        $point_reward += random_weighted();
    }
    $database->update("event_gacha", [
        "point[+]" => $point_reward,
        "luotquay" => $luotquay,
        "luotquay_count" => $luotquay_count
    ], [
        "username" => $username
    ]);

    // Kiểm tra xem có vượt qua mốc 50 nào không
    $old_count = $getData['luotquay_count'];
    $new_count = $luotquay_count;
    
    // Tính số blindbox cần thưởng
    $old_blindbox = floor($old_count / 50);
    $new_blindbox = floor($new_count / 50);
    $blindbox_to_add = $new_blindbox - $old_blindbox;
    
    if ($blindbox_to_add > 0) {
        $bindbox = true;
        $database->update("event_gacha", [
            "bindbox[+]" => $blindbox_to_add
        ], [
            "username" => $username
        ]);
    }

        //insert history
        $database->insert("event_gacha_log", [
            "username" => $username,
            "point" => $point_reward,
            "playTime" => $date,
            "playType" => 10
        ]);
    $json['status'] = 1;
    $json['msg'] = "Quay thành công";
    $json['point_reward'] = $point_reward;
    $json['bindbox'] = $bindbox;
    echo json_encode($json);
    exit();
}


?>