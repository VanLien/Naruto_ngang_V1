<?php  include("header.php")?>
<div class="row giftcodeparent">
                        <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Đổi mật khẩu</a></span>
    </h2>
    <form action="ajax/changepass.php" onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;" class="loginform" name="login" id="register">
        <?php echo createSign($time, $sign); ?>
        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-lock" aria-hidden="true"></i></span>
            <input type="password" class="form-control" name="oldpassword" placeholder="Mật khẩu cũ">
        </div>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-unlock" aria-hidden="true"></i></span>
            <input type="password" class="form-control" name="newpassword" placeholder="Mật khẩu mới">
        </div>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-unlock" aria-hidden="true"></i></span>
            <input type="password" class="form-control" name="renewpassword" placeholder="Xác nhận mật khẩu mới">
        </div>


        <div class="form-group">
            <button type="submit" class="btn btn-default">Đổi mật khẩu</button>
        </div>

    </form>
                </div>

                <?php include("footer.php")?>