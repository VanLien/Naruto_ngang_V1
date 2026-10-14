<?php
include("config/config.php");
global $database;
$MEMO_PREFIX = 'POKE';


$response = array(
    "status" => true,
    "msg" => "OK"
);
echo json_encode($response);
exit();



function ghilog($content)
{
    # Luu log N?p Th?
    $file = "card.log";
    $fh = fopen($file, 'a') or die("cant open file");
    fwrite($fh, $content);
    fwrite($fh, "\r\n");
    fclose($fh);
}

function getHeader($header)
{
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

$accessToken = "1f7da75157a976b34e758657b20ea4302c7f486e7c023a24e0d2344f0410916b";
//$accessToken = '2E863947-C74A-7076-6A58-A58A96EF2597'; // Thay YOUR_ACCESS_TOKEN bằng Access Token thực tế
$receivedData = file_get_contents('php://input'); // Nhận dữ liệu từ webhook
$dataArray = json_decode($receivedData, true);
if (isset($dataArray['data']) && is_array($dataArray['data'])) {
    foreach ($dataArray['data'] as $transaction) {
        $content = $transaction['description'];
        $amount = $transaction['amount'];
        $Txn_id = $transaction['transactionID'];
        $day = $transaction['date'];
        $bank = $transaction['bank'];
        $message = "Tiền vào  GD từ $bank : $amount VND, nội dung : $content, Thời gian : $day";
        //sendMessageToTelegram($message, $chat_id, $bot_token);
    }
} else {
    ghilog("Không lấy được thông tin GD");
}

// Kiểm tra xem tiêu đề Authorization có tồn tại trong yêu cầu
if (isset($_SERVER['HTTP_AUTHORIZATION']) && strpos($_SERVER['HTTP_AUTHORIZATION'], 'Bearer ') === 0) {
    $bearerToken = substr($_SERVER['HTTP_AUTHORIZATION'], 7); // Lấy chuỗi token sau 'Bearer '

    // Kiểm tra xem chữ ký HMAC-SHA256 của bearerToken và imei có khớp với accessToken
    if ($accessToken === $bearerToken) {
        // Dữ liệu hợp lệ, tiếp tục xử lý
        $order_id = intval(parse_order_id($content));
        ghilog("Kiểm tra tiếp OrderID" . $order_id);

        $isUser = $database->has("account", [
            "id" => "$order_id"
        ]);
        if ($isUser) {
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

            ghilog("Sử lý User : $order_id");
        }

        if (is_null($isUser)) {
            ghilog("Không thấy userDB : " . $order_id);
            $response = array(
                "status" => true,
                "msg" => "OK"
            );
            echo json_encode($response);
            exit();
        }
        if (is_null($dataUser)) {
            ghilog("Không get được User : " . $order_id);
            $response = array(
                "status" => true,
                "msg" => "OK"
            );
            echo json_encode($response);
            exit();

        }

        if (is_null($order_id)) {
            ghilog(" Không tìm thấy ID");
            echo ("<div>Không nhận dạng được nội dung : " . $content . "</div>");
            $response = array(
                "status" => true,
                "msg" => "OK"
            );
            echo json_encode($response);
            exit();

        }
        ghilog("---ACB Gate---");
        ghilog("<div>Nhận dạng nội dung " . $order_id . "</div>");

        $order_note = "Web2M API thông báo nhận <b>{$amount}</b> VND, nội dung <B>{$content}</B> chuyển vào <b>TNXID {$Txn_id}</b>";
       
        $formattedAmount = number_format($amount, 0, ',', '.');
        //$formattedBalance = number_format($balance, 0, ',', '.');
        $formattedDateTime = $day;
        $username = $dataUser['username'];
        // Webhook URL của bạn
        $webhookUrl = "https://discord.com/api/webhooks/1376406283514548365/bSKZ0ysRP25phcMpzO-7q7bTU1Zm3qgOlM5O2v0LHXKmLiKBodS78OFaeC8Sq--GSjcV";

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
                        ]
                        // [
                        //     "name" => "💰 Số dư tài khoản",
                        //     "value" => "**{$formattedBalance} VND**"
                        // ]
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

        if ($amount > 0) {

            if ($amount < 10000) {
                ghilog("Số tiền nạp tối thiểu 10,000 VNĐ");
                die();
            }
            $tnx_check = $database->has("card", [
                "AND" => [
                    "idgiaodich" =>   $Txn_id,
                    "status" => 2
                ]
            ]);
            if($tnx_check)
            {
                ghilog("Giao dịch đã tồn tại : $Txn_id");
                die();
            }
            $timestamp = time();
            ghilog("Thanh toán thành công  $amount ");
            // update status thanh cong
            $count = $database->max("card", "id");
            $trans_id = intval($count) + 100;
            // $trans_id = time();
            $trans_code = "DH" . $trans_id;
            $username = $dataUser['username'];
            $dataCard =   $database->insert("card", [
                "username" => $username,
                "loaithe" => "Bank",
                "menhgia" => $amount,
                "mathe" => "Bank",
                "seri" => "Bank",
                "trangthai" => 2,
                "idgiaodich" =>   $Txn_id,
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

            if ($updateUser) {
                $content =  "Nạp thành công  : $amount";
                AddUserHistory($username, $content, 'TopUP');
                ghilog("----Sử lý hoàn tất user : $username" . $date);

                $response = array(
                    "status" => true,
                    "msg" => "OK"
                );
                echo json_encode($response);
                exit();
            } else {
                $content =  "Lỗi sử lý giao dịch : $order_id";
                AddUserHistory($username, $content, 'TopUP');
                ghilog("----Lỗi sử lý giao dịch---- " . $order_id);

                $response = array(
                    "status" => true,
                    "msg" => "OK"
                );
                echo json_encode($response);
                exit();
            }
        } else {
            ghilog("Số tiền chuyển vào không đúng");
            $response = array(
                "status" => true,
                "msg" => "OK"
            );
            echo json_encode($response);
            exit();
        }
        ghilog("----Xử lý hoàn tất----" . $order_id);
        $response = array(
            "status" => true,
            "msg" => "OK"
        );
        echo json_encode($response);
        exit();
    } else {
        // Chữ ký không khớp, từ chối yêu cầu
        http_response_code(401); // Unauthorized
        ghilog('Chữ ký không hợp lệ.');
    }
} else {
    // Tiêu đề Authorization không tồn tại hoặc không hợp lệ
    http_response_code(401); // Unauthorized
    ghilog('Access Token không được cung cấp hoặc không hợp lệ.');
    $response = array(
        "status" => true,
        "msg" => "OK"
    );
    echo json_encode($response);
    exit();
}
?>
