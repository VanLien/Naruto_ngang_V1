<?php 
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{   
	
	include('../../config/config.php');
    
    $rule = $_REQUEST['rule'];
    $username = $_REQUEST['username'];

    //update rule gacha to txt file /rule.txt
    $file = fopen('../../gameGacha/rule.txt', 'w');
    fwrite($file, $rule);
    fclose($file);
    $return['type'] = 0;
    $return['msg'] = "Cập nhật thể lệ thành công";

    
    echo json_encode($return);
    exit();

}else {
	header('Location: index.html');
	exit();
} 
	
?>