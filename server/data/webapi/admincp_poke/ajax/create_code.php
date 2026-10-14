<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');


	$username = $_SESSION['username_admin'];

	$code_name = $_REQUEST['code_name'];
	$content = $_REQUEST['content'];
	$price = $_REQUEST['price'];
	$status = $_REQUEST['status'];


	$data = $database->insert("shopcode", [
	"code_name" => $code_name,
	"content" => $content,
	"price" => $price,
	"status" => 1,
	"timeCreate" => $date
	]);
	if ($data)
	{
	$admin = $_SESSION['username_admin'];
	$content = "Tạo thành công Code   : $code_name";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "Tạo Code thành công";	
	echo json_encode($return);
	exit();
	
	}else {
	$return['type'] = 1;
	$return['msg'] =  "Lỗi Insert";	
	echo json_encode($return);
	exit();
	}
				}else {
	header('Location: index.html');
	exit();
}
	
?>