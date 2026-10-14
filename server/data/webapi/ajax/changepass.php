<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$oldpassword = str_text($_REQUEST['oldpassword']);
$newpassword = str_text($_REQUEST['newpassword']);
$renewpassword = str_text($_REQUEST['renewpassword']);
$username = $_SESSION['username'];
require '../vendor/autoload.php';




$sign_client = $_REQUEST["sign"];
$time = $_REQUEST["time"];
$key_sv = 'thienlongthanma-4mcode';
$sign_sv = md5($time.$key_sv.$username);

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
    "password",
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


$oldpass = $info['password'];
if ( $oldpassword == "" || $newpassword == "" || $renewpassword == "" || $username == "")
{
$json['status'] = 1;
$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
echo json_encode($json);
exit();
}


if (strlen($newpassword) <  6 || strlen($newpassword) > 36 )
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu cần ít nhất 6 ký tự và nhỏ hơn 36 ký tự";
echo json_encode($json);
exit();
}

if ( $oldpass != md5($oldpassword) )
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu cũ không đúng";
echo json_encode($json);
exit();
}

if ( $newpassword != $renewpassword )
{
$json['status'] = 1;
$json['msg'] = "Mật khẩu xác nhận không trùng khớp";
echo json_encode($json);
exit();
}

//call API MongoDB
// Kết nối tới MongoDB
$client = new MongoDB\Client("mongodb://admin:GpFkU9O24cjhnWco@127.0.0.1:27018");
$client = new MongoDB\Client("mongodb://127.0.0.1:27018");
$collection = $client->account->Account; // Kết nối tới collection 'Account' trong database 'account'

// Nhận giá trị từ request và làm sạch dữ liệu

$password = md5($newpassword);
// Tạo filter để tìm document có trường 'name' là username
$filter = ['name' => $username];

// Kiểm tra xem document có tồn tại hay không
$document = $collection->findOne($filter);

if ($document) {
    // Nếu document tồn tại, tiến hành cập nhật pass_md5
    $update = ['$set' => ['pass_md5' => $password]]; // Mã hóa mật khẩu bằng MD5

    // Thực hiện cập nhật
    $updateResult = $collection->updateOne($filter, $update);

    if ($updateResult->getModifiedCount() > 0) {
        $msg =  "Cập nhật thành công!";

        //file_get_contents("http://180.93.98.5:39666/shuma/updateAccount?salt=@tj1shuma2tc@");
        
    } else {
        $msg =  "Không có gì thay đổi!";
    }
} else {
    $msg =  "Tài khoản không tồn tại!";
}


$data = $database->update("account", [
	"password" => md5($newpassword)
], [
	"username" => $username
]);

#$pay = curlPost("http://180.93.98.5:39666/shuma/updateAccount",
#array(
#"salt" => "@tj1shuma2tc@"
#));
 
if ($data) {
$json['status'] = 0;
$json['msg'] = $msg;
$json['url'] = 'index.html';


$content =  "Thay đổi mật khẩu cấp 1";
AddUserHistory($username,$content,'ChangePassword');

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