<?php
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{  
	include('../../config/config.php');
	$cAccname = $_REQUEST['user'];
	$userref = $_REQUEST['userref'];
	$user2 = $_REQUEST['user2'];



				$data = $database->update("mod_user", [
				"username" => $cAccname,
	
				], [
				"id" => 1
				]);

				$data2 = $database->update("mod_user", [
					"username" => $userref,
		
					], [
					"id" => 2
					]);


					$data3 = $database->update("mod_user", [
						"username" => $user2,
			
						], [
						"id" => 3
						]);
		

	$admin = $_SESSION['username_admin'];
	$content = "Cập nhật danh sách MOD  : $cAccname";
	logAdmin($admin,$content);
	if ($data) {
	$return['type'] = 0;
	$return['msg'] =  "Cập nhật thành công";	
	echo json_encode($return);
	exit();
	}else {
		$return['type'] = 1;
		$return['msg'] =  "Lỗi không cập  nhật";	
		echo json_encode($return);
		exit();

	}
	
	}else {
	header('Location: index.html');
	exit();
}
?>