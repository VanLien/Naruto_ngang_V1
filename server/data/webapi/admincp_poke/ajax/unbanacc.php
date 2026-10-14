<?php 
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{
	include('../../config/config.php');
	$cAccname = $_REQUEST['id'];
	
	$data = $database->update("MEMB_INFO", [
	"bloc_code" => 0
	], [
	"memb___id" => $cAccname
	]);
	if($data)
	{
	$admin = $_SESSION['username_admin'];
	$content = "UnBan Account $cAccname";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "UnBan acc $cAccname thành công";	
	echo json_encode($return);
	exit();
	}else 
	{
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