<?php 
header("Content-type:text/html; charset=utf8");
date_default_timezone_set('Asia/Ho_Chi_Minh');
error_reporting(1);
session_start();
require  "Medoo.php";
header("Access-Control-Allow-Origin: *"); // Hoặc thay * bằng http://localhost:3000
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
use Medoo\Medoo;

$database = new Medoo([
	// [required]
	'type' => 'mysql',
	'host' => 'localhost',
	'database' => 'sqlchimccdai',
	'username' => 'root',
	'password' => 'Djtcmmbulozcac',
 
	// [optional]
	'charset' => 'utf8',
	'collation' => 'utf8_general_ci',
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

$url_site = 'http://180.93.98.5'; // url site
$title = 'HUYỀN THOẠI NHẪN GIẢ'; // title web
$des_site = "HUYỀN THOẠI NHẪN GIẢ"; 
$gamename = 'HUYỀN THOẠI NHẪN GIẢ';  // ten game
$hotline = '0123456789'; // sdt hotline 
$url_trangchu = '/'; // link trang chu
$url_napthe= '';
$url_fanpage = 'https://sourcegame.net/';  // fanpage
$url_zalo = 'https://sourcegame.net/';  // fanpage
$url_taigame = '/download/NarutoRelease.apk';  // link tai game

$key = 'thienlongthanma-4mcode';


$eventTichLuy = false; // event tích lũy
$startTichLuy = getConfig('startTichLuy'); // start event tich luy
$endTichLuy = getConfig('endTichLuy'); // end start event tich luy
if(strtotime($startTichLuy) <= time() && time() <= strtotime($endTichLuy)) {
	$eventTichLuy = true;
}

$eventGacha = false; // event gacha
$url_gacha = getConfig('url_gacha'); // link event gacha
$startGacha = getConfig('startGacha'); // start event gacha
$endGacha = getConfig('endGacha'); // end event gacha
if(strtotime($startGacha) <= time() && time() <= strtotime($endGacha)) {
	$eventGacha = true;
}

$tyle_khuyenmai = 0.001; // tỷ lệ khuyến mãi
$startKhuyenmai = getConfig('startKhuyenmai'); // start khuyến mãi
$endKhuyenmai = getConfig('endKhuyenmai'); // end khuyến mãi
if(strtotime($startKhuyenmai) <= time() && time() <= strtotime($endKhuyenmai)) {
	$tyle_khuyenmai = getConfig('tyle_khuyenmai'); // tỷ lệ khuyến mãi
}



$bot_token = '6178481321:AAEfS6b7LH_f7ZrCuHAXg2YluJKYcZ-qAiM'; // Thay bằng token của 
$chat_id   = '-4792182475';   // Thay bằng chat ID hoặc group ID  muốn gửi tin nhắn
$int_xu = 0;
$int_email  = "testsrc@gmail.com";
//api key TheSieuToc.Net
$apikey = "06B5ED689AD501BB2E45371233EAC961";  // key thesieutoc.net
function movePage($url) {
	die('<script type="text/javascript">window.location="'.$url.'"</script>');
}
$date = date("Y-m-d h:i:sa");
function logOut() {
	unset($_SESSION['username']);
}


function sendMessagetoDiscord($message) {
    $webhookUrl = 'https://discord.com/api/webhooks/1390882526146465862/Sq_FBnxIDjOF8S8SI_YoeU9vVRmbN_GErSTjIhcINdgEzXannlVHrreO0znYUUemt3ta'; // Thay bằng URL webhook của bạn

	// Nội dung tin nhắn
	$data = [
		"content" => $message
	];

	// Khởi tạo cURL session
	$ch = curl_init($webhookUrl);

	// Cấu hình cURL
	curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

	// Gửi yêu cầu và nhận phản hồi
	$response = curl_exec($ch);

	// Kiểm tra lỗi cURL
	if(curl_errno($ch)) {
		echo 'cURL Error: ' . curl_error($ch);
	} else {
		echo "Tin nhắn đã được gửi!";
	}

	// Đóng cURL
	curl_close($ch);

}


function isSuperAdmin($username){
    global $database;
    $infoAdmin  = $database->get(
        'admin',"*",
        [
            'username' => $username
        ]
    );
    if($infoAdmin['role'] == 99){
        return true;
    }else{
        return false;
    }
}
function getDateTime($datetime)
{
	// Tạo đối tượng DateTime từ chuỗi
$date = new DateTime($datetime);

// Lấy ngày, tháng và năm dưới dạng chuỗi
$dateString = $date->format('Y-m-d');

echo $dateString; // In ra "2024-07-08"
}
function createSign($time,$sign)
{
    $out = '<input id="time" type="hidden" class="form-control  " hidden name="time" value="'.$time.'" >
    <input id="sign" type="hidden" class="form-control  " hidden name="sign" value="'.$sign.'" >';
    return $out;
}

function getConfig($key){
	global $database;
	try {
		// Sử dụng raw SQL query để tránh escape ký tự đặc biệt
		$pdo = $database->pdo;
		$stmt = $pdo->prepare("SELECT value FROM config WHERE `key` = ?");
		$stmt->execute([$key]);
		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		return $result ? $result['value'] : null;
	} catch (Exception $e) {
		error_log("Error getting config: " . $e->getMessage());
		return null;
	}
}

function updateConfig($key,$value){
	global $database;
	try {
		// Sử dụng raw SQL query để tránh escape ký tự đặc biệt
		$pdo = $database->pdo;
		$stmt = $pdo->prepare("UPDATE config SET value = ? WHERE `key` = ?");
		$result = $stmt->execute([$value, $key]);
		return $result;
	} catch (Exception $e) {
		error_log("Error updating config: " . $e->getMessage());
		return false;
	}
}

function sendMessageToTelegram($message, $chat_id, $bot_token) {
    $url = "https://api.telegram.org/bot" . $bot_token . "/sendMessage";

    // Cấu hình dữ liệu cần gửi
    $data = [
        'chat_id' => $chat_id,
        'text'    => $message
    ];

    // Sử dụng cURL để gửi yêu cầu tới Telegram API
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $response = curl_exec($ch);

    // Kiểm tra lỗi cURL
    if (curl_errno($ch)) {
        echo 'Error:' . curl_error($ch);
    }

    curl_close($ch);

    // In ra kết quả phản hồi từ Telegram
    return json_decode($response, true);
}



function getIP()
{

//whether ip is from share internet
if (!empty($_SERVER['HTTP_CLIENT_IP']))   
  {
    $ip_address = $_SERVER['HTTP_CLIENT_IP'];
  }
//whether ip is from proxy
elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))  
  {
    $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'];
  }
//whether ip is from remote address
else
  {
    $ip_address = $_SERVER['REMOTE_ADDR'];
  }
return $ip_address;

}


