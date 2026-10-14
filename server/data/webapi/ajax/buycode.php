<?php
		if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {

			include('../config/config.php');
			$username = $_SESSION['username'];
			$date = date("Y-m-d h:i:sa");
			$idcode = intval(str_text($_REQUEST["idcode"]));

			$startDate =  getConfig('startTichLuy');
			$endDate = getConfig('endTichLuy');
			if(strtotime($startDate) > time() || strtotime($endDate) < time()) {
				$json['status'] = 1;
				$json['msg'] = "Sự kiện đã kết thúc";
				echo json_encode($json);
				exit();
			}
			$tongtien = getSumNapbyDate($username, $startDate, $endDate);

			$sign_client = trim($_REQUEST["sign"]);
			$time = trim($_REQUEST["time"]);
			$key = 'pokemon@123';
			$sign_sv = md5($time.$key.$username);

			
			if ($sign_client != $sign_sv)
			{
				$json['status'] = 1;
				$json['msg'] = "Dữ liệu truyền vào sai";
				echo json_encode($json);
				exit();
			}

            $count = $database->count("log_event_tichluy", [
                "username" => $username,
                "pack_id" => $idcode
            ]);

        
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
            "username" => $username
            ]);

			$dataCode = $database->get("event_tichluy_code", [
				"id_pack",
				"code",
				"name",
				"status",
                "price",
			], [
				"id_pack" => $idcode
			]);
			$priceCode = $dataCode['price'];
			if($tongtien < $priceCode)
			{
				$json['status'] = 1;
				$json['msg'] = "Phát hiện gian lận";
				echo json_encode($json);
				exit();
			}
			if (!is_numeric($idcode) || $username == null) {
				$json['status'] = 1;
				$json['msg'] = "Dữ liệu truyền vào sai";
				echo json_encode($json);
				exit();
			}
			if ($count > 0) {
				$json['status'] = 1;
				$json['msg'] = "Bạn đã nhận Code này rồi";
				echo json_encode($json);
				exit();
			}
			if (!$dataCode) {
				$json['status'] = 1;
				$json['msg'] = "Dữ liệu có vấn đề";
				echo json_encode($json);
				exit();
			}

			$getCode =  $data = $database->query("SELECT  code FROM `event_tichluy_code` WHERE `id_pack` = '{$idcode}' and `status` = '0' LIMIT 0,1")->fetchAll();
			if (!$getCode) {
				$json['status'] = 1;
				$json['msg'] = "Loại code này đã hết vui lòng liên hệ BQT";
				echo json_encode($json);
				exit();
			}
			foreach ($getCode as $codearr) {
				$code = $codearr['code'];
			}

			$updateCode = $database->update(
				"event_tichluy_code",
				[
					"status" => 1,
				],
				[
					"code" => $code
				]
			);

            $updateLogCode = $database->insert("log_event_tichluy", [
                "username" => $username,
                "pack_id" => $idcode,
				"code"=> $code,
				"name"=> $dataCode['name'],
                "timeDate" => $date
            ]);
			 /// update coin

			$codename = $dataCode['name'];
			$content  = "Code ".$codename." của bạn  : $code";
			AddUserHistory($username,$content,'EvenTichLuy');
			$json['status'] = 0;
			$json['msg'] = " Code :  <br> <h3><font color='red'>".$code."</font></h3>";
			$json['url'] = "tichluy.html";
			echo json_encode($json);
			exit();
		} else {
			header('Location: index.html');
			exit();
		}
		?>