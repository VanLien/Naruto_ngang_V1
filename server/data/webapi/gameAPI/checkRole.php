<?php
include ('../config/config.php');
require '../vendor/autoload.php';
$client = new MongoDB\Client("mongodb://180.93.98.5:27018");

// 2. Chọn database và collection
$db = $client->selectDatabase('account');
$collection = $db->selectCollection('Account');

$pattern = $_GET['pattern'];  // chuỗi con bạn muốn tìm
$key = $_GET['key'];
$searchType = $_GET['searchType'] ?? 'character'; // 'character' hoặc 'username'


if($key != 'admin'){
    echo json_encode(['error' => 'Bạn không có quyền truy cập']);
    exit;
}
if ($searchType === 'username') {
    // Tìm theo username
    $pipeline = [
        ['$match' => [
            'name' => [
                '$regex'   => $pattern,
                '$options' => 'i'
            ]
        ]],
        ['$project' => [
            '_id'           => 0,
            'userName'      => '$name',
            'role_infos'    => 1
        ]]
    ];
} else {
    // Tìm theo tên nhân vật (mặc định)
    $pipeline = [
        // 1) biến role_infos thành mảng [{k, v}, …]
        ['$project' => [
            'infosArr' => ['$objectToArray' => '$role_infos'],
            'userName' => '$name',     // giữ tên user nếu cần
        ]],
        // 2) unwind để mỗi phần tử thành một doc tạm
        ['$unwind' => '$infosArr'],
        // 3) lọc theo regex
        ['$match' => [
            'infosArr.v.name' => [
                '$regex'   => $pattern,
                '$options' => 'i'
            ]
        ]],
        // 4) chỉ project những trường cần hiển thị
        ['$project' => [
            '_id'           => 0,
            'userName'      => 1,
            'roleKey'       => '$infosArr.k',       // game.cn.x
            'characterName' => '$infosArr.v.name',  // tên nhân vật
            'level'         => '$infosArr.v.level', // ví dụ thêm level
            'vip'           => '$infosArr.v.vip',   // ví dụ thêm vip
            'pass_md5'      => '$infosArr.v.pass_md5'  // ví dụ thêm pass
        ]]
    ];
}

$cursor = $collection->aggregate($pipeline);
$results = array();
foreach ($cursor as $doc) {
    if ($searchType === 'username') {
        // Xử lý kết quả tìm theo username - lấy role có level cao nhất như getRoleName.php
        $role_infos = $doc['role_infos'] ?? [];
        $highest_level_role = null;
        $max_level = 0;
        
        // Duyệt qua từng role để tìm role có level cao nhất
        if (isset($role_infos) && !empty($role_infos)) {
            foreach ($role_infos as $server => $role_data) {
                if (isset($role_data['level']) && $role_data['level'] > $max_level) {
                    $max_level = $role_data['level'];
                    
                    // Xử lý tên server
                    $server_number = str_replace('game.cn.', '', $server);
                    $formatted_server = 'S' . $server_number;
                    
                    // Tạo tên hiển thị theo format: S5.name(vip)
                    $display_name = $formatted_server . '.' . $role_data['name'];
                    if (isset($role_data['vip'])) {
                        $display_name .= '(VIP' . $role_data['vip'] . ')';
                    }
                    
                    $highest_level_role = [
                        'server' => $server,
                        'display_name' => $display_name,
                        'data' => $role_data
                    ];
                }
            }
        }
        
        // Trả về thông tin role có level cao nhất
        if ($highest_level_role) {
            $results[] = [
                'userName'      => $doc['userName'],
                'roleKey'       => $highest_level_role['server'],
                'characterName' => $highest_level_role['data']['name'],
                'level'         => $highest_level_role['data']['level'],
                'vip'           => $highest_level_role['data']['vip'] ?? '',
                'pass_md5'      => $highest_level_role['data']['pass_md5'] ?? '',
                'server'        => $formatted_server,
                'display_name'  => $highest_level_role['display_name']
            ];
        } else {
            // Nếu không có role_infos hoặc không có role nào hợp lệ
            $results[] = [
                'userName'      => $doc['userName'],
                'roleKey'       => '',
                'characterName' => '',
                'level'         => '',
                'vip'           => '',
                'pass_md5'      => '',
                'server'        => '',
                'display_name'  => ''
            ];
        }
    } else {
        // Xử lý kết quả tìm theo tên nhân vật (như cũ)
        $results[] = $doc;
    }
}
header('Content-Type: application/json');
echo json_encode($results);
?>