function http_post($url, $data = NULL , $cookie ="") {

	$curl = curl_init();

	curl_setopt($curl, CURLOPT_URL, $url);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
	
	if($data=="" ){
		$data = "{}";
	}
	if(is_array($data))
	{
		$data = json_encode($data,JSON_UNESCAPED_UNICODE);
	}

	$dataLen = strlen($data);
	curl_setopt($curl, CURLOPT_POST, 1);
	curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
	curl_setopt($curl, CURLOPT_HEADER, 0);
	curl_setopt($curl, CURLOPT_COOKIE,$cookie);
	curl_setopt($curl, CURLOPT_HTTPHEADER,array(
			"Content-Encoding: gzip",
			'Content-Type: application/json',
			"Content-Length: {$dataLen}" ,
	
	));
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	$res = curl_exec($curl);
	$errorno = curl_errno($curl);
	if ($errorno) {
		return $errorno;
	}
	curl_close($curl);
	return $res;

}





function loginGetCookie($url,$user,$pswd){
	$url = $url."/login";
	 $ch = curl_init($url); 
	 $post = array(
	  "username" => "$user" ,
	  "password" =>  "$pswd",
	);
	
	  curl_setopt($ch, CURLOPT_HEADER, 1);
	  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
	  curl_setopt($ch, CURLOPT_POSTFIELDS, $post); 
	  $content=curl_exec($ch);
	  preg_match('/Set-Cookie:(.*);/iU',$content,$str); 
	  $cookie = $str[1]; //获得COOKIE
	  return $cookie;
}


