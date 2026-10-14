<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');


	$username = $_SESSION['username_admin'];
	$code_id = $_REQUEST['code_id'];
	$code = $_REQUEST['code'];


	
	
	if ($data)
	{
	$admin = $_SESSION['username_admin'];
	$content = "Cập nhật thông tin   : $code_name";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "Cập nhật thông tin thành công";	
	echo json_encode($return);
	exit();
	
	}else {
	$return['type'] = 1;
	$return['msg'] =  "Lỗi Update";	
	echo json_encode($return);
	exit();
	}
				}else {
	header('Location: index.html');
	exit();
}
	
?>