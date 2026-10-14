<?php
include ('../config/config.php');
require '../vendor/autoload.php';

// Kết nối tới MongoDB
$client = new MongoDB\Client("mongodb://180.93.98.5:27018");
$collection = $client->account->Account; // Kết nối tới collection 'Account' trong database 'account'

// Nhận giá trị từ request và làm sạch dữ liệu
$username = str_text($_REQUEST['username']);
$password = str_text($_REQUEST['password']);
// Tạo filter để tìm document có trường 'name' là username
$filter = ['name' => $username];

// Kiểm tra xem document có tồn tại hay không
$document = $collection->findOne($filter);

if ($document) {
    // Nếu document tồn tại, tiến hành cập nhật pass_md5
    $update = ['$set' => ['pass_md5' => $password]]; // Mã hóa mật khẩu bằng MD5

    // Thực hiện cập nhật
    $updateResult = $collection->updateOne($filter, $update);

    if ($updateResult->getModifiedCount() > 0) {
        echo "Cập nhật thành công!";
        $pay = curlPost("http://180.93.98.5:39666/shuma/updateAccount",
        array(
            "salt" => "@tj1shuma2tc@"
        ));
        //file_get_contents("http://180.93.98.5:39666/shuma/updateAccount?salt=@tj1shuma2tc@")
        
    } else {
        echo "Không có gì thay đổi!";
    }
} else {
    echo "Tài khoản không tồn tại!";
}
?>
