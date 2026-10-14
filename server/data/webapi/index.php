

<?php  include("header.php")?>
<?php if($data['email'] == ""){ ?>
        <div class="alert alert-warning">
            <strong>Thông báo!</strong> Vui lòng cập nhật email , số điện thoại để bảo mật tài khoản
        </div>
    <?php } ?>
<div class="row giftcodeparent">
                        <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Thông tin tài khoản</a></span>
    </h2>
    <ul>
        <li><span class="fll"><i class="fa fa-user-o"></i></span> <a href="">Tài khoản:</a>
            <span class="fll2"><?php echo $data['username']?></span>
        </li>
        <li><span class="fll"><i class="fa fa-bullseye"></i></span> <a href="">Xu:</a>
            <span class="fll2"
                style="color: red"><?php echo number_format($data['xu'])?> Xu</span> <iconify-icon icon="tabler:coin" ></iconify-icon>
        </li>
        
          <li>
            <span class="fll"> <i class="fa fa-envelope-o"></i></span> 
            <?php if($data['email'] == ""){ ?>
              <a href="security.html">Email: <span class="fll2" style="color: red"> Vui lòng cập nhật email </span> </a>
            <?php }else{ ?>
              <a href="#">Email: <span class="fll2" style="color: red"><?php echo hideString($data['email']) ?></span> </a>
            <?php } ?>
          </li>
          <li>
              <span class="fll"> <i class="fa fa-phone"></i></span> 
              <?php if($data['phone'] == ""){ ?>
              <a href="security.html">Số điện thoại: <span class="fll2" style="color: red"> Vui lòng cập nhật số điện thoại </span> </a>
            <?php }else{ ?>
              <a href="#">Số điện thoại: <span class="fll2" style="color: red"><?php echo hideString($data['phone']) ?></span> </a>
            <?php } ?>
          </li>
        
        <li>
          <span class="fll"> <i class="fa fa-lock"></i></span>
             <a href="changepass.html">Đổi mật khẩu</a><span class="flr"><i class="fa fa-angle-right"></i></span>
        </li>
    </ul>
                </div>
                <?php include("footer.php")?>