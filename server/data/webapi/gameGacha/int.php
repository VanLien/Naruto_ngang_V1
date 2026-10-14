<?php
include ('../config/config.php');
//$eventGacha = true;
$json['status'] = $eventGacha;
$humanDateStart = date("d.m", strtotime(getConfig("startGacha")));   
$json['startDate'] = $humanDateStart;
$humanDateEnd = date("d.m", strtotime(getConfig("endGacha")));
$json['endDate'] = $humanDateEnd;
$json['url_gacha'] = $url_gacha;
$json['rank'] = getConfig("rankGacha");
echo json_encode($json);
exit();
?>