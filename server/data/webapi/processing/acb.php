<?php
require_once($_SERVER['DOCUMENT_ROOT'] . '/config.php');
require('acb_libs.php');
/**Lấy mã gd khi check qua api ngân hàng */
function parse_order_id($des)
{
    global $duogxaolin;
    // Regex: lấy chuỗi ký tự [A-Z0-9]+ cho tới khi gặp ký tự đặc biệt hoặc khoảng trắng
    $re = '/'.$duogxaolin->site('noi_dung_nap').'([A-Za-z0-9]+)/i';
    preg_match_all($re, $des, $matches, PREG_SET_ORDER, 0);

    if (count($matches) == 0)
        return null;

    $orderCode = $matches[0][1];
    return $orderCode;
}
$transactions = array();
foreach ($duogxaolin->get_list("SELECT * FROM `bank` WHERE  `code` = '970416'  ORDER BY `id` DESC") as $bank) {
$username = $duogxaolin->site('acb_account'); // tên đăng nhập MBBank
$password = $duogxaolin->site('acb_password'); // pass đăng nhập MBBank
$account = $duogxaolin->site('acb_stk');
$rows = 100; // số lịch sử muốn lấy

$token = $duogxaolin->site('token_acb');
$acb = new ACB($username,$password);
            $acb->clientId = "iuSuHYVufIUuNIREV0FB9EoLn9kHsDbm";
            $lichsu = $acb->LSGD($account, $rows, $token);
            $result = json_decode($lichsu, true);
            if ($result['codeStatus'] != '200') {
                $login = $acb->login();
                $login = json_encode($login, true);
                $login = json_decode($login, true);
                echo $login['accessToken'];
                        $duogxaolin->update("options", array(
            'value' => $login['accessToken']
        ), " `name` = 'token_acb' ");
        $lichsu = $acb->LSGD($account, $rows, $login['accessToken']);
        $result = json_decode($lichsu, true);
            }
            
    echo $lichsu.'<br>';
    foreach ($result['data'] as $data) {
           if ($data['type'] == 'IN') {
            $comment        = $data['description'];
            $amount =   $data['amount'];
            $id = parse_order_id($comment);
            //echo $id;
            if ($id !== null) {
                $transactions[] = array(
                    'id' => $id,
                    'amount' => $amount
                );
            }
        }
    }
}
print_r($transactions);
foreach ($duogxaolin->get_list("SELECT * FROM `autobank` WHERE  `status` = 'xuly' AND `type` = 'bank' ORDER BY `id` DESC") as $row) {
    $bank = $duogxaolin->get_row("SELECT * FROM `bank` WHERE `id` = '".$row['bank_id']."' ");
    if ($bank['code'] == '970416') {
        $magd = $row['request_id'];
        $money = $row['money'];
        $found = false;
        foreach ($transactions as $transaction) {
            if ($transaction['id'] == $magd && $transaction['amount'] == $money) {
                $found = true;
                break;
            }
        }
        if ($found) {
            echo  $magd.'<br>'; // In ra "OK"
            $duogxaolin->update("autobank", [
                'status' => 'hoantat',
            ], " `id` = '" . $row['id'] . "' ");
            $moneys = $row['money_s'];
            $user = $duogxaolin->get_row("SELECT * FROM `users` WHERE `id` = '" . $row['user_id'] . "' ");
            $duogxaolin->insert("history", [
                'magd'       =>  '<a href="/recharge/order/' . $magd . '" target="_blank">' . $magd . '</a>',
                'sotientruoc' => $user['money'],
                'sotienthaydoi' => $moneys,
                'sotiensau' => $user['money'] + $moneys,
                'thoigian' => time(),
                'noidung' => 'Nạp tiền từ acb (' . format_cash($moneys) . ' đ ) :<a href="/recharge/order/' . $magd . '" target="_blank">' . $magd . '</a>',
                'user_id' => $user['id']
            ]);
            $duogxaolin->cong("users", "money", $moneys, " `id` = '" . $user['id'] . "' ");
            $duogxaolin->cong("users", "total_money", $moneys, " `id` = '" . $user['id'] . "' ");
        } else {
            if(time() - $row['time'] > 600){
                $duogxaolin->update("autobank", [
                    'status' => 'huy',
                ], " `id` = '" . $row['id'] . "' ");
            }
        }
    }
}
?>