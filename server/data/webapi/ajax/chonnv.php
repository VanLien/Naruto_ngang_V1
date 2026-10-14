<?php 
			if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$server = str_text($_REQUEST['server']);
$roleName = str_text($_REQUEST['roleName']);
$roleID = str_text($_REQUEST['roleID']);

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

if($_REQUEST['type'] =="resetNV")
{
   unset($_SESSION['roleID']);
    unset($_SESSION['roleName']);
    unset($_SESSION['server']);
    $json['status'] = 0;
    $json['url'] = 'chonnv.html';

    echo json_encode($json);
    exit();

}
if ( $roleID == "" || $server == "" )
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}


if ($roleID) {
$_SESSION['roleID'] = $roleID;
$_SESSION['roleName'] = $roleName;
$_SESSION['server'] = $server;
$json['status'] = 0;
$json['msg'] = 'Cập nhật thành công';
$json['url'] = 'chonnv.html';
$content =  "Chọn tài khoản :$roleName";
AddUserHistory($username,$content,'ChonNV');

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