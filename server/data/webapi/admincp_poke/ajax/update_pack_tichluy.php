<?php 
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{   
	
	include('../../config/config.php');
	$id = $_REQUEST['id'];
	$price = $_REQUEST['price'];
	$content = $_REQUEST['content'];
    $name = $_REQUEST['name'];
    $id_code = $_REQUEST['id_code'];
	
	if ( $price == "" || $content == "" || $name == "" || $id_code == "")
	{
		$return['type'] = 1;
		$return['msg'] =  "Chưa nhập đủ nội dung";	
		echo json_encode($return);
		exit();
	}
	
	$dataUpdate = $database->update("event_tichluy_pack", [
	"price" => $price,
	"content" => $content,
    "name" => $name,
    "id_code" => $id_code
	],[
	'id'=>$id
	]);
	if($dataUpdate)
    {
        $admin = $_SESSION['username_admin'];
        $content = "Cập nhật gói tích lũy với ID: $id, Nội dung: $content, Giá: $price";
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