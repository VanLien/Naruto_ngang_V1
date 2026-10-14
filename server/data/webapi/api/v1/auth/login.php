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

$rawInput = file_get_contents('php://input');
$contentType = isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : '';

if (strpos($contentType, 'application/json') !== false) {
    $postData = json_decode($rawInput, true);
    if (json_last_error() === JSON_ERROR_NONE && is_array($postData)) {
        $username = isset($postData['username']) ? str_text($postData['username']) : '';
        $password = isset($postData['password']) ? $postData['password'] : '';
    }
} else {
    if (!empty($rawInput)) {
        parse_str($rawInput, $postData);
        $username = isset($postData['username']) ? str_text($postData['username']) : '';
        $password = isset($postData['password']) ? $postData['password'] : '';
    }
    
    if (empty($username) && isset($_POST['username'])) {
        $username = str_text($_POST['username']);
    }
    if (empty($password) && isset($_POST['password'])) {
        $password = $_POST['password'];
    }
}

// Also check GET for testing
if (empty($username) && isset($_GET['username'])) {
    $username = str_text($_GET['username']);
}
if (empty($password) && isset($_GET['password'])) {
    $password = $_GET['password'];
}

if (empty($username) || empty($password)) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => 'Vui lòng nhập đầy đủ thông tin'
    ]);
    exit();
}

try {
    // Check MongoDB for account
    $mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
    $accountdb = $mongodb->selectDatabase('account');
    $acc = $accountdb->selectCollection('Account');
    
    $mongoAccount = $acc->findOne([
        'name' => $username,
        'pass_md5' => $password
    ]);

    if ($mongoAccount) {
        $account_id = (string)$mongoAccount['_id'];
        $ip = getIP();
        
        // Check if account exists in MySQL
        $checkAccount = $database->has("account", [
            "username" => $username
        ]);
        
        if (!$checkAccount) {
            // Create account in MySQL
            $database->insert("account", [
                "username" => $username,
                "password" => $password,
                "regDate" => $date,
                "lastLoginIP" => $ip,
                "lastTimeLogin" => $date,
                "account_id" => $account_id,
                "xu" => 0,
            ]);
        }
        
        // Update last login
        $database->update("account", [
            "lastLoginIP" => $ip,
            "lastTimeLogin" => $date,
            "LastTimeUpdate" => time()
        ], [
            "username" => $username
        ]);
        
        // Get user data
        $userData = $database->get("account", [
            "id",
            "username",
            "account_id",
            "email",
            "phone",
            "xu"
        ], [
            "username" => $username
        ]);
        
        // Generate token (simple, can be improved)
        $token = base64_encode($username . ':' . time());
        
        http_response_code(200);
        echo json_encode([
            'status' => 'success',
            'message' => 'Đăng nhập thành công',
            'data' => [
                'username' => $userData['username'],
                'account_id' => $userData['account_id'],
                'email' => $userData['email'] ?? '',
                'phone' => $userData['phone'] ?? '',
                'balance' => (float)$userData['xu'],
                'token' => $token
            ]
        ]);
    } else {
        http_response_code(401);
        echo json_encode([
            'status' => 'error',
            'message' => 'Sai thông tin đăng nhập'
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Lỗi server: ' . $e->getMessage()
    ]);
}
?>
