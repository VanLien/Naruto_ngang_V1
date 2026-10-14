<?php



include ('../config/config.php');
require '../vendor/autoload.php';
require 'token.php';
// Tạo đối tượng từ lớp JWTHandler
$jwtHandler = new JWTHandler();
$mongodb = new MongoDB\Client("mongodb://180.93.98.5:27018");
$user = str_text($_REQUEST['username']);
$password = trim($_REQUEST['password']);



if ($user == "" || $password == "") {
	$json['status'] = 1;
	$json['msg'] = "Vui lòng nhập đầy đủ thông tin";
	echo json_encode($json);
	exit();
}

//get MongoDb
$accountdb = $mongodb->selectDatabase('account');
$accountdb = $mongodb->selectDatabase('account');
$acc = $accountdb->selectCollection('Account');
$isAccount = $acc->findOne(
	[
		'name' => $user,
		'pass_md5' => $password
	]
);



if ($isAccount) {
	$account_id = (string) $isAccount['_id']; // oid của tài liệu chính

	$ip = getIP();
	$CheckAccount = $database->has("account", [
		"username" => $user
	]);

    $isPlayGacha = $database->has("event_gacha", [
        "username" => $user
    ]);

    if (!$isPlayGacha) {
        $database->insert("event_gacha", [
            "username" => $user,
            "point" => 0,
            "luotquay" => 0,
            "luotquay_count" => 0,
        ]);
    }

	if (!$CheckAccount) {

		$ip = getIP();
		$insert = $database->insert("account", [
			"username" => $user,
			"password" => $password,
			"regDate" => $date,
			"lastLoginIP" => $ip,
			"lastTimeLogin" => $date,
			"account_id" => $account_id,
			"xu"=>0,
		]);

	}

    // Lấy thông tin role_infos
    $role_infos = $isAccount['role_infos'];
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

// Thông tin người dùng sau khi đăng nhập thành công
$user_data = [
    'username' => $user,
    'account_id' => $account_id
];
// Tạo token và trả về cho client
$jwt = $jwtHandler->generateToken($user_data);

$json['status'] = 1;
$json['msg'] = 'Login thành công';
$json['token'] = $jwt;
$json['highest_level_role'] = $highest_level_role;
echo json_encode($json);
exit();

} else {
	$json['status'] = 0;
	$json['msg'] = "Sai thông tin đăng nhập";
}
echo json_encode($json);
exit();


?>