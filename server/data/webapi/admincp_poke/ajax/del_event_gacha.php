<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');

	$id = $_REQUEST['id'];
	

	$database->delete("event_gacha_box", [
		"id" => $id
	]);
	
	
	$admin = $_SESSION['username_admin'];
	$content = "Xóa Gói Điểm Gacha : $id";
	logAdmin($admin,$content);
	
	$return['type'] = 0;
	$return['msg'] =  "Xóa Gói Điểm Gacha thành công";	
	echo json_encode($return);
	exit();
			}else {
	header('Location: index.html');
	exit();
}
?>