function sendMail($url,$rid,$cookie,$itema,$num,$srv_name,$title="",$content=""){

$mailApiUrl =$url."/sendmail";//API的位置
$title == "" && $title="GM";
$content == "" && $content="GM Gửi thư";
$items=array($itema=>(int)$num);
$meta = array();
$meta['servName'] = $srv_name;
$meta['receive'] =  $rid;  
$meta['mailTemp'] = "2";
$meta['mailType'] = "role";
$meta['sender'] = "GM";
$meta['subject'] = $title;
$meta['content'] = $content;
$meta['attachs'] = json_encode($items,JSON_UNESCAPED_UNICODE);
$meta['beginVip'] = null;
$meta['endVip'] = null;


$retJson  = http_post($mailApiUrl,$meta,$cookie); 
 $jsonData = json_decode($retJson,true);

if($jsonData['retS'] == ""){
  return false;
}

if( in_array($rid, $jsonData['retS'])){
	return true;
}else{
   return false;
}


}


if (!function_exists('getallheaders')) {
    function getallheaders() {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        return $headers;
    }
}



function string_var($string) {
    $filtered_string = $string;
    $filtered_string = str_replace("--","",$filtered_string);
    $filtered_string = str_replace(";","",$filtered_string);
    $filtered_string = str_replace("/*","",$filtered_string);
    $filtered_string = str_replace("*/","",$filtered_string);
    $filtered_string = str_replace("//","",$filtered_string);
    $filtered_string = str_replace(" ","",$filtered_string);
    $filtered_string = str_replace("#","",$filtered_string);
    $filtered_string = str_replace("||","",$filtered_string);
    $filtered_string = str_replace("admin'","",$filtered_string);
    $filtered_string = str_replace("UNION","",$filtered_string);
    $filtered_string = str_replace("COLLATE","",$filtered_string);
    $filtered_string = str_replace("DROP","",$filtered_string);
    return $filtered_string;
}



function str_text($text) {
	global $conn;
	//$text = mysqli_real_escape_string($conn, $text);
	$text = addslashes($text);
	$text = strip_tags($text);
	
	$text = str_replace([':', ';', ',', '<', '>', '{', '}'], '', $text);
	return $text;
}
 function AddUserHistory($username,$content,$type = 'NULL')
 {

	 global $database;
	 global $date;
		 $insert = $database->insert("history", [
		 "cAccName" => $username,
		 "Content" => $content,
		 "timeDate" => $date,
		 "type" => $type
	 ]);

 }

 function addLuotQuay($username,$sotien) {
	global $database;
	global $date;
    // Tính số điểm thưởng theo công thức 10000 = 1 điểm và chỉ lấy phần nguyên
    $luotquay = floor($sotien / 10000);

	$isPlayGacha = $database->has("event_gacha", [
        "username" => $username
    ]);

    if (!$isPlayGacha) {
        $database->insert("event_gacha", [
            "username" => $username,
            "point" => 0,
            "luotquay" => 0,
            "luotquay_count" => 0,
        ]);
    }

	$database->update("event_gacha", [
		"luotquay[+]" => $luotquay
	], [
		"username" => $username
	]);

	AddUserHistory($username,'Nhận '.$luotquay.' lượt quay từ nạp '.$sotien.' Xu','TopUP');

    return $luotquay;

}





 function createQR($sotien,$noidung) {
	global $database;
	$data = array(
		"accountNo" => "1751712345" ,
		"accountName" => "NGUYEN VAN NGHIA" ,
		"acqId" => "970422",
		"addInfo" => $noidung,
		"amount" => $sotien,
		"template" => "compact",
	);
	$url = 'https://api.vietqr.io/v2/generate';
	$api_key = 'we-l0v3-v1et-qr';
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
	 curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, TRUE);
	curl_setopt($ch, CURLOPT_POST, TRUE);
	curl_setopt($ch, CURLOPT_HEADER, TRUE);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
	curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
		'x-client-id:taikhoan.tieudaokiem.net',
		'Content-Type: application/json',
		'X-API-KEY:'.$api_key
	));         
	
	$response = curl_exec($ch);
	
	$test = preg_split('/(.*), (.*)/', $response);
	$check = json_decode($test[2]);
	$img = $check->data->qrDataURL;
	return $img;
}

