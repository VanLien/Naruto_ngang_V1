<?php
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
{

include ('../config/config.php');
require '../vendor/autoload.php';
$mongodb = new MongoDB\Client("mongodb://admin:GpFkU9O24cjhnWco@180.93.98.5:27018");
$mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
$user = str_text($_REQUEST['username']);
$password = $_REQUEST['password'];

if ($user == "" || $password == "") {
	$json['status'] = 1;
	$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
	echo json_encode($json);
	exit();
}

// MD5 hash password để so sánh với database
$passwordMd5 = md5($password);

//get MongoDb
$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');

// Tìm account theo username trước
$isAccount = $acc->findOne(['name' => $user]);

// Kiểm tra password
if ($isAccount) {
	$storedPassword = $isAccount['pass_md5'] ?? '';
	
	// Nếu pass_md5 rỗng, cho phép login và update password mới
	if ($storedPassword === '' || $storedPassword === null) {
		$acc->updateOne(
			['name' => $user],
			['$set' => ['pass_md5' => $passwordMd5]]
		);
	}
	// Nếu có password, kiểm tra khớp
	else if ($storedPassword !== $passwordMd5) {
		$isAccount = null; // Set null để báo lỗi
	}
}



if ($isAccount) {
	$account_id = (string) $isAccount['_id']; // oid của tài liệu chính
	
	$ip = getIP();
	
	$CheckAccount = $database->has("account", [
		"username" => $user
	]);
	if (!$CheckAccount) {
		$insert = $database->insert("account", [
			"username" => $user,
			"password" => $passwordMd5,
			"regDate" => $date,
			"lastLoginIP" => $ip,
			"lastTimeLogin" => $date,
			"account_id" => $account_id,
			"xu"=>0,
		]);
	} else {
		// Update password MD5 nếu chưa có
		$database->update("account", [
			"password" => $passwordMd5
		], [
			"username" => $user
		]);
	}
	$json['status'] = 0;
	$json['msg'] = 'Click Chọn OK Để Vào Trang Nạp';
	$json['url'] = 'index.html';
	$_SESSION['username'] = $user;
	$ip = getIP();
	$content = "Đăng nhập thành công IP  : $ip";
	AddUserHistory($user, $content, 'Login');
	$upDateIP = $database->update("account", [
		"lastLoginIP" => $ip,
		"lastTimeLogin" => $date,
		"LastTimeUpdate" => time()
	], [
		"username" => $user
	]);
} else {
	$json['status'] = 1;
	$json['msg'] = "Sai thông tin đăng nhập";
}
echo json_encode($json);
exit();

}else {
	header('Location: index.html');
	exit();
}
?>