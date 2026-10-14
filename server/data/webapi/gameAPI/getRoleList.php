<?php 
include ('../config/config.php');
require '../vendor/autoload.php';
$mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");

$user = str_text($_REQUEST['username']);
$password = str_text($_REQUEST['password']);

$server = $_REQUEST['server'];
//get MongoDb
$accountdb = $mongodb->selectDatabase('account');
$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');
$isAccount = $acc->findOne(
	[
		'name' => $user
	]
);


// Kiểm tra và lấy `oid` từ `game.cn.1`
if ($isAccount && isset($isAccount['role_infos'][$server]['id'])) {
    $oid = (string)$isAccount['role_infos'][$server]['id'];
    $roleName = $isAccount['role_infos'][$server]['name'];
    echo '<input type="hidden" name="roleName" value="' . $roleName . '">';
    echo '<select class="form-control select-control" name="roleID" required="">';
    echo '<option value="' . $oid . '">' . $roleName . '</option>';
    echo '</select>';
    exit();
} else {
    echo '<select class="form-control select-control" name="roleName" required="">';
    echo '<option value="">Chưa có nhân vật</option>';
    echo '</select>';
    exit();
}


?>