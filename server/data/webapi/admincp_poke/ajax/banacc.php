<?php 

	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');
	$cAccname = $_REQUEST['id'];
	
	$data = $database->delete("account", [
	"username" => $cAccname
	]);
	if($data)
	{
	$admin = $_SESSION['username_admin'];
	$content = "Ban account $cAccname";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "Ban acc $cAccname thành công";	
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