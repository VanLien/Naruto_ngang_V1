<?php 
			if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
{ 
include('../config/config.php');
$email = str_text($_REQUEST['email']);
$tel = str_text($_REQUEST['tel']);


$username = $_SESSION['username'];


// Nhận tham số từ DataTables
$draw = isset($_REQUEST['draw']) ? intval($_REQUEST['draw']) : 0;
$start = isset($_REQUEST['start']) ? intval($_REQUEST['start']) : 0;
$length = isset($_REQUEST['length']) ? intval($_REQUEST['length']) : 10;
$searchValue = isset($_REQUEST['search']['value']) ? $_REQUEST['search']['value'] : '';

$columns = ['id', 'cAccName', 'Content', 'timeDate','type'];
$orderColumnIndex = isset($_REQUEST['order'][0]['column']) ? intval($_REQUEST['order'][0]['column']) : 3;
$orderDir = isset($_REQUEST['order'][0]['dir']) && in_array($_REQUEST['order'][0]['dir'], ['asc','desc']) 
    ? $_REQUEST['order'][0]['dir'] 
    : 'desc';

$orderColumn = $columns[$orderColumnIndex];

$totalRecords = $database->count("history", [
	"cAccName" => $username
]);
$totalFiltered = $totalRecords;
// Xử lý phần "where" cho tìm kiếm


// Truy vấn dữ liệu theo phân trang, sắp xếp
$sqlData = "SELECT * FROM history  $where where cAccName = '{$username}' ORDER BY $orderColumn $orderDir LIMIT $start, $length";
$params['start'] = $start;
$params['length'] = $length;
$data = $database->query($sqlData)->fetchAll();



$response = [
    "draw" => $draw,
    "recordsTotal" => $totalRecords,
    "recordsFiltered" => $totalFiltered,
    "data" => $data
];
// Trả về JSON
header('Content-Type: application/json; charset=utf-8');
echo json_encode($response);
}else {
	header('Location: index.html');
	exit();
}
?>