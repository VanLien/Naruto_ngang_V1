<?php 
header("Content-type:text/html; charset=utf8");
date_default_timezone_set('Asia/Ho_Chi_Minh');
error_reporting(1);
session_start();
require  "Medoo.php";
use Medoo\Medoo;
$database = new Medoo([
	// [required]
	'type' => 'mysql',
	'host' => '14.225.217.122',
	'database' => 'global_logserver',
	'username' => 'root',
	'password' => '0G#%tosdfwr2qAS',
 
	// [optional]
	'charset' => 'latin1',
	'collation' => 'latin1_general_ci',
	'port' => 3306,
 
	// Read more from https://www.php.net/manual/en/pdo.error-handling.php.
	'error' => PDO::ERRMODE_SILENT,
 
	// [optional]
	// The driver_option for connection.
	// Read more from http://www.php.net/manual/en/pdo.setattribute.php.
	'option' => [
		PDO::ATTR_CASE => PDO::CASE_NATURAL
	],
 
	// [optional] Medoo will execute those commands after connected to the database.
	'command' => [
		'SET SQL_MODE=ANSI_QUOTES'
	]
]);

function getRolebyUser($username) {
	global $database;
	$getTong = $database->query("SELECT SUM(menhgia) as TongTien FROM card WHERE username='{$username}' and trangthai=2")->fetchAll();
	$tong  = $getTong[0]["TongTien"];
	return  $tong;

}

?>

