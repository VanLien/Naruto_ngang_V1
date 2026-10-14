<?php
include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';

//get rule form file txt
$rule = file_get_contents('rule.txt');
echo $rule;

?>
