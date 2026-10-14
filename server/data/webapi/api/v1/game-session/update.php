<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include '../../../config/config.php';

// Get Authorization header
$headers = getallheaders();
$authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : (isset($_SERVER['HTTP_AUTHORIZATION']) ? $_SERVER['HTTP_AUTHORIZATION'] : '');

// Extract token from Bearer token
$token = '';
if (!empty($authHeader) && preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
    $token = $matches[1];
}

// Get POST data
$rawInput = file_get_contents('php://input');
$postData = [];
parse_str($rawInput, $postData);

$username = isset($postData['username']) ? str_text($postData['username']) : $token;
$device = isset($postData['device']) ? intval($postData['device']) : 0;
$timestamp = isset($postData['timestamp']) ? intval($postData['timestamp']) : 0;
$signature = isset($postData['signature']) ? $postData['signature'] : '';

if (empty($username)) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Unauthorized: Missing username or token'
    ]);
    exit();
}

// Verify signature
$CLIENT_KEY = $key; // Use the key from config.php
$expectedRaw = sprintf("username=%s&device=%s&timestamp=%s&key=%s", $username, $device, $timestamp, $CLIENT_KEY);
$expectedSignature = hash('sha256', $expectedRaw);

if ($signature !== $expectedSignature) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid signature'
    ]);
    exit();
}

// Check timestamp (allow 5 minutes difference)
$currentTime = time();
if (abs($currentTime - $timestamp) > 300) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Request expired'
    ]);
    exit();
}

// Get or create user session
try {
    $userData = $database->get("account", [
        "id",
        "username",
        "account_id",
        "xu",
        "LastTimeUpdate"
    ], [
        "OR" => [
            "username" => $username,
            "account_id" => $username
        ]
    ]);

    if (!$userData) {
        http_response_code(404);
        echo json_encode([
            'status' => 'error',
            'message' => 'User not found'
        ]);
        exit();
    }

    // Update last update time
    $database->update("account", [
        "LastTimeUpdate" => time()
    ], [
        "username" => $userData['username']
    ]);

    // Determine device platform name
    $deviceName = 'unknown';
    if ($device == 1) {
        $deviceName = 'android';
    } elseif ($device == 2) {
        $deviceName = 'ios';
    } elseif ($device == 3) {
        $deviceName = 'other';
    }

    // Log session update
    AddUserHistory($userData['username'], "Game session updated - Device: $deviceName", 'Session');

    http_response_code(200);
    echo json_encode([
        'status' => 'success',
        'message' => 'Session updated successfully',
        'data' => [
            'username' => $userData['username'],
            'account_id' => $userData['account_id'],
            'device' => $deviceName,
            'updated_at' => date('Y-m-d H:i:s')
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Internal server error: ' . $e->getMessage()
    ]);
}
?>

