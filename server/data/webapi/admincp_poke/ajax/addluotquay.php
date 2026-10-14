<?php
	if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{  
	include('../../config/config.php');
	$cAccname = $_REQUEST['username'];
	$luotquay = $_REQUEST['luotquay'];


	if (!is_numeric($luotquay))
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
		

				$data = $database->update("event_gacha", [
				"luotquay[+]" => $luotquay,
				
				], [
				"username" => $cAccname
				]);
		


		$admin = $_SESSION['username_admin'];
		$content = "Cộng $luotquay Event Gacha cho tài khoản : $cAccname";
		logAdmin($admin,$content);
		}
		
		else {
		$return['type'] = 1;
		$return['msg'] =  "Tài khoản không tồn tại";	
		echo json_encode($return);
		exit();
		}
	
	$return['type'] = 0;
	$return['msg'] =  "Cộng $luotquay lượt quay thành công";	
	echo json_encode($return);
	exit();
	
	}else {
	header('Location: index.html');
	exit();
}
?>