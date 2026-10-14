<?php
// Suppress any output before headers
ob_start();

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    ob_end_clean();
    http_response_code(200);
    exit();
}

include '../../../config/config.php';
require '../../../vendor/autoload.php';

// Clean any output that might have been generated
ob_end_clean();

// Log request for debugging
error_log("deduct-balance.php - Method: " . $_SERVER['REQUEST_METHOD']);

// Get request data
$username = '';
$amount = 0;

// Check GET parameters first
if (isset($_GET['username']) && !empty($_GET['username'])) {
    $username = str_text($_GET['username']);
}
if (isset($_GET['amount']) && !empty($_GET['amount'])) {
    $amount = floatval($_GET['amount']);
}

// Try POST data
if (empty($username) || $amount <= 0) {
    $rawInput = file_get_contents('php://input');
    $contentType = isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : '';
    
    if (strpos($contentType, 'application/json') !== false) {
        $postData = json_decode($rawInput, true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($postData)) {
            $username = isset($postData['username']) ? str_text($postData['username']) : $username;
            $amount = isset($postData['amount']) ? floatval($postData['amount']) : $amount;
        }
    } else {
        if (!empty($rawInput)) {
            parse_str($rawInput, $postData);
            $username = isset($postData['username']) ? str_text($postData['username']) : $username;
            $amount = isset($postData['amount']) ? floatval($postData['amount']) : $amount;
        }
        
        if (empty($username) && isset($_POST['username'])) {
            $username = str_text($_POST['username']);
        }
        if ($amount <= 0 && isset($_POST['amount'])) {
            $amount = floatval($_POST['amount']);
        }
    }
}

error_log("deduct-balance.php - Username: " . $username . ", Amount: " . $amount);

if (empty($username) || $amount <= 0) {
    http_response_code(400);
    echo json_encode([
        'ret' => false,
        'err' => 'Missing username or invalid amount',
        'view' => [
            'data' => [
                'money' => 0
            ]
        ]
    ]);
    exit();
}

try {
    // Get current balance
    $userData = $database->get("account", [
        "id",
        "username",
        "account_id",
        "xu"
    ], [
        "OR" => [
            "username" => $username,
            "account_id" => $username
        ]
    ]);

    if (!$userData) {
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
        exit();
    }

    $currentBalance = (float)$userData['xu'];
    
    // Check if user has enough balance
    if ($currentBalance < $amount) {
        http_response_code(400);
        echo json_encode([
            'ret' => false,
            'err' => 'Insufficient balance',
            'view' => [
                'data' => [
                    'money' => $currentBalance
                ]
            ]
        ]);
        exit();
    }

    // Deduct balance
    $newBalance = $currentBalance - $amount;
    $result = $database->update("account", [
        "xu" => $newBalance,
        "LastTimeUpdate" => time()
    ], [
        "AND" => [
            "OR" => [
                "username" => $username,
                "account_id" => $username
            ],
            "xu[>=]" => $amount  // Only update if balance is sufficient
        ]
    ]);

    if ($result) {
        // Success
        http_response_code(200);
        echo json_encode([
            'ret' => true,
            'view' => [
                'data' => [
                    'money' => $newBalance,
                    'username' => $userData['username'],
                    'account_id' => $userData['account_id'],
                    'deducted' => $amount,
                    'previous_balance' => $currentBalance
                ]
            ]
        ]);
    } else {
        // Failed to deduct (maybe balance changed)
        http_response_code(400);
        echo json_encode([
            'ret' => false,
            'err' => 'Failed to deduct balance',
            'view' => [
                'data' => [
                    'money' => $currentBalance
                ]
            ]
        ]);
    }
} catch (Exception $e) {
    error_log("deduct-balance.php - Exception: " . $e->getMessage());
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
    exit();
}
?>

