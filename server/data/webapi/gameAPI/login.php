<?php 
header('Content-Type: application/json; charset=utf-8');
include ('../config/config.php');
require '../vendor/autoload.php';

$mongodb = new MongoDB\Client("mongodb://admin:GpFkU9O24cjhnWco@127.0.0.1:27018");
$mongodb = new MongoDB\Client("mongodb://127.0.0.1:27018");
$username = trim($_REQUEST['username'] ?? '');
$password = trim($_REQUEST['password'] ?? '');

$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');

// Tìm account theo username trước
$getAcc = $acc->findOne(['name' => $username]);

$json = [];
$loginSuccess = false;

if($getAcc)
{
    $storedPassword = $getAcc['pass_md5'] ?? '';
    
    // Nếu pass_md5 rỗng, cho phép login và update password mới
    if($storedPassword === '' || $storedPassword === null)
    {
        // Update password mới cho account
        $acc->updateOne(
            ['name' => $username],
            ['$set' => ['pass_md5' => $password]]
        );
        $json['status'] = 0;
        $json['msg'] = 'Login thành công';
        $loginSuccess = true;
    }
    // Nếu có password, kiểm tra khớp
    else if($storedPassword === $password)
    {
        $json['status'] = 0;
        $json['msg'] = 'Login thành công';
        $loginSuccess = true;
    }
    else
    {
        $json['status'] = 1;
        $json['msg'] = 'Sai mật khẩu';
    }
    
    // Nếu login thành công, sync vào MySQL
    if($loginSuccess)
    {
        $account_id = (string) $getAcc['_id'];
        $ip = getIP();
        
        $CheckAccount = $database->has("account", [
            "username" => $username
        ]);
        
        if (!$CheckAccount) {
            // Insert mới vào MySQL
            $database->insert("account", [
                "username" => $username,
                "password" => $password,
                "regDate" => $date,
                "lastLoginIP" => $ip,
                "lastTimeLogin" => $date,
                "account_id" => $account_id,
                "xu" => 0,
            ]);
        } else {
            // Update thông tin login
            $database->update("account", [
                "password" => $password,
                "lastLoginIP" => $ip,
                "lastTimeLogin" => $date,
                "LastTimeUpdate" => time()
            ], [
                "username" => $username
            ]);
        }
    }
}
else
{
    $json['status'] = 1;
    $json['msg'] = 'Tài khoản không tồn tại';
}

echo json_encode($json, JSON_UNESCAPED_UNICODE);
?>