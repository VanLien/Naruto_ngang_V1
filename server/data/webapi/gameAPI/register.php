<?php 
header('Content-Type: application/json; charset=utf-8');
require '../vendor/autoload.php';

$mongodb = new MongoDB\Client("mongodb://admin:GpFkU9O24cjhnWco@127.0.0.1:27018");
$mongodb = new MongoDB\Client("mongodb://127.0.0.1:27018");
$username = trim($_REQUEST['username'] ?? '');
$password = trim($_REQUEST['password'] ?? '');

$json = [];
// Validate input
if($username === '' || $password === '') {
    $json['status'] = 1;
    $json['msg'] = 'Vui lòng nhập đầy đủ thông tin';
    echo json_encode($json, JSON_UNESCAPED_UNICODE);
    exit;
}

// Validate username length (6-20 characters)
if(strlen($username) < 6 || strlen($username) > 20) {
    $json['status'] = 1;
    $json['msg'] = 'Tên đăng nhập phải từ 6-20 ký tự';
    echo json_encode($json, JSON_UNESCAPED_UNICODE);
    exit;
}

// Validate username format (only lowercase letters and numbers)
if(!preg_match('/^[a-z0-9]+$/', $username)) {
    $json['status'] = 1;
    $json['msg'] = 'Tên đăng nhập chỉ chứa chữ thường và số';
    echo json_encode($json, JSON_UNESCAPED_UNICODE);
    exit;
}

// Validate password length
if(strlen($password) < 32) {
    $json['status'] = 1;
    $json['msg'] = 'Mật khẩu không hợp lệ';
    echo json_encode($json, JSON_UNESCAPED_UNICODE);
    exit;
}

$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');

// Check if username already exists
$existingAccount = $acc->findOne(['name' => $username]);

if($existingAccount) {
    $json['status'] = 1;
    $json['msg'] = 'Tên đăng nhập đã tồn tại';
    echo json_encode($json, JSON_UNESCAPED_UNICODE);
    exit;
}

// Get next pay_id
$lastAccount = $acc->findOne([], ['sort' => ['pay_id' => -1]]);
$nextPayId = ($lastAccount && isset($lastAccount['pay_id'])) ? $lastAccount['pay_id'] + 1 : 100001;

// Create new account
$newAccount = [
    'name' => $username,
    'pass_md5' => $password,
    'money' => 0,
    'pay_id' => $nextPayId,
    'email' => '',
    'phone' => '',
    'channel' => 'none',
    'language' => 'vn',
    'create_time' => time(),
    'last_time' => time(),
    'role_infos' => new stdClass(),
    'disable_flag' => false,
    'age' => 0
];

try {
    $result = $acc->insertOne($newAccount);
    
    if($result->getInsertedCount() > 0) {
        $json['status'] = 0;
        $json['msg'] = 'Đăng ký thành công';
    } else {
        $json['status'] = 1;
        $json['msg'] = 'Đăng ký thất bại';
    }
} catch(Exception $e) {
    $json['status'] = 1;
    $json['msg'] = 'Lỗi hệ thống: ' . $e->getMessage();
}

echo json_encode($json, JSON_UNESCAPED_UNICODE);
?>

