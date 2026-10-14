<?php 
// require 'vendor/autoload.php';
// $mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
// $accountdb = $mongodb->selectDatabase('account');
// $accountdb = $mongodb->selectDatabase('account');
// $acc = $accountdb->selectCollection('Account');

// $newpassword = "test";
// $updatedResult = $acc->updateOne(
//     ['_id' => new MongoDB\BSON\ObjectId('6687bf579bb97f6d522d7659')],
//     ['$set' => [
//             'pass_md5' => "test",
//         ],
//     ]
// );

// //dump
// var_dump($updatedResult);
// die();
include ("config/config.php");
$account_id = "668c26809bb97f6d522d768c";
$orderId = "668c26819bb97f6d40b56c0d1720464006";
$amount = 3600.00;
$game_extra = ["668c26809bb97f6d522d768c","668c26819bb97f6d40b56c0d","game.cn.1",3111,0,0];
$createCode =   curlPost("http://180.93.98.5:28081/tjgame/create",
array(
    "accountId" => $account_id,
    "orderStatus" => 1,
    "orderId" => $orderId,
    "amount" => $amount,
    "game_extra" => $game_extra
));
$paycode = json_decode($createCode);
$codePay =  $paycode->content;
$pay = curlPost("http://180.93.98.5:28081/tjgame/payment",
array("code"=>$codePay));

var_dump($codePay);
?>
