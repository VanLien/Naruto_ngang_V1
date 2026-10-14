<?php 

	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
	include('../../config/config.php');
	$id = $_REQUEST['id'];
	
	$data = $database->delete("shopcode", [
	"code_id" => $id
	]);
	if($data)
	{
	$admin = $_SESSION['username_admin'];
	$content = "Xóa code :  $id";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "Xóa Code $id thành công";	
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