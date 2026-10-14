<?php
include ('../config/config.php');
require '../vendor/autoload.php';


$server = str_text($_REQUEST['server']);

$pay = curlPost("http://180.93.98.5:39666/shuma/updateRole",
array(
    "salt" => "@tj1shuma2tc@",
    'serv'=>'game.cn.1'
));
echo $pay;
?>
