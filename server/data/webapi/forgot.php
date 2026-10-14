<!DOCTYPE html>
<html>

<head>
    <?php include 'config/config.php';
    
    if ($_SESSION['username']) movePage('index.html');	
    ?>
    <meta charset="utf-8">
    <meta name="robots" content="index,follow,all">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-title" content="">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon.png">

    <title><?php echo $title;?></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="copyright" content="">
    <meta name="keywords" content="">
    <meta property="og:title" content="<?php echo $title;?>">
    <meta property="og:description" content="">
    <meta property="og:image" content="images/banner.jpg">
    <link href="css/font.css" rel="stylesheet" type="text/css">
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="css/rwdgrid.css" rel="stylesheet" type="text/css">
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome-animation.min.css" rel="stylesheet" type="text/css">
    <link href="css/uploadimages_style.css" rel="stylesheet" type="text/css">
    <link href="css/justifiedGallery.css" rel="stylesheet" type="text/css">
    <link href="css/colorbox.css" rel="stylesheet" type="text/css">
    <link href="css/jquery.rateyo.css" rel="stylesheet" type="text/css">
    <link href="css/emoticons.css" rel="stylesheet" type="text/css">
    <link href="css/froala_editor.css" rel="stylesheet" type="text/css">
    <link href="css/froala_style.css" rel="stylesheet" type="text/css">
    <link href="css/code_view.css" rel="stylesheet" type="text/css">
    <link href="css/colors.css" rel="stylesheet" type="text/css">
    <link href="css/emoticons.css" rel="stylesheet" type="text/css">
    <link href="css/image_manager.css" rel="stylesheet" type="text/css">
    <link href="css/image.css" rel="stylesheet" type="text/css">
    <link href="css/line_breaker.css" rel="stylesheet" type="text/css">
    <link href="css/table.css" rel="stylesheet" type="text/css">
    <link href="css/char_counter.css" rel="stylesheet" type="text/css">
    <link href="css/video.css" rel="stylesheet" type="text/css">
    <link href="css/fullscreen.css" rel="stylesheet" type="text/css">
    <link href="css/file.css" rel="stylesheet" type="text/css">
    <link href="css/custom.css" rel="stylesheet" type="text/css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="">
    <link href="https://fonts.googleapis.com/css2?family=Maven+Pro:wght@400..900&amp;display=swap" rel="stylesheet">

</head>

<body>
    <div id="sb-site" class="container">
        <div class="mp-pusher" id="mp-pusher">
            <div class="scroller">
                <div class="content-page">

                    <style>
                    .container.login {
                        background: #000000;
                        text-align: center;
                        padding: 10px;
                    }
                    </style>

                    <div class="container">
                        <div class="headergame">
                            <a href=""><img style="width:100%" id="slide" src="images/banner.jpg" alt="hihihehe"></a>
                        </div>
                        <div class="row body-content">
                            <div class="form-login">

                                <form action="ajax/forgot.php"
                                    onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;"
                                    class="loginform" name="login" id="register" autocomplete="off">

                                    <div class="input-group fl-center">
                                        <img class="image-logo" src="images/logo.png" alt="" srcset="">
                                    </div>
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                        <input type="text" class="form-control text-left" id="inputEmail"
                                            name="username" placeholder="Tên đăng nhập" value="">
                                    </div>
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                                        <input type="email" class="form-control" id="inputMail" name="email"
                                            placeholder="Địa chỉ Email">
                                    </div>


                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                                        <input type="number" class="form-control" id="inputPhone" name="tel"
                                            placeholder="Số điện thoại">
                                    </div>

                                    <div class="form-group">
                                        <div class="input-group">
                                            <span class="input-group-addon"><i class="fa fa-codiepie"></i></span>
                                            <input type="text" class="form-control" name="captcha" id="user_name"
                                                value="" style="height:50px;" placeholder="Mã captcha">
                                            <span class="input-group-addon captcha" id="refreshCaptcha"> <img
                                                    src="get_captcha.php" alt="Captcha"></span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-default">Xác nhận thông tin</button>
                                    </div>
                                    <div class="form-group">

                                        <span class="flr"><a href="forgot.html">Quên mật
                                                khẩu?</a></span>
                                    </div>
                                    <div class="clear"></div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <style>
                .cycle {
                    padding: 0 !important;
                    border-bottom: 4px double #fa5b36;
                    margin: 0 !important;
                    position: relative;
                    z-index: 9999;
                }

                .topcycle {
                    background: #fff none repeat scroll 0 0;
                    bottom: -10px;
                    display: inline-block;
                    height: 30px;
                    left: 0;
                    margin: 0 auto;
                    position: absolute;
                    right: 0;
                    width: 60px;
                    z-index: 1;
                }

                .topcycle {
                    border-top-left-radius: 70px;
                    border-top-right-radius: 70px;
                    border: 4px double #fa5b36;
                    border-bottom: 1px solid #fff;
                    background: #F8F8F8;
                }

                .calc {
                    margin-top: -28px;
                }

                .calcidden {
                    height: 15px;
                    background: #fff;
                    width: 100%;
                    z-index: 999999;
                    position: relative
                }

                .fontsize35 {
                    font-size: 22px;
                    color: #fa5b36;
                    font-weight: 600;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .row.bottool {
                    margin-top: -5px;
                    z-index: 9999999;
                    position: relative;
                    background: #fff;
                }

                .row.bottool {
                    font-weight: 500
                }
                </style>
                <div class="container">
                    <div class="menubottom" style="max-width: inherit;z-index:99; padding-bottom: 10px">
                        <div class="row cycle">

                        </div>
                        <div class="calcidden"></div>
                        <div class="row bottool">
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_trangchu;?>"><i
                                        class="fa fa-home fontsize40"></i></a><br><a href="">Home</a></div>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_fanpage;?>">
                                    <i class="fa fa-facebook fontsize40"></i><br>Fanpage</a></div>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_zalo;?>">
                                    <i class="fa fa-users fontsize40"></i><br>Zalo</a></div>
                            <div class="col-xs-5ths text-center"><a href="<?php echo $url_taigame;?>">
                                    <i class="fa fa-download fontsize40"></i><br>Download</a></div>
                        </div>
                    </div>
                </div>
                <div class="container"></div>
            </div>
        </div>
    </div>
    <script src="assets/libs/jquery/dist/jquery.min.js"></script>
    <script src="assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

    <script src="js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.min.css" rel="stylesheet">
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>




</body>

</html>