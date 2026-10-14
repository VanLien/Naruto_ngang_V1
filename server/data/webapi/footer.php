<div class="container ">
                    <div class="menubottom" style="max-width: 668px;z-index:99;">
                        <div class="row cycle">
                            <div class="topcycle text-center"></div>
                        </div>
                        <div class="calcidden"></div>
                        <div class="row bottool">
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_trangchu;?>">
                                <i class="fa fa-home fontsize40"></i></a><br><a href="">Home</a></div>
                            <?php if ($eventTichLuy) { ?>
                                 <div class="col-xs-5ths text-center"><a href="tichluy.html">
                                <i class="fa fa-gift fontsize40"></i></a><br><a href=""> </a></div>
                            <?php } ?>
                            <?php if ($eventGacha) { ?>
                                 <div class="col-xs-5ths text-center"><a href="mini-game/">
                                <i class="fa fa-diamond fontsize40"></i></a><br><a href=""> </a></div>
                            <?php } ?>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_fanpage;?>">
                                    <i class="fa fa-facebook fontsize40"></i><br>Fanpage</a></div>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_zalo;?>">
                                    <i class="fa fa-users fontsize40"></i><br>Zalo</a></div>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_taigame;?>">
                                    <i class="fa fa-download fontsize40"></i><br>Download</a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
   
    <div class="clear" style="height: 26px"></div>

    <script src="assets/libs/jquery/dist/jquery.min.js"></script>
  <script src="assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

  <script src="js/main.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.all.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.min.css" rel="stylesheet">
  <!-- solar icons -->
  <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
  <script src="js/jquery.dataTables.min.js"></script>
        

  <script>

$(document).ready(function () {
  $("#card").hide();
  $("#atm").hide();

  $("#btn-card").click(function () {
        $("#card").show();
        $("#atm").hide();
    });
    $("#btn-atm").click(function () {
        $("#card").hide();
        $("#atm").show();
    });
    });
</script>
    </body>

</html>