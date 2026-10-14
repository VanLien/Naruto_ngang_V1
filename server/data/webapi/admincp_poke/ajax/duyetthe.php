<?php

    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
    {
        include('../../config/config.php');
        require_once('../../config/bank_config.php');
        $idgiaodich = $_REQUEST['idgiaodich'];

        $cardData = $database->get("card", [
            "username",
            "menhgia",
            "mathe",
            "seri",
            "trangthai",
            "idgiaodich",
            "loaithe"
        ], [
            "idgiaodich" => $idgiaodich
        ]);

        if($cardData)
        {
            $username = $cardData['username'];
            $amount = $cardData['menhgia'];

            // Tính xu theo tỷ lệ: Bank dùng bank_tyle_xu, Card dùng card_tyle_xu
            $tyle = ($cardData['loaithe'] == 'Bank') ? $bank_tyle_xu : $card_tyle_xu;
            $xu = intval($amount * $tyle);

            $data = $database->update("account", [
                "xu[+]" =>  $xu,
            ], [
                "username" => $username
            ]);

            $updateCard = $database->update("card", [
                "trangthai" =>  2,
                "xu_receive" => $xu
            ], [
                "idgiaodich" => $idgiaodich
            ]);

            if($data)
            {
                $admin = $_SESSION['username_admin'];
                $content = "Duyệt giao dịch $idgiaodich mệnh giá: $amount - Xu: $xu";
                logAdmin($admin,$content);
                $return['type'] = 0;
                $return['msg'] =  "Cập nhật thành công giao dịch $idgiaodich - Cộng $xu xu";
                echo json_encode($return);
                exit();
            }else
            {
                $return['type'] = 1;
                $return['msg'] =  "Lỗi Update";
                echo json_encode($return);
                exit();
            }

        }else
        {
            $return['type'] = 1;
            $return['msg'] =  "Không tìm thấy giao dịch";
            echo json_encode($return);
            exit();

        }

    }else {
        header('Location: index.html');
        exit();
    }

?>