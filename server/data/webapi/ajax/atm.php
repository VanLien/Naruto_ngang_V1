<?php
    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
    {
        include('../config/config.php');

        $captchaUser = filter_var($_REQUEST["captcha"], FILTER_SANITIZE_STRING);
        $username = $_SESSION['username'];
        $date = date("Y-m-d h:i:sa");
        $sotien = str_text($_REQUEST["sotien"]);
        
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

        if ( $_SESSION['CAPTCHA_CODE'] != $captchaUser)
        {
            $json['status'] = 1;
            $json['msg'] = "Mã bảo mật sai";
            echo json_encode($json);
            exit();
        }

        if (  $sotien == "" ||  $username=="" || $captchaUser== "")
        {
            $json['status'] = 1;
            $json['msg'] = "Vui lòng nhập đầy đủ thông tin";
            echo json_encode($json);
            exit();
        }
        if (  $sotien < 0 )
        {
            $json['status'] = 1;
            $json['msg'] = "Phải nhập số lớn hơn 0";
            echo json_encode($json);
            exit();
        }
        
        if (  $sotien < 10000 )
        {
            $json['status'] = 1;
            $json['msg'] = "Số tiền nạp chuyển khoản tối thiểu 10.000 VND";
            echo json_encode($json);
            exit();
        } 
                $count = $database->max("card", "id");
                $trans_id = intval($count) + 100;	
               // $trans_id = time();	
                $trans_code = "DH".$trans_id;
                //$img  = createQR($sotien,$trans_code);
                $img = "https://api.vietqr.io/image/970416-223083969-w2glLP1.jpg?amount=$sotien%5C&addInfo={$trans_code}&accountName=LE%20HUU%20MINH%20TUYEN";
                 $dataCard =   $database->insert("card", [
                "username" => $username,
                "loaithe" => "Bank",
                "menhgia" => $sotien,
                "mathe" => "Bank",
                "seri" => "Bank",
                "trangthai" => 4,
                "idgiaodich" =>   $trans_id,
                "created_at" => $date
            ]);
                if ( $dataCard ) 
                {
                $json['status'] = 99;
                $json['msg'] = "
                <img src='$img' width='250' height='250'>
                <h2> Dùng App Ngân Hàng Quét QRCode </h2> 
                <h2> Thông tin chuyển khoản </h2> 
                </br> Số tài khoản : <b> 223083969 </b></br>
                Tên tài khoản : <b>LE HUU MINH TUYEN  </b></br>
                Số tiền : $sotien  </b></br>   
                Ngân Hàng : <b>MB Bank </b> </br> 
                <p><font color='red' size='6'> Nội  dung chuyển khoản :<b> $trans_code </b></font></p></br>
                <strong>Vui lòng chuyển đúng nội dung chuyển khoản để hệ thống cộng Xu tự động</strong>
                ";
                $json['url'] = "topup.html";
                echo json_encode($json);
                exit();
                }else { 
            $json['status'] = 1;
            $json['msg'] = "Lỗi máy chủ , vui lòng thử lại hoặc liên hệ Admin";
            echo json_encode($json);
            exit();
            }
        

    }else {
        header('Location: index.html');
        exit();
    }
?>