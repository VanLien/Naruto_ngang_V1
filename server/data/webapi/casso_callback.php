<?php
		include("config/config.php");
		global $database;	
		$MEMO_PREFIX = 'DH';
		$HEADER_SECURE_TOKEN = 'tieudaokiemthe';
		$txtBody = file_get_contents('php://input');
		
		$jsonBody = json_decode($txtBody); //convert JSON into array
			
		if (!$txtBody || !$jsonBody){
			echo "Request thiếu body";
			die();
		}
		if ($jsonBody->error != 0){
			echo "Có lỗi xảy ra phía Casso";
			die();
		}

		$headers = getHeader();

		if ( $headers['Secure-Token'] != $HEADER_SECURE_TOKEN ) {
			echo("Thiếu Secure Token  Không khớp");
			die(); 
		} 	
		foreach ($jsonBody->data as $key => $transaction) {
				$des = $transaction ->description;
				$order_id =intval(parse_order_id($des));
				error_callback($des);
				
				$isCard = $database->has("card", [
					"AND" => [
						"idgiaodich" => "$order_id",
						"trangthai" => 4
					],
				]);
				
				$dataUser = $database->get("card", [
						"username",
						"trangthai",
						"id",
						"menhgia",			
						"idgiaodich"
					], [
						"idgiaodich" => "$order_id"
					],
					[
						"ORDER" => "card.id"
					]);
					
			
				$money_order =   $dataUser['menhgia'];
				$user_order =  $dataUser['username'];
				$status_card = $dataUser['trangthai'];
				error_callback("status : $status_card ");

				if (is_null($dataUser))
				{
					error_callback("Không lấy được thông tin giao dịch : ".$order_id);
					die();
				}
				if (is_null($isCard)){
					error_callback("Không tìm thấy giao dịch : ".$order_id);
					die();
				}


				if (is_null($order_id)) {
					error_callback(" Không tìm thấy ID $des");
					echo ("<div>Không nhận dạng được nội dung : " . $transaction ->description. "</div>");
					continue;
				}
				error_callback("<div>Nhận dạng nội dung " . $order_id. "</div>");

				$paid = $transaction->amount;
				$total=number_format($transaction->amount, 0);
				$order_note = "Casso thông báo nhận <b>{$total}</b> VND, nội dung <B>{$des}</B> chuyển vào <b>STK {$transaction->bank_sub_acc_id}</b>";
				error_callback($order_note);
				if ( $paid >= $money_order ){
					$timestamp = time();
					error_callback("Thanh toán thành công  $des $paid $money_order ");
					// update status thanh cong
					$dataUpdateCardPhone = $database->update("card", [
							"trangthai" => 2
						], [
							"idgiaodich" => "$order_id"
						]);
					/// update Gcoin to User

					$xukhuyenmai = 1.2; // tỷ lệ quy đổi

					$xu = intval($money_order) *  $xukhuyenmai;

					$updateUser = $database->update("account", [
						"point[+]" => $xu,
				
					], [
						"name" => "$user_order"
					]);

					$content  = "Nạp thành công nhận : $xu ";
		
					AddUserHistory($user_order,$content);

					$refAmout = ($money_order/1000)*10/100;
					giveRef($user_order,$refAmout);	
					

			
				} else {
					error_callback("Số tiền chuyển vào không đúng $des");

				}
		}
		error_callback("Xử lý hoàn tất");
		

    function error_callback($content)
    {
                # Luu log N?p Th? 
            $file = "card.log";
            $fh = fopen($file,'a') or die("cant open file");
            fwrite($fh,$content);
            fwrite($fh,"\r\n");
            fclose($fh);		
            
    }

	function parse_order_id($des){
		global $MEMO_PREFIX;
		$re = '/'.$MEMO_PREFIX.'\d+/mi';
		preg_match_all($re, $des, $matches, PREG_SET_ORDER, 0);

		if (count($matches) == 0 )
			return null;
		// Print the entire match result
		$orderCode = $matches[0][0];
		
		$prefixLength = strlen($MEMO_PREFIX);

		$orderId = intval(substr($orderCode, $prefixLength ));
		return $orderId ;

	}
	function getHeader(){
		$headers = array();

        $copy_server = array(
            'CONTENT_TYPE'   => 'Content-Type',
            'CONTENT_LENGTH' => 'Content-Length',
            'CONTENT_MD5'    => 'Content-Md5',
        );

        foreach ($_SERVER as $key => $value) {
            if (substr($key, 0, 5) === 'HTTP_') {
                $key = substr($key, 5);
                if (!isset($copy_server[$key]) || !isset($_SERVER[$key])) {
                    $key = str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', $key))));
                    $headers[$key] = $value;
                }
            } elseif (isset($copy_server[$key])) {
                $headers[$copy_server[$key]] = $value;
            }
        }

        if (!isset($headers['Authorization'])) {
            if (isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
                $headers['Authorization'] = $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
            } elseif (isset($_SERVER['PHP_AUTH_USER'])) {
                $basic_pass = isset($_SERVER['PHP_AUTH_PW']) ? $_SERVER['PHP_AUTH_PW'] : '';
                $headers['Authorization'] = 'Basic ' . base64_encode($_SERVER['PHP_AUTH_USER'] . ':' . $basic_pass);
            } elseif (isset($_SERVER['PHP_AUTH_DIGEST'])) {
                $headers['Authorization'] = $_SERVER['PHP_AUTH_DIGEST'];
            }
        }

        return $headers;
	}

?>