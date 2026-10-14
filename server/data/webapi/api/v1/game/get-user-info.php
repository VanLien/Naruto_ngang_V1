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

// Log request for debugging
error_log("get-user-info.php - Method: " . $_SERVER['REQUEST_METHOD']);
error_log("get-user-info.php - Content-Type: " . (isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : 'none'));
error_log("get-user-info.php - GET: " . json_encode($_GET));
error_log("get-user-info.php - POST: " . json_encode($_POST));

// Get request data - support both POST and GET
$username = '';

// Check GET parameters first
if (isset($_GET['username']) && !empty($_GET['username'])) {
    $username = str_text($_GET['username']);
} else {
    // Try POST data
    $rawInput = file_get_contents('php://input');
    
    // Check Content-Type header
    $contentType = isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : '';
    
    if (strpos($contentType, 'application/json') !== false) {
        // JSON body
        $postData = json_decode($rawInput, true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($postData)) {
            $username = isset($postData['username']) ? str_text($postData['username']) : '';
        }
    } else {
        // Form data or URL-encoded
        if (!empty($rawInput)) {
            parse_str($rawInput, $postData);
            $username = isset($postData['username']) ? str_text($postData['username']) : '';
        }
        
        // Also check $_POST
        if (empty($username) && isset($_POST['username'])) {
            $username = str_text($_POST['username']);
        }
    }
}

// Log extracted username
error_log("get-user-info.php - Extracted username: " . $username);

if (empty($username)) {
    http_response_code(400);
    echo json_encode([
        'ret' => false,
        'err' => 'Missing username',
        'view' => [
            'data' => [
                'money' => 0
            ]
        ]
    ]);
    exit();
}

try {
    // Get user data from MySQL
    $userData = $database->get("account", [
        "id",
        "username",
        "account_id",
        "xu",
        "email",
        "phone"
    ], [
        "OR" => [
            "username" => $username,
            "account_id" => $username
        ]
    ]);

    if ($userData) {
        $money = (float)$userData['xu'];
        
        // Return response in format expected by game server
        http_response_code(200);
        echo json_encode([
            'ret' => true,
            'view' => [
                'data' => [
                    'money' => $money,
                    'username' => $userData['username'],
                    'account_id' => $userData['account_id'],
                    'email' => $userData['email'] ?? '',
                    'phone' => $userData['phone'] ?? ''
                ]
            ]
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            'ret' => false,
            'err' => 'User not found',
            'view' => [
                'data' => [
                    'money' => 0
                ]
            ]
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'ret' => false,
        'err' => 'Internal server error: ' . $e->getMessage(),
        'view' => [
            'data' => [
                'money' => 0
            ]
        ]
    ]);
}
?>

