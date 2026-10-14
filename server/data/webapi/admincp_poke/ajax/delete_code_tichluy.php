<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');

	$id = $_REQUEST['id'];
	

	$database->delete("event_tichluy_code", [
		"id_pack" => $id
	]);
	
	$admin = $_SESSION['username_admin'];
	$content = "Xóa Code Gói Tích Lũy : $id";
	logAdmin($admin,$content);
	
	$return['type'] = 0;
	$return['msg'] =  "Xóa Code Gói Tích Lũy thành công";	
	echo json_encode($return);
	exit();
			}else {
	header('Location: index.html');
	exit();
}
?>