<?php
		if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$user = str_text($_REQUEST['username']);
$email = str_text($_REQUEST['email']);
$tel = str_text($_REQUEST['tel']);
$captchaUser = filter_var($_REQUEST["captcha"], FILTER_SANITIZE_STRING);
$ip = getIP();






if ( $_SESSION['CAPTCHA_CODE'] != $captchaUser)
{
$json['status'] = 1;
$json['msg'] = "Mã bảo mật sai";
echo json_encode($json);
exit();
}

if ( $user == "" || $email == "" || $captchaUser == "" || $tel == "" )
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}

$isAccount = $database->has("account", [
	"AND" => [
	"username" => $user,
	"email" => $email,
	"phone" => $tel,
		],
]);

if ($isAccount)
{
    $data = $database->get("account", [
        "id",
        "username",
        "email",
        "phone",
        "regDate",
        "xu",
        "pass2",
		"password",
        "lastTimeLogin",
        "LastLoginIP"
    ], [
    "username" => $user
    ]);
			$pass = $data['password'];
			$content = "Tìm lại mật khẩu thành công";
			AddUserHistory($user,$content);
			$json['status'] = 0;
			$json['msg'] = "Mật khẩu  của bạn là : $pass";
			$json['url'] = 'forgot.html';
			echo json_encode($json);
			exit();


	


}else {
$json['status'] = 1;
$json['msg'] = "Không tìm thấy thông tin tài khoản ";
echo json_encode($json);
exit();
}

	
}else {
	header('Location: index.html');
	exit();
}
