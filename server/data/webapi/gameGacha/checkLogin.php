<?php



include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';
// Tạo đối tượng từ lớp JWTHandler
$jwtHandler = new JWTHandler();
$mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
$user = str_text($_REQUEST['username']);
$password = trim($_REQUEST['password']);



if ($user == "" || $password == "") {
	$json['status'] = 0;
	$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
	echo json_encode($json);
	exit();
}

//get MongoDb
$accountdb = $mongodb->selectDatabase('account');
$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');
$isAccount = $acc->findOne(
	[
		'name' => $user,
		'pass_md5' => $password
	]
);



if ($isAccount) {
	$account_id = (string) $isAccount['_id']; // oid của tài liệu chính

	$ip = getIP();
	$CheckAccount = $database->has("account", [
		"username" => $user
	]);

    $isPlayGacha = $database->has("event_gacha", [
        "username" => $user
    ]);

    if (!$isPlayGacha) {
        $database->insert("event_gacha", [
            "username" => $user,
            "point" => 0,
            "luotquay" => 0,
            "luotquay_count" => 0,
        ]);
    }

	if (!$CheckAccount) {

		$ip = getIP();
		$insert = $database->insert("account", [
			"username" => $user,
			"password" => $password,
			"regDate" => $date,
			"lastLoginIP" => $ip,
			"lastTimeLogin" => $date,
			"account_id" => $account_id,
			"xu"=>0,
		]);

	}


// Thông tin người dùng sau khi đăng nhập thành công
$user_data = [
    'username' => $user,
    'account_id' => $account_id
];
// Tạo token và trả về cho client
$jwt = $jwtHandler->generateToken($user_data);

$json['status'] = 1;
$json['msg'] = 'Login thành công';
$json['token'] = $jwt;
echo json_encode($json);
exit();

} else {
	$json['status'] = 0;
	$json['msg'] = "Sai thông tin đăng nhập";
}
echo json_encode($json);
exit();


?>