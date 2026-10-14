<?php
include ('../config/config.php');
require '../vendor/autoload.php';
$client = new MongoDB\Client("mongodb://180.93.98.5:27018");

// Chọn Database và Collection
$collection = $client->gift->Gift;

// Đọc file keys.txt và tạo mảng keys
$keysFile = 'keys.txt';
$keys = file($keysFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

// Kiểm tra xem có key nào được nạp từ file không
if (!empty($keys)) {
    // Tạo điều kiện tìm các tài liệu có key nằm trong danh sách
    $searchCriteria = [
        'key' => ['$in' => $keys] // Tìm các tài liệu có key trong danh sách keys
    ];

    // Tìm các tài liệu phù hợp với điều kiện
    $remainingDocuments = $collection->find($searchCriteria);

    // Kiểm tra và hiển thị các tài liệu còn sót lại
    $foundKeys = [];
    foreach ($remainingDocuments as $doc) {
        $foundKeys[] = $doc['key'];
    }

    if (!empty($foundKeys)) {
        echo "The following keys still exist in the database:\n";
        print_r($foundKeys);
    } else {
        echo "All keys have been deleted from the database.";
    }
} else {
    echo "No keys found in the file.";
}
?>
