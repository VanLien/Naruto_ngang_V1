<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include '../../../config/config.php';
require '../../../vendor/autoload.php';

// Get request data
$username = '';
$password = '';
$email = '';

$rawInput = file_get_contents('php://input');
$contentType = isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : '';

if (strpos($contentType, 'application/json') !== false) {
    $postData = json_decode($rawInput, true);
    if (json_last_error() === JSON_ERROR_NONE && is_array($postData)) {
        $username = isset($postData['username']) ? str_text($postData['username']) : '';
        $password = isset($postData['password']) ? $postData['password'] : '';
        $email = isset($postData['email']) ? str_text($postData['email']) : '';
    }
} else {
    if (!empty($rawInput)) {
        parse_str($rawInput, $postData);
        $username = isset($postData['username']) ? str_text($postData['username']) : '';
        $password = isset($postData['password']) ? $postData['password'] : '';
        $email = isset($postData['email']) ? str_text($postData['email']) : '';
    }
    
    if (empty($username) && isset($_POST['username'])) {
        $username = str_text($_POST['username']);
    }
    if (empty($password) && isset($_POST['password'])) {
        $password = $_POST['password'];
    }
    if (empty($email) && isset($_POST['email'])) {
        $email = str_text($_POST['email']);
    }
}

if (empty($username) || empty($password)) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => 'Vui lòng nhập đầy đủ thông tin'
    ]);
    exit();
}

// Validate username (6-12 characters, alphanumeric)
if (strlen($username) < 6 || strlen($username) > 12 || !preg_match('/^[a-z0-9]+$/', $username)) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => 'Tên đăng nhập phải từ 6-12 ký tự, chỉ chứa chữ thường và số'
    ]);
    exit();
}

try {
    // Check MongoDB if account exists
    $mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
    $accountdb = $mongodb->selectDatabase('account');
    $acc = $accountdb->selectCollection('Account');
    
    $existingAccount = $acc->findOne(['name' => $username]);
    
    if ($existingAccount) {
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => 'Tên đăng nhập đã tồn tại'
        ]);
        exit();
    }
    
    // Check MySQL if account exists
    $checkAccount = $database->has("account", [
        "username" => $username
    ]);
    
    if ($checkAccount) {
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => 'Tên đăng nhập đã tồn tại'
        ]);
        exit();
    }
    
    // Create account in MongoDB
    $accountData = [
        'name' => $username,
        'pass_md5' => $password,
        'email' => $email,
        'created_at' => new MongoDB\BSON\UTCDateTime(time() * 1000)
    ];
    
    $result = $acc->insertOne($accountData);
    $account_id = (string)$result->getInsertedId();
    
    // Create account in MySQL
    $ip = getIP();
    $database->insert("account", [
        "username" => $username,
        "password" => $password,
        "regDate" => $date,
        "lastLoginIP" => $ip,
        "lastTimeLogin" => $date,
        "account_id" => $account_id,
        "email" => $email,
        "xu" => 0,
    ]);
    
    http_response_code(200);
    echo json_encode([
        'status' => 'success',
        'message' => 'Đăng ký thành công',
        'data' => [
            'username' => $username,
            'account_id' => $account_id
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Lỗi server: ' . $e->getMessage()
    ]);
}
?>

