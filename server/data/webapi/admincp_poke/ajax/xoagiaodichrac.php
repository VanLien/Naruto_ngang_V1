<?php

    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) &&  strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
    {
        include('../../config/config.php');
       
         $data =  $database->delete("card", [
                "trangthai" => "4"
           ]);
            if($data)
            {
                $admin = $_SESSION['username_admin'];
                $content = "Xóa toàn bộ giao dịch chưa duyệt";
                logAdmin($admin,$content);
                $return['type'] = 0;
                $return['msg'] =  "Xóa thành công";
                echo json_encode($return);
                exit();
            }else
            {
                $return['type'] = 1;
                $return['msg'] =  "Lỗi Update";
                echo json_encode($return);
                exit();
            }



    }else {
        header('Location: index.html');
        exit();
    }

?>