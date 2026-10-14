<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');

	

	$database->delete("log_event_tichluy", [
	]);
	
	$admin = $_SESSION['username_admin'];
	$content = "Xóa Log Sự Kiện Tích Lũy";
	logAdmin($admin,$content);
	
	$return['type'] = 0;
	$return['msg'] =  "Xóa Log Sự Kiện Tích Lũy thành công";	
	echo json_encode($return);
	exit();
			}else {
	header('Location: index.html');
	exit();
}
?>