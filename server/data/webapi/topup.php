<?php  include("header.php")?>
<div class="row giftcodeparent">
<?php
    if($tyle_khuyenmai == 0.001){
        $converttopercent = 0;
    }elseif($tyle_khuyenmai == 0.001){
        $converttopercent = 0;
    }else{
        $converttopercent = 0;
    }
    ?>
        <div class="card-header">
            Chọn phương thức thanh toán
        </div>
        <div class="card-body">
            <h5 class="card-title">Hệ thống thanh toán chấp nhận ATM / Internetbanking / Thẻ Cào</h5>
            <p class="card-text">Chọn phương thức thanh toán</p>
            <a href="card.html" id="btn-card" class="btn btn-primary">Thẻ Cào <iconify-icon icon="tabler:credit-card-pay">
                </iconify-icon></a>
            <a href="nap-tien.html" id="btn-atm" class="btn btn-success">ATM / Internetbanking <iconify-icon
                    icon="tabler:qrcode"></iconify-icon></a>
        </div>
    </div>


    <div class="clear10"></div>




</div>

<?php include("footer.php")?>