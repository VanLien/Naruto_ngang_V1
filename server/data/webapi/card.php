<?php  include("header.php");
require_once('config/bank_config.php');
?>
<div class="row giftcodeparent">
<h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Chú ý: hãy chọn đúng mệnh giá thẻ</a></span>
    </h2>
    <ul>
        <li><span class="fll"><i class="fa fa-hand-o-right"></i></span>
            <span class="fll2">Tỉ lệ nạp <span style="color: red;">100,000</span> VNĐ = <span style="color: red;"><?php echo number_format($card_tyle_xu * 100000); ?></span> Xu</span>
        </li>
        <li><span class="fll"><i class="fa fa-hand-o-right"></i></span><span class="fll2"> <span style="color: red;">Chọn sai mệnh giá thẻ sẽ mất thẻ</span></span></li>
    </ul>
    <form action="ajax/napthe.php" onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;" class="loginform" name="login" id="register">
    <?php echo createSign($time, $sign); ?>
        <div class="form-group">
            <select class="form-control" name="card_provider" id="gameid" style=" border:1px solid #fa5b36; height:50px;">
                                      <option value=""> Chọn nhà mạng</option>
                                            <option value="Viettel">Viettel</option>
                                            <option value="Vinaphone">Vinaphone</option>
											<option value="Mobifone">Mobifone</option>
											<option value="Vietnamobile">Vietnamobile</option>
											<option value="Vcoin">Vcoin</option>
											<option value="Zing">Zing</option>
											<option value="Gate">Gate</option>
                                            <option value="Garena">Garena</option>
            </select>
        </div>
        <div class="form-group">
            <select class="form-control" name="card_value" style=" border:1px solid #fa5b36; height:50px;">
                <option value="0">Chọn mệnh giá</option>
                <option value="10000">10,000 VNĐ</option>
                <option value="20000">20,000 VNĐ</option>
                <option value="30000">30,000 VNĐ</option>
                <option value="50000">50,000 VNĐ</option>
                <option value="100000">100,000 VNĐ</option>
                <option value="200000">200,000 VNĐ</option>
                <option value="300000">300,000 VNĐ</option>
                <option value="500000">500,000 VNĐ</option>
                <option value="1000000">1,000,000 VNĐ</option>
            </select>
        </div>
        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-lock"></i></span>
            <input type="text=x" class="form-control" name="card_serial" placeholder="Nhập serial thẻ">
        </div>
        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-lock"></i></span>
            <input type="text=x" class="form-control" name="card_password" placeholder="Nhập mã thẻ">
        </div>
        <div class="form-group">
            <div class="input-group">
                <span class="input-group-addon"><i class="fa fa-codiepie"></i></span>
                <input type="text" class="form-control" name="captcha" id="user_name" value="" style="height:50px;"
                    placeholder="Mã captcha">
                <span class="input-group-addon captcha" id="refreshCaptcha"> <img src="get_captcha.php" alt="Captcha"></span>
            </div>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-default">Nạp</button>
        </div>

    </form>

    <style>
        th {
    background: rgba(255, 255, 255, 0.9) none repeat scroll 0 0 !important;
}
    </style>

    <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Lịch sử nạp thẻ gần nhất</a></span>
    </h2>
    <table class="table table-bordered" style="width: 99%" id="cardHistory">
        <thead>
            <tr>
                <th>Loại</th>
                <th>Tiền Nạp</th>
                <th>Xu Nhận</th>
                <th>Trạng Thái</th>
                <th>Thời Gian</th>
            </tr>
        </thead>
        <tbody>
        <?php
            $data = $database->select("card", "*", [
                "AND" => [
                    "username" => $username,
                    "loaithe[!]" => "Bank"
                ],
                "ORDER" => ["created_at" => "DESC"],
                "LIMIT" => 5
            ]);
            foreach ($data as $history) {
                // Lấy xu_receive từ DB nếu có, không thì tính theo tỷ lệ
                if (isset($history['xu_receive']) && $history['xu_receive'] > 0) {
                    $xu_receive = $history['xu_receive'];
                } else {
                    $xu_receive = intval($history['menhgia'] * $card_tyle_xu);
                }
        ?>
            <tr>
                <td><?php echo $history['loaithe'] ?></td>
                <td><?php echo number_format($history['menhgia']) ?></td>
                <td><?php echo number_format($xu_receive) ?></td>
                <td>
                    <?php
                    switch ($history['trangthai']) {
                        case 4:
                            echo "<span style='background:#fff3cd;color:#856404;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-clock-o'></i> Đang chờ</span>";
                            break;
                        case 3:
                            echo "<span style='background:#f8d7da;color:#721c24;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-times'></i> Thẻ sai</span>";
                            break;
                        case 2:
                            echo "<span style='background:#d4edda;color:#155724;padding:3px 8px;border-radius:10px;font-size:11px;white-space:nowrap;'><i class='fa fa-check'></i> Đã duyệt</span>";
                            break;
                    }
                    ?>
                </td>
                <td><?php echo date("Y-m-d H:i:s", strtotime($history['created_at'])) ?></td>
            </tr>
        <?php }  ?>
        </tbody>
    </table>
    <div class="clear10"></div>


                </div>

<?php include("footer.php")?>