function getUserRef($ref) {
	global $database;
	global $date;
	$UserDB = $database->query("SELECT *  FROM account WHERE id='{$ref}'")->fetchAll();
	return $UserDB;
 }

 function giveRef($username,$amout) {
	global $database;
	global $date;
	$UserDB = $database->query("SELECT *  FROM account WHERE loginName='{$username}'")->fetchAll();
	foreach($UserDB as $user)
	{
		$ref_id =$user['ref']; 
	}

	$updateUser = $database->update("account", [
		"xu[+]" => $amout
	], [
		"id" => $ref_id
	]);

	$user_ref = getUserRef($ref_id);
	foreach($user_ref as $userDB)
	{
		$username_ref = $userDB['loginName'];
	}
	
	$content = 'Được nhận '.$amout.' xu từ '.$username.'';
	AddUserHistory($username_ref,$content,'Ref');
 }


 

 function logAdmin($username,$content)
 {
	 global $database;
	 global $date;

	 $insert = $database->insert("admin_history", [
		 "cAccName" => $username,
		 "Content" => $content,
		 "timeDate" => $date
	 ]);

 }

 function getSumNap($username) {
	global $database;
	global $date;
	$getTong = $database->query("SELECT SUM(menhgia) as TongTien FROM card WHERE username='{$username}' and trangthai=2")->fetchAll();
	$tong  = $getTong[0]["TongTien"];
	return  $tong;

 }

function getModRef($username){
	global $database;
	$UserDB = $database->query("SELECT *  FROM mod_user WHERE id='2'")->fetchAll();
	foreach($UserDB as $user)
	{
		$listacc =$user['username']; 
	}
	$listAcc_arr =  (explode(",",$listacc));
	if (in_array($username,  $listAcc_arr))
	{
		$modref = 1;
	}else {
		$modref = 0;
	}
	return $modref;
}


function getRecharePricebyID($id){
	global $database;
	$data = $database->get("rechagre", [
        "id",
        "rechargeID",
        "rechargeName",
        "rechargrePrice",
    ], [
    "rechargeID" => $id
    ]);
	if($data)
	{
		return $data['rechargrePrice'];
	}else {
		return 0;
	}
}

function getRechareNamebyID($id){
	global $database;
	$data = $database->get("rechagre", [
        "id",
        "rechargeID",
        "rechargeName",
        "rechargrePrice",
    ], [
    "rechargeID" => $id
    ]);
	if($data)
	{
		return $data['rechargeName'];
	}else {
		return 0;
	}
}


function getUsernameByAccountID($id){
	global $database;
	$data = $database->get("account", [
        "id",
        "username"
    ], [
    "account_id" => $id
    ]);
	if($data)
	{
		return $data['username'];
	}else {
		return 0;
	}
}


