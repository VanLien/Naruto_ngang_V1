<?php
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{  
	include('../../config/config.php');
	$cAccname = $_REQUEST['user'];
	$xu = $_REQUEST['xu'];
	$lydo = $_REQUEST['lydo'];

	if (!is_numeric($xu))
	{
	$return['type'] = 1;
	$return['msg'] =  "Chỉ nhận định dạng số";	
	echo json_encode($return);
	exit();
	}
	$isAccount = $database->has("account",
		[
			"username" => $cAccname,
		]
	);
		if($isAccount){
		

				$data = $database->update("account", [
				"xu[+]" => $xu,
				
				], [
				"username" => $cAccname
				]);
		


		$admin = $_SESSION['username_admin'];
		$content = "Cộng $xu cho tài khoản : $cAccname - Ghi chú: $lydo";
		logAdmin($admin,$content);
		}
		
		else {
		$return['type'] = 1;
		$return['msg'] =  "Tài khoản không tồn tại";	
		echo json_encode($return);
		exit();
		}
	
	$return['type'] = 0;
	$return['msg'] =  "Cộng $xu thành công";	
	echo json_encode($return);
	exit();
	
	}else {
	header('Location: index.html');
	exit();
}
?>