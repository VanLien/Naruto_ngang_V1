<?php

include ('../config/config.php');
require '../vendor/autoload.php';
$client = new MongoDB\Client("mongodb://180.93.98.5:27018");
// Kết nối tới MongoDB

// Chọn Database và Collection
$collection = $client->gift->Gift;

// Đọc file keys.txt và tạo mảng keys
$keysFile = 'keys.txt';
$keys = file($keysFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

// Kiểm tra xem có key nào được nạp từ file không
if (!empty($keys)) {
    // Tạo điều kiện để xóa các tài liệu có key nằm trong danh sách
    $deleteCriteria = [
        'key' => ['$in' => $keys] // $in là phép toán MongoDB để tìm các tài liệu có key thuộc danh sách keys
    ];

    // Xóa tài liệu dựa trên danh sách key
    $deleteResult = $collection->deleteMany($deleteCriteria);

    // Hiển thị số lượng tài liệu đã xóa
    printf("Deleted %d document(s)\n", $deleteResult->getDeletedCount());
} else {
    echo "No keys found in the file.";
}
?>
