<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include '../../../config/config.php';
require '../../../vendor/autoload.php';

// Get Authorization header
$headers = getallheaders();
$authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : (isset($_SERVER['HTTP_AUTHORIZATION']) ? $_SERVER['HTTP_AUTHORIZATION'] : '');

// Extract token from Bearer token
$token = '';
if (!empty($authHeader) && preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
    $token = $matches[1];
}

// If no token, try to get from username in request
// Token in Authorization header should be the username
$username = !empty($token) ? $token : (isset($_GET['username']) ? str_text($_GET['username']) : '');

if (empty($username)) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Unauthorized: Missing token or username'
    ]);
    exit();
}

// Get user info from database
try {
    $userData = $database->get("account", [
        "id",
        "username",
        "account_id",
        "email",
        "phone",
        "regDate",
        "xu",
        "lastTimeLogin",
        "LastLoginIP",
        "LastTimeUpdate"
    ], [
        "OR" => [
            "username" => $username,
            "account_id" => $username
        ]
    ]);

    if ($userData) {
        // Get MongoDB account info if available
        $mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
        $accountdb = $mongodb->selectDatabase('account');
        $acc = $accountdb->selectCollection('Account');
        
        $mongoAccount = null;
        if (!empty($userData['account_id'])) {
            try {
                $mongoAccount = $acc->findOne(['_id' => new MongoDB\BSON\ObjectId($userData['account_id'])]);
            } catch (Exception $e) {
                // MongoDB lookup failed, continue without it
            }
        }

        // Prepare response data
        $responseData = [
            'id' => (string)$userData['id'],
            'username' => $userData['username'],
            'account_id' => $userData['account_id'],
            'email' => $userData['email'] ?? '',
            'phone' => $userData['phone'] ?? '',
            'balance' => (float)$userData['xu'],
            'registered_date' => $userData['regDate'],
            'last_login' => $userData['lastTimeLogin'],
            'last_login_ip' => $userData['LastLoginIP'] ?? '',
        ];

        // Add role information if available from MongoDB
        if ($mongoAccount && isset($mongoAccount['role_infos'])) {
            $responseData['roles'] = [];
            foreach ($mongoAccount['role_infos'] as $serverKey => $roleInfo) {
                $responseData['roles'][] = [
                    'server' => $serverKey,
                    'name' => $roleInfo['name'] ?? '',
                    'level' => $roleInfo['level'] ?? 0,
                    'vip' => $roleInfo['vip'] ?? 0,
                ];
            }
        }

        http_response_code(200);
        echo json_encode([
            'status' => 'success',
            'data' => $responseData
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            'status' => 'error',
            'message' => 'User not found'
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Internal server error: ' . $e->getMessage()
    ]);
}
?>

