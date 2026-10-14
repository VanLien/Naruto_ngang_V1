<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');

	$box = $_REQUEST['box'];
	

	$database->delete("event_gacha_boxcode", [
		"box" => $box
	]);
	
	$admin = $_SESSION['username_admin'];
	$content = "Xóa Code Box Gacha : $box";
	logAdmin($admin,$content);
	
	$return['type'] = 0;
	$return['msg'] =  "Xóa Code Box Gacha thành công";	
	echo json_encode($return);
	exit();
			}else {
	header('Location: index.html');
	exit();
}
?>