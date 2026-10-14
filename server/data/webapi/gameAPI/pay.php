<?php
include('../config/config.php');

$postData = POSTDATA($_POST);

$key = "Poke@123";
function POSTDATA($out) { //Hàm kiểm tra callback từ sever
	if(isset(
		$out['accountId'],
        $out['paykey'],
		$out['orderid'],
		$out['amount'],
        $out['product'],
		$out['d'],
		$out['e'],
		$out['f'],
		$out['g'],
        $out['h'],
        $out['i'],
        $out['game_extra']
		)) {
		return $out; //xác thực thành công, return mảng dữ liệu từ sever trả về.
	} else {
		return false; //Xác thực callback thất bại.
	}
}
function logthe($content)
{
			# Lưu log Nạp Thẻ 
		$file = "log.txt";
        $fh = fopen($file,'a') or die("cant open file");
	    fwrite($fh,$content);
	    fwrite($fh,"\r\n");
        fclose($fh);		
		
}

//check account_id

$account_id = $postData['accountId'];
$amount = $postData['amount'];
$paykey = $postData['paykey'];
$orderId = $postData['orderid'];
$game_extra = $postData['game_extra'];
$array = json_decode($game_extra, true);
$rechageID = $array[3];

$price = getRecharePricebyID($rechageID);
$rechargeName = getRechareNamebyID($rechageID);
if($price == 0) {
    logthe("Không tìm thấy giá trị nạp thẻ".$account_id);
    $json['code'] = 1;
    //$json['msg'] = "Thông tin sai";
    echo json_encode($json);
    exit();
}

logthe($game_extra."-  orderid : ".$orderId." amout : ".$amount." accountid : ".$account_id);
if($key != $paykey)
{
    logthe("Key pay sai".$account_id);
    $json['code'] = 1;
    //$json['msg'] = "Thông tin sai";
    echo json_encode($json);
    exit();
}

$CheckAccount = $database->has("account", [
    "account_id" => $account_id
]);


if($CheckAccount)
{

    $dataUser = $database->get("account", [
        "id",
        "username",
        "account_id",
        "email",
        "phone",
        "regDate",
        "xu",
        "pass2",
        "lastTimeLogin",
        "LastLoginIP",
        "LastTimeUpdate"
    ], [
    "account_id" => $account_id
    ]);



    

    $xu = $dataUser['xu'];
    $check =1;
    if ($xu < $price)
    {
        $check = 0;
        $json['code'] = 1;
        //$json['msg'] = "Tài khoản không đủ XU";
        echo json_encode($json);
        exit();
    }
    if($dataUser['xu'] < 0)
    {
        $check = 0;
        $json['code'] = 1;
        //$json['msg'] = "Tài khoản không đủ XU";
        echo json_encode($json);
        exit();
    }

    
    if (intval((time() - $dataUser['LastTimeUpdate'])) < 5) {
        $check = 0;
        $json['code'] = 2;
        //$json['msg'] = "Bạn thao tác quá nhanh";
        echo json_encode($json);
        exit();
    }


    else
    {

        if ($check) {
            logthe("CALL API");
                    //	local params = string.format("accountId=%s&orderStatus=1&orderId=%s&amount=%.2f&game_extra=%s",
            $createCode =   curlPost("http://180.93.98.5:28081/tjgame/create",
            array(
                "accountId" => $account_id,
                "orderStatus" => 1,
                "orderId" => $orderId,
                "amount" => $amount,
                "game_extra" => $game_extra,
                "paykey"=>"Poke123"
            ));
            logthe("Create Code: " . $createCode);
			logthe("Create $amount: " . $amount);
        
             // Tìm vị trí bắt đầu của content
            $start = strpos($createCode, '"content":') + 10;
            // Tìm vị trí bắt đầu của dấu ngoặc kép đầu tiên sau "content":
            $start = strpos($createCode, '"', $start) + 1;
            // Tìm vị trí của dấu ngoặc kép kết thúc
            $end = strpos($createCode, '"', $start);
            // Lấy giá trị của content
            $content = substr($createCode, $start, $end - $start);
            logthe("Pay Code: " . $content); // In ra "2c5685c3"
           
            $pay = curlPost("http://180.93.98.5:28081/tjgame/payment",
            array(
                "accountId" => $account_id,
                "orderStatus" => 1,
                "orderId" => $orderId,
                "amount" => $amount,
                "game_extra" => $game_extra,
                "paykey"=>"Poke123",
                "code"=>$content
            ));
           
            $checkStatus = json_decode($pay);
            logthe("Pay check: " . $checkStatus->data);
           
            if($checkStatus->data == "Ok")
            {
                logthe("Sử lý giao dịch thành công");
				logthe($accountId);
                $data = $database->update("account", [
                    "xu[-]" => $price,
                    "LastTimeUpdate" => time()
                ], [
                    "account_id" => $account_id
                ]);
                $username = getUsernameByAccountID($account_id);
                $insert = $database->insert("log_rechagre", [
                    "rechargeID" => $rechageID,
                    "rechargeName" => $rechargeName,
                    "rechargePrice" => $price,
                    "timeDate" => $date,
                    "username" => $username,
                    "account_id" => $account_id,
                ]);

                #logthe("Check pay " + $pay);
                $json['code'] = 0;
                echo json_encode($json);
                exit();
            }else {

                $check = 0;
                logthe("Không gọi dc GM chưa trừ xu");
                $json['code'] = 3;
                echo json_encode($json);
                exit();
                // lỗi ko gọi dc GM
            }

        } else {
            $json['code'] = 3;
            echo json_encode($json);
            exit();
            //$json['msg'] = "Lỗi không xác định";
        }
    }
 

}else 
{
     $json['code'] = 1;
    //$json['msg'] = "Tài khoản không đủ XU";
    echo json_encode($json);
    exit();
}

?>