function getSumNapbyDate($username,$startDate,$endDate) {
	global $database;
	global $date;
	$getTong = $database->query("
    SELECT SUM(menhgia) as TongTien 
    FROM card 
    WHERE username = '{$username}' 
    AND trangthai = 2 
    AND created_at BETWEEN '{$startDate}' AND '{$endDate}'
	")->fetchAll();
	$tong  = $getTong[0]["TongTien"];
	return  $tong;
 }



 function getUuDaiNap($username) {
	$username = strtolower($username);
	$tongnap = intval(getSumNap($username));
	$tongnap = $tongnap/1000;
	global $database;
	global $date;
	$UserDB = $database->query("SELECT *  FROM mod_user WHERE id='1'")->fetchAll();
	$UserDB2 = $database->query("SELECT *  FROM mod_user WHERE id='3'")->fetchAll();
	foreach($UserDB as $user)
	{
		$listacc = strtolower($user['username']); 
	}

	foreach($UserDB2 as $user2)
	{
		$listacc2 =strtolower($user2['username']); 
	}
	$listAcc_arr =  explode(",",$listacc);
	$listAcc_arr2 =  explode(",",$listacc2);

	if (in_array($username,  $listAcc_arr))
	{
		$uudai = 30;

	}

	  else
	  {
		if ($tongnap >= 40000 )
		{
			$uudai = 30;
		}elseif ( $tongnap >= 30000)
		{
			$uudai = 25;
		}elseif( $tongnap >= 20000)
		{
			$uudai = 20;
		}elseif($tongnap >= 15000)
		{
			$uudai = 15;
		}elseif($tongnap >= 10000)
		{
			$uudai = 10;
		}elseif($tongnap >= 5000)
		{
			$uudai = 5;
		}else {
			$uudai = 0;
		}
		if (in_array($username,  $listAcc_arr2))
			{
				$uudai = $uudai + 10;
				if ($uudai > 30)
				{
					$uudai = 30;
				}
			}
	
	  }


	return $uudai;
	
 }

 function humnanDate($datetime)
 {

// Tạo đối tượng DateTime từ chuỗi ngày giờ
$date = new DateTime($datetime);

// Chuyển đổi định dạng ngày giờ sang ngày/tháng/năm
$formattedDate = $date->format('d/m/Y H:i:s');

// Hiển thị kết quả
return  $formattedDate; // Kết quả sẽ là: 14/07/2024
 }
 function getTyLeNapKhuyenMai($username,$amount)
 {
	$uudai = getUuDaiNap($username);

	$sotien = (($amount*$uudai)/100)/1000;

	return $sotien;
 }
 
function getBrowser() { 
	$u_agent = $_SERVER['HTTP_USER_AGENT'];
	$bname = 'Unknown';
	$platform = 'Unknown';
	$version= "";
  
	//First get the platform?
	if (preg_match('/linux/i', $u_agent)) {
	  $platform = 'linux';
	}elseif (preg_match('/macintosh|mac os x/i', $u_agent)) {
	  $platform = 'mac';
	}elseif (preg_match('/windows|win32/i', $u_agent)) {
	  $platform = 'windows';
	}
  
	// Next get the name of the useragent yes seperately and for good reason
	if(preg_match('/MSIE/i',$u_agent) && !preg_match('/Opera/i',$u_agent)){
	  $bname = 'Internet Explorer';
	  $ub = "MSIE";
	}elseif(preg_match('/Firefox/i',$u_agent)){
	  $bname = 'Mozilla Firefox';
	  $ub = "Firefox";
	}elseif(preg_match('/OPR/i',$u_agent)){
	  $bname = 'Opera';
	  $ub = "Opera";
	}elseif(preg_match('/Chrome/i',$u_agent) && !preg_match('/Edge/i',$u_agent)){
	  $bname = 'Google Chrome';
	  $ub = "Chrome";
	}elseif(preg_match('/Safari/i',$u_agent) && !preg_match('/Edge/i',$u_agent)){
	  $bname = 'Apple Safari';
	  $ub = "Safari";
	}elseif(preg_match('/Netscape/i',$u_agent)){
	  $bname = 'Netscape';
	  $ub = "Netscape";
	}elseif(preg_match('/Edge/i',$u_agent)){
	  $bname = 'Edge';
	  $ub = "Edge";
	}elseif(preg_match('/Trident/i',$u_agent)){
	  $bname = 'Internet Explorer';
	  $ub = "MSIE";
	}
  
	// finally get the correct version number
	$known = array('Version', $ub, 'other');
	$pattern = '#(?<browser>' . join('|', $known) .
  ')[/ ]+(?<version>[0-9.|a-zA-Z.]*)#';
	if (!preg_match_all($pattern, $u_agent, $matches)) {
	  // we have no matching number just continue
	}
	// see how many we have
	$i = count($matches['browser']);
	if ($i != 1) {
	  //we will have two since we are not using 'other' argument yet
	  //see if version is before or after the name
	  if (strripos($u_agent,"Version") < strripos($u_agent,$ub)){
		  $version= $matches['version'][0];
	  }else {
		  $version= $matches['version'][1];
	  }
	}else {
	  $version= $matches['version'][0];
	}
  
	// check if we have a number
	if ($version==null || $version=="") {$version="?";}
  
	return array(
	  'userAgent' => $u_agent,
	  'name'      => $bname,
	  'version'   => $version,
	  'platform'  => $platform,
	  'pattern'    => $pattern
	);
  } 
  
  function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function hideString($string) {
	$length = strlen($string);
	$hide = substr($string, 0, 3);
	$hide .= str_repeat('*', $length - 6);
	$hide .= substr($string, -3);
	return $hide;
}




function curlPost($url, $postData) {
    // Khởi tạo cURL session
    $ch = curl_init();

    // Cấu hình các tùy chọn cho cURL
    curl_setopt($ch, CURLOPT_URL, $url); // URL mà bạn muốn gửi POST request
    curl_setopt($ch, CURLOPT_POST, 1); // Thiết lập phương thức POST
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData)); // Dữ liệu POST
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // Trả về kết quả dưới dạng chuỗi

    // Thực hiện yêu cầu cURL và lưu kết quả vào biến $response
    $response = curl_exec($ch);

    // Kiểm tra xem có lỗi xảy ra hay không
    if (curl_errno($ch)) {
        echo 'Error:' . curl_error($ch);
    }

    // Đóng cURL session
    curl_close($ch);

    // Trả về kết quả
    return $response;
}


?>

