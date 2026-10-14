<?php 
			if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$pass2new = str_text($_REQUEST['pass2new']);
$repass2new = str_text($_REQUEST['repass2new']);


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
if ( $pass2new == "" || $repass2new == "" )
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}
if($pass2new != $repass2new)
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu cấp 2 không trùng khớp";
echo json_encode($json);
exit();
}

if(strlen($pass2new) < 3 || strlen($repass2new) < 3 || strlen($pass2new)  >  32 || strlen($repass2new) > 32)
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu cấp 2 phải lớn hơn 3 ký tự và nhỏ hơn 32 ký tự";
echo json_encode($json);
exit();

}


$data = $database->update("account", [
	"pass2" => $pass2new,
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