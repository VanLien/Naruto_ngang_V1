<?php
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{  
	
	include('../../config/config.php');
	$username = $_REQUEST['id'];
	$coin = $_REQUEST['coin'];
	$type = $_REQUEST['type'];
	$xu = $_REQUEST['xu'];
	$admin = $_SESSION['username_admin'];
	if (!is_numeric($xu))
	{
	$return['type'] = 1;
	$return['msg'] =  "Chỉ nhận định dạng số";	
	echo json_encode($return);
	exit();
	}
	$isAccount = $database->has("account",
		[
			"name" => $username,
		]
	);
		if($isAccount){
			if ($coin == "xu")
			{
					if($type == "add")
					{
						$data = $database->update("account", [
						"point[+]" => $xu
						], [
						"name" => $username
						]);
						logAdmin($admin,"Cộng $xu Xu cho tài khoản $username");
						$return['type'] = 0;
						$return['msg'] =  "Cộng $xu Xu cho tài khoản $username";
						echo json_encode($return);
						exit();
					}
					else if($type =="minus")
					{
						$data = $database->update("account", [
						"point[-]" => $xu
						], [
						"name" => $username
						]);
						logAdmin($admin,"Trừ $xu Xu cho tài khoản $username");
						$return['type'] = 0;
						$return['msg'] =  "Trừ $xu Xu cho tài khoản $username";
						echo json_encode($return);
						exit();
						
					}else 
					{
						$return['type'] = 1;
						$return['msg'] =  "Kiểu không hợp lệ";	
						echo json_encode($return);
						exit();
					}
					
			}

			

		}else {
		$return['type'] = 1;
		$return['msg'] =  "Tài khoản không tồn tại";	
		echo json_encode($return);
		exit();
		}

	
	}else {
	header('Location: index.html');
	exit();
}
?>