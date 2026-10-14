<?php
    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
    {
        include('../config/config.php');

        $captchaUser = filter_var($_REQUEST["captcha"], FILTER_SANITIZE_STRING);
        $username = $_SESSION['username'];
        $date = date("Y-m-d h:i:sa");
        $mang = str_text($_REQUEST["card_provider"]);
        $card_value = str_text($_REQUEST["card_value"]);
        $card_serial = str_text($_REQUEST["card_serial"]);
        $card_password = str_text($_REQUEST["card_password"]);
        
        $sign_client = $_REQUEST["sign"];
			$time = $_REQUEST["time"];
			$key = 'thienlongthanma-4mcode';
			$sign_sv = md5($time.$key.$username);

			if ($sign_client != $sign_sv)
			{
				$json['status'] = 1;
				$json['msg'] = "Dữ liệu truyền vào sai";
				echo json_encode($json);
				exit();
			}

        
        // if ( $_SESSION['CAPTCHA_CODE'] != $captchaUser)
        // {
        //     $json['status'] = 1;
        //     $json['msg'] = "Mã bảo mật sai".$_SESSION['CAPTCHA_CODE'];
        //     echo json_encode($json);
        //     exit();
        // }

        if ( $mang == "" || $card_value=="" || $card_serial =="" || $card_password =="" || $username=="" || $captchaUser== "")
        {
            $json['status'] = 1;
            $json['msg'] = "Vui lòng nhập đầy đủ thông tin";
            echo json_encode($json);
            exit();
        }
        $trans_id = time();
        $note = $username."-".$trans_id;
        $url = "https://thesieutoc.net/chargingws/v2?APIkey=".$apikey."&mathe=".$card_password."&seri=".$card_serial."&type=".$mang."&menhgia=".$card_value."&content=".$note;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        // curl_setopt($ch,CURLOPT_CAINFO, __DIR__ .'/curl-ca-bundle.crt');
        // curl_setopt($ch,CURLOPT_CAPATH, __DIR__ .'/curl-ca-bundle.crt');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $out = json_decode(curl_exec($ch));

        $http_code = 0;
        if (isset($out->status)){$http_code = 200;}
        curl_close($ch);
        if ($http_code == 200){
            if ($out->status == '00' || $out->status == 'thanhcong'){
                //Gửi thẻ thành công, đợi duyệt.

                $database->insert("card", [
                    "username" => $username,
                    "loaithe" => $mang,
                    "menhgia" => $card_value,
                    "mathe" => $card_password,
                    "seri" => $card_serial,
                    "trangthai" => 4,
                    "idgiaodich" =>  $trans_id,
                    "created_at" => $date
                ]);
                //insert log
                $json['status'] = 0;
                $json['msg'] = "Gửi thẻ lên thành công , vui lòng chờ 10s duyệt thẻ";
                $json['url'] = "topup.html";
                echo json_encode($json);
                exit();
            } else if ($out->status != '00' && $out->status != 'thanhcong'){
                // gửi thẻ lên thất bại
                $json['status'] = 1;
                $json['msg'] = "Thất bại :".$out->msg;
                echo json_encode($json);
                exit();
            }
        } else {
            $json['status'] = 1;
            $json['msg'] = "Lỗi máy chủ , vui lòng thử lại hoặc liên hệ Admin".$out;
            echo json_encode($json);
            exit();
        }

    }else {
        header('Location: index.html');
        exit();
    }
?>