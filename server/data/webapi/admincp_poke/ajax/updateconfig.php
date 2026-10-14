<?php 
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{   
	
	include('../../config/config.php');
    
	$startKhuyenmai = $_REQUEST['startKhuyenmai'];
	$endKhuyenmai = $_REQUEST['endKhuyenmai'];
	$tyle_khuyenmai = $_REQUEST['tyle_khuyenmai'];
	$startTichLuy = $_REQUEST['startTichLuy'];
	$endTichLuy = $_REQUEST['endTichLuy'];
	$startGacha = $_REQUEST['startGacha'];
	$endGacha = $_REQUEST['endGacha'];
	$url_gacha = $_REQUEST['url_gacha'];

    updateConfig('startKhuyenmai', $startKhuyenmai);
    updateConfig('endKhuyenmai', $endKhuyenmai);
    updateConfig('tyle_khuyenmai', $tyle_khuyenmai);
    updateConfig('startTichLuy', $startTichLuy);
    updateConfig('endTichLuy', $endTichLuy);
    updateConfig('startGacha', $startGacha);
    updateConfig('endGacha', $endGacha);
    updateConfig('url_gacha', $url_gacha);

    //add log
    $admin = $_SESSION['username_admin'];
    $content = "Chỉnh sửa cấu hình: Bắt đầu khuyến mãi: $startKhuyenmai, Kết thúc khuyến mãi: $endKhuyenmai, Tỷ lệ khuyến mãi: $tyle_khuyenmai, Bắt đầu tích lũy: $startTichLuy, Kết thúc tích lũy: $endTichLuy, Bắt đầu Gacha: $startGacha, Kết thúc Gacha: $endGacha, URL Gacha: $url_gacha";
    logAdmin($admin, $content);



    $return['type'] = 0;
    $return['msg'] =  "Cập nhật thành công";	
    echo json_encode($return);
    exit();





}else {
	header('Location: index.html');
	exit();
} 
	
?>