<?php 
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{   
	
	include('../../config/config.php');
	
	$startDate = $_REQUEST['startDate'];
	$endDate = $_REQUEST['endDate'];
    $status = $_REQUEST['status'];
    $idEvent = $_REQUEST['idEvent'];
    if($startDate == "" || $endDate == ""){
        $return['type'] = 1;
        $return['msg'] =  "Vui lòng nhập đầy đủ thông tin";	
        echo json_encode($return);
        exit();
    }
	
	
	$updateCode = $database->update("event_tichluy", [
		"startDate" => $startDate,
		"endDate" => $endDate,
        "status" => $status	
	],[
		'id'=>$idEvent
	]);

	
	$admin = $_SESSION['username_admin'];
	$content = "Chỉnh sửa gói Tích Lũy Nạp với ID: $idEvent Nội dung: Bắt đầu: $startDate, Kết thúc: $endDate, Trạng thái: $status";
	logAdmin($admin,$content);
	$return['type'] = 0;
	$return['msg'] =  "Cập nhật thành công";	
	echo json_encode($return);
	exit();


}else {
	header('Location: index.html');
	exit();
} 
	
?>