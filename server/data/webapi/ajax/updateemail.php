<?php 
			if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$email = str_text($_REQUEST['email']);
$tel = str_text($_REQUEST['tel']);


$username = $_SESSION['username'];
$sign_client = $_REQUEST["sign"];
$time = $_REQUEST["time"];
$key = 'thienlongthanma-4mcode';
$sign_sv = md5($time.$key.$username);

if ($sign_client != $sign_sv)
{
    $json['status'] = 1;
    $json['msg'] = "Dữ liệu truyền vào sai";
    echo json_encode($json);
    exit();
}
if ( $email == "" || $tel == "" )
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}

if ( !preg_match('/^([0-9 ]*)$/',$tel) || strlen($tel) > 11 )
{
$json['status'] = 1;
$json['msg'] = "Số điện thoại không hợp lệ";
echo json_encode($json);
exit();
}

$data = $database->update("account", [
	"email" => $email,
	"phone" => $tel,
], [
	"username" => $username
]);
 
if ($data) {
$json['status'] = 0;
$json['msg'] = 'Cập nhật thành công';
$json['url'] = 'security.html';


$content =  "Cập nhật thông tin tài khoản :$username";
AddUserHistory($username,$content,'UpdateProfile');

} else {
$json['status'] = 1;
$json['msg'] = "Lỗi không xác định";
}
	
echo json_encode($json);
}else {
	header('Location: index.html');
	exit();
}
?>