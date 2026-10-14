<?php 
include("config/config.php");
global $database;	
$MEMO_PREFIX = 'MANGA';


function ghilog($content)
{
            # Luu log N?p Th? 
        $file = "card.log";
        $fh = fopen($file,'a') or die("cant open file");
        fwrite($fh,$content);
        fwrite($fh,"\r\n");
        fclose($fh);		
        
}

function getHeader($header) {
    foreach ($_SERVER as $name => $value) {
        if (substr($name, 0, 5) == 'HTTP_') {
            if (str_replace(' ', '-', ucwords(str_replace('_', ' ', substr($name, 5)))) == $header)
                return $value;
        }
    }
    
    return false;
}


function parse_order_id($des)
{
	global $MEMO_PREFIX;
	$re = '/' . $MEMO_PREFIX . '\d+/mi';
	preg_match_all($re, $des, $matches, PREG_SET_ORDER, 0);

	if (count($matches) == 0)
		return null;
	// Print the entire match result
	$orderCode = $matches[0][0];

	$prefixLength = strlen($MEMO_PREFIX);

	$orderId = intval(substr($orderCode, $prefixLength));
	return $orderId;
}





$token = "zJkqrXfLJQZLbHg5s7P7Z2XjtGFprAtgox4SH38cBtmiIdPZsh"; // acb

// Token đã lưu trên hệ thống của bạn
$thueapiToken = getHeader('X-THUEAPI');

if ($token !== $thueapiToken) {
    ghilog("Token mismatch !");
    die();
}


$raw = file_get_contents('php://input');

$transaction = json_decode($raw);
ghilog($transaction);

if (json_last_error() != JSON_ERROR_NONE) {

    ghilog("No data found  !");
    die();
}


