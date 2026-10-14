<?php 
include ('../config/config.php');
require '../vendor/autoload.php';

// Log để debug
file_put_contents('telegram_debug.log', "Request received at: " . date('Y-m-d H:i:s') . "\n", FILE_APPEND);

// Log all headers
$headers = getallheaders();
file_put_contents('telegram_debug.log', "Headers: " . print_r($headers, true) . "\n", FILE_APPEND);

// Khởi tạo bot Telegram
$botToken = '8063623183:AAE0Icf6XAPtNXKtzhgJ-618WigUoXO1DZg';

try {
    // Lấy update từ Telegram
    $content = file_get_contents("php://input");
    file_put_contents('telegram_debug.log', "Raw content: " . $content . "\n", FILE_APPEND);
    
    $update = json_decode($content, true);
    
    if (isset($update["message"])) {
        $message = $update["message"];
        $chatId = $message["chat"]["id"];
        $text = $message["text"];
        
        file_put_contents('telegram_debug.log', "Message received: " . $text . " from chat ID: " . $chatId . "\n", FILE_APPEND);
        
        // Xử lý lệnh /listacc
        if ($text === "/listacc") {
            $client = new MongoDB\Client("mongodb://180.93.98.5:27018");
            $total = 0;
            
            // Count Collection Account
            $collection = $client->account->Account;
            $accountCount = $collection->countDocuments();
            $response = "Số tài khoản đã đăng ký: " . $accountCount . "\n\n";
            $response .= "Số nhân vật trên từng server:\n";
            
            $listServer = ["game1","game2","game3","game4","game5"];
            foreach($listServer as $server){
                $dbname = $server;
                $collection = $client->$dbname->Role;
                $count = $collection->countDocuments();
                $response .= "$server: $count\n";
                $total += $count;
            }
            $response .= "\nTổng số nhân vật: $total";
            
            // Gửi kết quả về Telegram sử dụng curl
            $url = "https://api.telegram.org/bot{$botToken}/sendMessage";
            $data = [
                'chat_id' => $chatId,
                'text' => $response
            ];
            
            // Sử dụng cURL để gửi yêu cầu tới Telegram API
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

            $response = curl_exec($ch);
            // Tắt SSL verification

            
            $result = curl_exec($ch);
            $curl_error = curl_error($ch);
            $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            
            // Log kết quả CURL chi tiết hơn
            file_put_contents('telegram_debug.log', "CURL Result: " . $result . "\n", FILE_APPEND);
            file_put_contents('telegram_debug.log', "HTTP Code: " . $http_code . "\n", FILE_APPEND);
            if ($curl_error) {
                file_put_contents('telegram_debug.log', "CURL Error: " . $curl_error . "\n", FILE_APPEND);
            }
            
            curl_close($ch);
        }
        if($text ==="/checkOnline")
        {
            
        }
    }
} catch (\Exception $e) {
    // Log lỗi nếu có
    file_put_contents('telegram_error.log', date('Y-m-d H:i:s') . ": " . $e->getMessage() . "\n", FILE_APPEND);
}

// Log kết thúc request
file_put_contents('telegram_debug.log', "Request completed at: " . date('Y-m-d H:i:s') . "\n\n", FILE_APPEND);
?>