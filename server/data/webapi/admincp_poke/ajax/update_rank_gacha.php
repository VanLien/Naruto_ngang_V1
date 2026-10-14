<?php 
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{   
	
	include('../../config/config.php');
	$rank = $_REQUEST['rank'];
	
	if ( $rank == "")
	{
		$return['type'] = 1;
		$return['msg'] =  "Chưa nhập đủ nội dung";	
		echo json_encode($return);
		exit();
	}
	setConfig("rankGacha", $rank);
    {
        $admin = $_SESSION['username_admin'];
        $content = "Cập nhật BXH Gacha";
        logAdmin($admin,$content);
        $return['type'] = 0;
        $return['msg'] =  "Cập nhật thành công";	
        echo json_encode($return);
        exit();

    }else 
    {
        $return['type'] = 1;
        $return['msg'] =  "Cập nhật thất bại";	
        echo json_encode($return);
        exit();
    }



}else {
	header('Location: index.html');
	exit();
} 
	
?>