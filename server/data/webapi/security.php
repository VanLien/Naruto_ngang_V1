<?php  include("header.php")?>
<div class="row giftcodeparent">
                        <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Cập nhật thông tin tài khoản</a></span>
    </h2>

<?php  if($data['email'])
{ ?>
    <div class="alert alert-success">
        <strong>Chúc mừng</strong> Bạn đã cập nhật thành công thông tin tài khoản
    </div>


    
    <form  class="loginform" name="login" id="register">
        <?php echo createSign($time, $sign); ?>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-envelope" aria-hidden="true"></i></span>
            <input type="text" class="form-control" name="email" readonly value="<?php echo  hideString($data['email']) ?>">
        </div>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-phone" aria-hidden="true"></i></span>
            <input type="text" class="form-control" name="tel" readonly value="<?php echo hideString($data['phone']) ?>">
        </div>
      
    </form>

<?php }else { ?>

    <form action="ajax/updateemail.php" onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;" class="loginform" name="login" id="register">
        <?php echo createSign($time, $sign); ?>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-envelope" aria-hidden="true"></i></span>
            <input type="text" class="form-control" name="email" placeholder="Nhập Email">
        </div>

        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-phone" aria-hidden="true"></i></span>
            <input type="number" class="form-control" name="tel" placeholder="Nhập số điện thoại">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-default">Cập nhật thông tin</button>
        </div>
    </form>

    
    <?php }?>
                </div>

                <?php include("footer.php")?>