<?php
include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';

// Kết nối MongoDB
$mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');

// Lấy danh sách top từ gacha log
$getData = $database->query("SELECT username, sum(point) as pointTotal FROM event_gacha_log GROUP BY username ORDER BY pointTotal DESC LIMIT 10")->fetchAll(PDO::FETCH_ASSOC);

// Xử lý để lấy role name cho mỗi người chơi
foreach ($getData as &$data) {
    // Tìm thông tin account trong MongoDB
    $isAccount = $acc->findOne(['name' => $data['username']]);
    
    if ($isAccount && isset($isAccount['role_infos'])) {
        $role_infos = $isAccount['role_infos'];
        $highest_level_role = null;
        $max_level = 0;
        
        // Tìm nhân vật có level cao nhất
        foreach ($role_infos as $server => $role_data) {
            if (isset($role_data['level']) && $role_data['level'] > $max_level) {
                $max_level = $role_data['level'];
                
                // Xử lý tên server
                $server_number = str_replace('game.cn.', '', $server);
                $formatted_server = 'S' . $server_number;
                
                // Tạo tên hiển thị theo format: S5.name(vip)
                $display_name = $formatted_server . '.' . $role_data['name'];
      
                
                $highest_level_role = $display_name;
            }
        }
        
        // Thay thế username bằng role name
        if ($highest_level_role) {
            $data['role_name'] = $highest_level_role;
        } else {
            $data['role_name'] = $data['username'];
        }
    } else {
        $data['role_name'] = $data['username'];
    }
    
    // Xóa trường username khỏi response
    unset($data['username']);
}




$json['status'] = 1;
$json['msg'] = "Thành công";
$json['data'] = $getData;
echo json_encode($json);
?>