if  ($token == $thueapiToken )
{


    $phone = $transaction->phone;
    $content = $transaction->content;
    $amount = $transaction->money;
    $Txn_id = $transaction->Txn_id;
    $gateway = $transaction->gateway;
    $dateTime = $transaction->datetime;
    $balance = $transaction->balance; // số dư

    $order_id =intval(parse_order_id($content));


    $isUser = $database->has("account", 
        [
            "id" => "$order_id"
        ]
    );
    if ($isUser)
    {
        $dataUser = $database->get("account", [
            "id",
            "username",
            "email",
            "phone",
            "regDate",
            "xu",
            "pass2",
            "lastTimeLogin",
            "LastLoginIP"
        ], [
        "id" => $order_id
        ]);

    ghilog("Sử lý User : $order_id ");

    }
			

    if (is_null($isUser))
    {
        ghilog("Không thấy userDB : ".$order_id);
        die();
    }
    if (is_null($dataUser)){
        ghilog("Không get được User : ".$order_id);
        die();
    }

    if (is_null($order_id)) {
        ghilog(" Không tìm thấy ID");
        echo ("<div>Không nhận dạng được nội dung : " . $content. "</div>");
        die();
    }
    ghilog("---BIDV Gate---");
    ghilog("<div>Nhận dạng nội dung " . $order_id. "</div>");
    $order_note = "ThueAPI thông báo nhận <b>{$amount}</b> VND, nội dung <B>{$content}</B> chuyển vào <b>TNXID {$Txn_id}</b>";
    $username = $dataUser['username'];
    $bank = $gateway;
    //ghilog("Debug : amount : $amount balance : $balance username : $username bank : $bank content : $content Txn_id : $Txn_id dateTime : $dateTime");
        // Định dạng số và thời gian
    //start send message to discord
        $formattedAmount = number_format($amount, 0, ',', '.');
        $formattedBalance = number_format($balance, 0, ',', '.');
        $formattedDateTime = $dateTime;

        $dateToday = date("Y-m-d H:i:s");
        $startOfDay = date("Y-m-d 00:00:00", strtotime($dateToday));
        $endOfDay = date("Y-m-d 23:59:59", strtotime($dateToday));
        $total_topup_today = $database->query("SELECT SUM(menhgia) as total_topup_today FROM card WHERE trangthai = 2 AND created_at BETWEEN '$startOfDay' AND '$endOfDay'")->fetchAll();
        $total_topup_today = number_format($total_topup_today[0]['total_topup_today'], 0, ',', '.');
    
        
        // Webhook URL của bạn
        $webhookUrl = "https://discord.com/api/webhooks/1390882526146465862/Sq_FBnxIDjOF8S8SI_YoeU9vVRmbN_GErSTjIhcINdgEzXannlVHrreO0znYUUemt3ta";
        
        // Dữ liệu embed
        $data = [
            "username" => "Payment TNT Game - BOT",
            "embeds" => [
                [
                    "title" => "💳 BOT Thông Báo Giao Dịch",
                    "color" => hexdec("00cc99"), // màu viền embed (xanh ngọc)
                    "fields" => [
                        [
                            "name" => "📥 Số tiền nhận",
                            "value" => "**{$formattedAmount} VND**",
                            "inline" => true
                        ],
                        [
                            "name" => "👤 Tài khoản",
                            "value" => $username,
                            "inline" => true
                        ],
                        [
                            "name" => "🏦 Ngân hàng",
                            "value" => $bank,
                            "inline" => true
                        ],
                        [
                            "name" => "📝 Nội dung",
                            "value" => $content
                        ],
                        [
                            "name" => "🆔 Mã giao dịch",
                            "value" => $txn_id ?: "*Không xác định*",
                            "inline" => true
                        ],
                        [
                            "name" => "🕒 Thời gian",
                            "value" => $formattedDateTime,
                            "inline" => true
                        ],
                        [
                            "name" => "💰 Số dư tài khoản",
                            "value" => "**{$formattedBalance} VND**"
                        ],
                        [
                            "name" => "💰 Tổng số tiền nạp hôm nay",
                            "value" => "**{$total_topup_today} VND**"
                        ]
                    ]
                ]
            ]
        ];
        
        // Gửi webhook
        $ch = curl_init($webhookUrl);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        
        $response = curl_exec($ch);
        curl_close($ch);
            //end send message to discord
    ghilog($order_note);
    
    if ( $amount > 0 ){
        if ($amount < 10000) {
            ghilog("Số tiền nạp tối thiểu 10,000 VNĐ");
            die();
        }
        $timestamp = time();
        ghilog("Thanh toán thành công  $amount ");
        // update status thanh cong
            $count = $database->max("card", "id");
            $trans_id = intval($count) + 100;	
           // $trans_id = time();	
            $trans_code = "DH".$trans_id;
            $username = $dataUser['username'];
            $dataCard =   $database->insert("card", [
                "username" => $username,
                "loaithe" => "Bank",
                "menhgia" => $amount,
                "mathe" => "Bank",
                "seri" => "Bank",
                "trangthai" => 2,
                "idgiaodich" =>   $trans_id,
                "created_at" => $date
            ]);
       $xu = intval($amount*$tyle_khuyenmai);
        $updateUser = $database->update("account", [
            "xu[+]" => $xu,
        ], [
            "id" => $order_id
        ]);

        if($eventGacha)
        {
                addLuotQuay($username, $amount);
                ghilog("Event Gacha -- Thêm lượt quuay ".$amount);
        }

        if($updateUser) 
        {
            $content =  "Nạp thành công  : $amount";
            AddUserHistory($username,$content,'TopUP');
            ghilog("----Sử lý hoàn tất---- ".$date);
        }else {
            $content =  "Lỗi sử lý giao dịch : $order_id";
            AddUserHistory($username,$content,'TopUP');
            ghilog("----Lỗi sử lý giao dịch---- ".$order_id);
        }

     

    } else {
        ghilog("Số tiền chuyển vào không đúng");

    }
    ghilog("----Xử lý hoàn tất----".$order_id);

}


?>