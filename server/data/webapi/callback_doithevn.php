<?php
include("config/config.php");
require_once("config/bank_config.php");
date_default_timezone_set("Asia/Ho_Chi_Minh");
$validate = ValidateCallback($_POST);

$timestamp = time();
$time_now = $timestamp;
$day = date("d",$timestamp);
$month = date("m",$timestamp);
$year = date("Y",$timestamp);

$day_now = date("d",$time_now);
$month_now = date("m",$time_now);
$year_now = date("Y",$time_now);
		
		
function ValidateCallback($out) { //Hàm kiểm tra callback từ sever
	if(isset(
		$out['status'],
		$out['serial'],
		$out['pin'],
		$out['card_type'],
		$out['amount'],
		$out['content'],
		$out['real_amount']
		)) {
		return $out; //xác thực thành công, return mảng dữ liệu từ sever trả về.
		
	} else {
		return false; //Xác thực callback thất bại.
	}
}

		# Lưu log Nạp Thẻ 
		$file = "card.log";
        $fh = fopen($file,'a') or die("cant open file");
	    fwrite($fh,"Tai khoan: ".$result['name'].", data: ".json_encode($_POST));
	    fwrite($fh,"\r\n");
        fclose($fh);
		

function logthe($content)
{
			# Lưu log Nạp Thẻ 
		$file = "card.log";
        $fh = fopen($file,'a') or die("cant open file");
	    fwrite($fh,$content);
	    fwrite($fh,"\r\n");
        fclose($fh);		
		
}
if($validate != false) {
		$status = $validate['status']; //Trạng thái thẻ nạp, thẻ thành công = thanhcong , Thẻ sai, thẻ sai mệnh giá = thatbai
		$serial = $validate['serial']; //Số serial của thẻ.
		$pin = $validate['pin']; //Mã pin của thẻ.
		$card_type = $validate['card_type']; //Loại thẻ. vd: Viettel, Mobifone, Vinaphone.
		$amount = $validate['amount']; //Mệnh giá của thẻ. nếu bạn sài thêm hàm sai mệnh giá vui lòng sử dụng thêm hàm này tự cập nhật mệnh giá thật kèm theo desc là mệnh giá củ
		$real_amount = $validate['real_amount']; // thực nhận đã trừ chiết khấu
		$content = $validate['content']; // id transaction 

				$isCard = $database->has("card", [
					"AND" => [
						"mathe" => $pin,
						"seri" => $serial,
						"trangthai" => 4
					],
				]);
							
				logthe(print_r($isCard));
				// thẻ tồn tại và chưa check
		$amount_txt = number_format($amount);
		$message = "Tiền vào  GD từ TheSieuToc ( Thẻ cào ) : $amount_txt VND, nội dung : $content, Thời gian : $date";
		sendMessageToTelegram($message, $chat_id, $bot_token);
		if($isCard)
			{
					logthe("check thanh cong the");
					$dataUser = $database->get("card", [
                        "id",
						"username",
						"trangthai",
						"mathe",
                        "seri"

					],['AND' => [
						"mathe" => $pin,
						"seri" => $serial,
					]]);
					
			if ($dataUser) { 
					$username = $dataUser['username'];
					logthe('Tìm thấy thông tin Thẻ và User ');
					logthe($status);
					logthe($xu);						
					if($status == 'thanhcong') 
					{
						logthe('Thẻ trả trạng thái thành công');
						// update status thanh cong

						/// Tính xu theo tỷ lệ card
						$xu = intval($amount * $card_tyle_xu);

						$dataUpdate = $database->update("card", [
							"trangthai" => 2,
							"xu_receive" => $xu
						], ['AND'=>[
							"mathe" => $pin,
							"seri" => $serial
						]]);
						logthe(print_r($dataUpdate));

						if ($dataUpdate) {


							/// update Gcoin to User
							logthe('Cộng tiền cho User '.$xu.' xu - '.$username);
							$updateUser = $database->update("account", [
								"xu[+]" => $xu,

							], [
								"username" => $username
							]);

							if($eventGacha)
							{
									addLuotQuay($username, $amount);
									ghilog("Event Gacha -- Thêm lượt quuay ".$amount);
							}
							
							if($updateUser) {
								logthe('Cộng tiền cho User Thành công');
								$content =  "Nạp thẻ thành công  : $amount";
								AddUserHistory($username,$content,'TopUP');
							} else {
								logthe('Cộng tiền cho User Thất bại');
							}

							
						}
															
					} else if($status == 'saimenhgia') {
						logthe('sai menh gia');
						// update the sai menh gia
						$dataUpdate = $database->update("card", [
							"trangthai" => 3
						], ['AND'=>[
							"mathe" => $pin,
							"seri" => $serial
						]]);											
					}else {
						logthe('Thẻ sai');
						$dataUpdate = $database->update("card", [
							"trangthai" => 3
						], ['AND'=>[
							"mathe" => $pin,
							"seri" => $serial
						]]);
						
					}
				}
		}

	
}
?>