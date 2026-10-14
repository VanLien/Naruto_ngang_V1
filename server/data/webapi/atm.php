<?php  include("header.php");
    require_once('config/bank_config.php');
?>
<div class="row giftcodeparent">

    <div style="margin: 10px 10px 0 10px" class="text-note">
        <span class="fa fa-exclamation-circle"></span> <b style="color: red;">Chú ý</b>:  Sau 3 đến 5 phút vẫn chưa nhận được Xu
            vui lòng liên hệ fanpage.</span>
    </div>
    <?php
   if($tyle_khuyenmai == 0.001){
    $converttopercent = 0;
   }elseif($tyle_khuyenmai == 0.001){
    $converttopercent = 0;
   }else{
    $converttopercent = 0;
   }
    ?>
    <div style="margin: 10px 10px 0 10px" class="text-note">
        <span class="fa fa-exclamation-circle"></span> <b style="color: red;">Tỉ lệ nạp</b>: <span
            style="color: blue">Tỉ lệ nạp <span style="color: red;">100,000</span> VNĐ = <span
                style="color: red;"><?php echo  number_format($tyle_khuyenmai * 100000)?></span> Xu </span>
    </div>

    <div style="margin: 10px 10px 0 10px" class="text-note">
        <span class="fa fa-exclamation-circle"></span> <b style="color: red;">Lưu ý</b>: <span
            style="color: blue">Số tiền nạp phải là bội số của <span style="color: red;">10,000</span> VNĐ (Ví dụ: 10,000 - 20,000 - 50,000 - 100,000...)
    </div>
    <div class="clear10"></div>

    <div class="card">
        <div class="card-body">
            <div class="row align-items-start">
                <div class="col">
                    <h2 class="titlegcmxh clearfix">
                        <span class="fll"><a>Bước 1 : Quét Mã QR ( MOMO , Internet Banking)</a></span>
                    </h2>
                    <?php 
                    $trans_code = $bank_code_trans.$data['id'];
                    $img = "https://img.vietqr.io/image/$bank_code_id-$bank_code_stk-compact.png?accountName=$bank_code_ctk&addInfo=$trans_code";
                    ?>
                    <img class="img-thumbnail" src="<?php echo $img?>"></img>
                </div>
                <div class="col">
                    <h2 class="titlegcmxh clearfix">
                        <span class="fll"><a>Bước 2 : Thông tin chuyển khoản</a></span>
                    </h2>
                    
                    <div class="form-group-compact">
                        <label><b>Số tài khoản:</b></label>
                        <div class="input-group-compact">
                            <input type="text" class="form-control-compact" id="stk" value="<?php echo $bank_code_stk?>" readonly>
                            <button class="btn-compact" type="button" onclick="saochep('stk')">
                                <i class="fa fa-copy"></i> Copy
                            </button>
                        </div>
                    </div>

                    <div class="form-group-compact">
                        <label><b>Chủ tài khoản:</b></label>
                        <div class="input-group-compact">
                            <input type="text" class="form-control-compact" id="ctk" value="<?php echo $bank_code_ctk?>" readonly>
                            <button class="btn-compact" type="button" onclick="saochep('ctk')">
                                <i class="fa fa-copy"></i> Copy
                            </button>
                        </div>
                    </div>

                    <div class="form-group-compact">
                        <label><b>Ngân hàng:</b></label>
                        <div class="input-group-compact">
                            <input type="text" class="form-control-compact" id="bank_id" value="<?php echo $bank_code_id?>" readonly>
                            <button class="btn-compact" type="button" onclick="saochep('bank_id')">
                                <i class="fa fa-copy"></i> Copy
                            </button>
                        </div>
                    </div>

                    <div class="form-group-compact">
                        <label><b>Nội dung chuyển khoản:</b></label>
                        <div class="input-group-compact">
                            <input type="text" class="form-control-compact" id="noidung" value="<?php echo $trans_code?>" readonly>
                            <button class="btn-compact" type="button" onclick="saochep('noidung')">
                                <i class="fa fa-copy"></i> Copy
                            </button>
                        </div>
                    </div>

                    <p class="text-danger"><strong>Lưu ý quan trọng:</strong></p>
                    <ul class="text-danger">
                        <li>Vui lòng chuyển khoản đúng với nội dung <strong><?php echo $trans_code ?></strong></li>
                        <li>Vui lòng kiểm tra <b>nội dung chuyển khoản</b> chính xác để hệ thống cập nhật số XU</li>
                        <li>Nạp xong bạn có thể kiểm tra <a href="history.html">lịch sử giao dịch</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="clear10"></div>

    <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Lịch sử nạp gần nhất</a></span>
    </h2>
    <table class="table table-bordered" style="width: 99%" id="topup">
        <thead>
            <tr>
                <th>Loại</th>
                <th>Tiền Nạp</th>
                <th>Seri</th>
                <th>Trạng Thái</th>
                <th>Thời Gian</th>
            </tr>
        </thead>
        <tbody>
    <style>
        th {
            background: rgba(255, 255, 255, 0.9) none repeat scroll 0 0 !important;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .input-group {
            display: flex;
        }
        .input-group .form-control {
            flex: 1;
        }
        .input-group .btn {
            margin-left: 5px;
        }
    </style>
        <?php
            $data = $database->query("SELECT  * FROM `card` WHERE `username` = '{$username}' order by created_at desc LIMIT 0,1 ")->fetchAll();
            foreach ($data as $history) {
        ?>
            <tr>
                <th><?php echo $history['loaithe'] ?></th>
                <th><?php echo number_format($history['menhgia']) ?></th>
                <th><?php echo $history['seri'] ?></th>
                <th>
                    <?php
                    switch ($history['trangthai']) {
                        case 4:
                            echo "<font color='blue'>Đang chờ sử lý</font>";
                            break;
                        case 3:
                            echo "<font color='red'>Thẻ sai</font>";
                            break;
                        case 2:
                            echo "<font color='#006400'>Đã duyệt</font>";
                            break;
                    }
                    ?>
                </th>
                <th><?php echo $history['created_at'] ?></th>
            </tr>
        <?php }  ?>
        </tbody>
    </table>
    <div class="clear10"></div>

    <script>
    function saochep(ele) {
        var copyText = document.getElementById(ele);
        const textArea = document.createElement("textarea");
        textArea.value = copyText.value;
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        document.execCommand('copy');
        textArea.remove();
        swal({
            text: "Đã sao chép: " + copyText.value,
            type: "success"
        });
    }
    </script>
</div>

<?php include("footer.php")?>