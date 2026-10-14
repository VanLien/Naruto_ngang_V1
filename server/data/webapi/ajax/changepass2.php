<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$oldpassword2 = str_text($_REQUEST['oldpassword2']);
$email = str_text($_REQUEST['email']);
$tel = str_text($_REQUEST['tel']);
$newpassword2 = str_text($_REQUEST['newpassword2']);
$renewpassword2 = str_text($_REQUEST['renewpassword2']);
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

$info = $database->get("account", [
    "id",
    "username",
    "email",
    "phone",
    "regDate",
    "xu",
    "pass2",
    "lastTimeLogin",
    "LastLoginIP"
], [
"username" => $username
]);


if ( $oldpassword2 == "" || $newpassword2 == "" || $renewpassword2 == "" || $username == ""  || $tel == "" || $email == "")
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}
$oldpasss2 = $info['pass2'];
if ( $oldpassword2 != $oldpasss2 )
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu cấp 2 cũ không đúng";
echo json_encode($json);
exit();
}

$email_db = $info['email'];
$tel_db = $info['phone'];
if ( $email != $email_db || $tel_db != $tel )
{
$json['status'] = 1;
$json['msg'] = "Thông tin tài khoản không đúng";
echo json_encode($json);
exit();
}

if ( $newpassword2 != $renewpassword2 )
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu xác nhận không trùng khớp";
echo json_encode($json);
exit();
}

$data = $database->update("account", [
	"password2" => $newpassword2
], [
	"username" => $username
]);
 
if ($data) {
$json['status'] = 0;
$json['msg'] = 'Cập nhật thành công';
$json['url'] = 'index.html';

$content =  "Đổi mật khẩu cấp 2 ";
AddUserHistory($username,$content,'ChangePass2');

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