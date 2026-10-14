<!DOCTYPE html>
<!--[if lt IE 7]>
<html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]--><!--[if IE 7]>
<html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]--><!--[if IE 8]>
<html class="no-js lt-ie9" lang=""> <![endif]--><!--[if gt IE 8]><!-->
<html class="no-js" lang="">
<!--<![endif]-->

<head>
    <?php include 'config/config.php';
    if ($_SESSION['username'])
        movePage('index.html');
    ?>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

    <meta name="robots" content="index, follow">
    <title>
        <?php echo $title; ?>
    </title>
    <meta name="description" content="<?php echo $title; ?>">
    <meta property="og:title" content="<?php echo $title; ?>">
    <meta property="og:url" content="">
    <meta property="og:image" content="images/fb-thumb.jpg">
    <meta property="og:site_name" content="<?php echo $title; ?>">
    <meta property="og:description" content="<?php echo $title; ?>">
    <meta name="description" content="<?php echo $title; ?>">
    <link rel="stylesheet" href="css/style.css?v=1.28">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css?v=1.28" rel="stylesheet">
    <link rel="stylesheet" href="css/custom.css?v=1.28">

    <!-- Javascript -->
    <script src="js/jquery.1.12.4.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/owl.carousel.js"></script>
    <script src="js/isc-core.js"></script>
    <script src="js/common.js"></script>
    <script src="js/main.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.min.css" rel="stylesheet">
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif] -->
</head>

<body>
    <div id="loader-wrapper">
        <div id="loader"></div>
    </div>

    <div class="c-wrapper t-wrapper-bottom">
        <div class="c-wrapper t-wrapper-top">

            <!-- Header -->
            <header class="header">
                <nav class="navbar navbar-default t-navbar-default navbar-fixed-top c-header t-header"
                    role="navigation">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="navbar-header">
                                    <div class="WidthChange">


                                        <a class="navbar-brand icons-logo t-icons-logo" href="id.cmn.html"
                                            title="CMN Online">
                                            <img src="images/logo.png">
                                        </a>
                                    </div>
                                    <div class="pull-right pt5 pb5">
                                        <div class="pull-change">
                                            <a href="<?php echo $url_taigame ?>" class="nap_game_btn"
                                                title="N&#7841;p Game" target="_blank">
                                                <i class="fa fa-download"></i> Tải Game
                                            </a>
                                            <a href="<?php echo $url_site ?>" class=" t-icons-game" title="Game"
                                                target="_blank">
                                                <i class="fa fa-home"></i> Trang Chủ
                                            </a>
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </nav>
            </header>
            <!-- End - Header -->
            <main>
                <div class="container">
                    <div class="row">
                        <div class="col-sm-5 col-md-5 col-sm-5 col-centered">
                            <div class="dangky-home">

                                <div class="dangky-home-box">
                                    <div class="dangky-home-content">

                                        <h3 class="title_form"><span class="textorange textbold">ĐĂNG KÝ TÀI KHOẢN
                                            </span></h3>

                                        <form action="ajax/register.php"
                                            onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;">

                                            <p class="text-left">Đăng ký tài khoản
                                                <?php echo $title ?><br>
                                                Nếu bạn đã có tài khoản, vui lòng
                                                <a class="TextRed" href="login.html">Đăng
                                                    Nhập</a> hoặc
                                                <a href="forgot.html" target="_top" class="TextBlue">Tìm
                                                    lại mật khẩu</a>
                                            </p>

                                            <div class="form-group">
                                                <label for="UserName">user</label>
                                                <input name="username" id="UserName" type="text" required="" value=""
                                                    class="form-control" placeholder="Tên đăng nhập">
                                                <span class="icons-icon-user icon-img"></span>

                                                <span class="text-note2 text-hoa">*</span>


                                                <p class="text-note text-left">- Tên đăng nhập dài 6-12 ký tự Thường và
                                                    Số</p>
                                            </div>


                                            <div class="form-group">
                                                <label for="Password">mật khẩu</label>
                                                <input name="password" type="password" id="Password" required=""
                                                    class="form-control" placeholder="Mật khẩu"
                                                    aria-autocomplete="list">
                                                <span class="icons-icon-password icon-img"></span>

                                                <span class="text-note2 text-hoa">*</span>
                                            </div>



                                            <div class="form-group">
                                                <label for="Email">Email</label>
                                                <input name="email" type="email" id="Email" required=""
                                                    class="form-control" placeholder="Email">
                                                <span class="icons-icon-email icon-img"></span>

                                                <span class="text-note2 text-hoa">*</span>


                                            </div>



             
                                            <div class="form-group clearfix">
                                        <div class="widthsmall">
                                            <label for="Captcha">nhập mã</label>
                                            <input type="text" name="captcha" id="Captcha" required=""
                                                class="form-control cancelW" placeholder="Mã kiểm tra ">
                                            <span class="text-note2 text-hoa">*</span>
                                        </div>
                                        <div class="pull-right capcha">
                                            <img id="imageCaptcha" title="Hãy click vào hình để nhận mã mới"
                                                style="cursor:pointer" src="get_captcha.php">

                                        </div>
                                        <div class="pull-left">

                                            <p class="text-note text-left mb0">- Nhập mã kiểm tra bên cạnh. </p>

                                        </div>
                                    </div>


                                    </div>


                                    <div class="box-submit">

                                        <p>
                                            <button type="submit" class="btn bt-click">đăng ký</button>
                                        </p>


                                    </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
        </div>

        </main>
        <footer class="footer c-footer t-footer">
            <div class="container">
                <div class="row">
                    <div class="col-sm-12 col-md-9">
                        <div class="text-left">
                            <p>
                                <strong style="text-transform: uppercase;">Hội Yêu Kiếm Thế</strong>
                            </p>
                            <p>
                                Phát triển và vận hành bởi Hội Yêu Kiếm Thế 2009
                            </p>

                        </div>
                    </div>

                    <div class="col-sm-12 col-md-3">
                        <div class="text-left">
                            <p style="font-size: 12px;font-weight: bold;margin-bottom: 0">HOTLINE <br>
                                <a href="tel:<?php echo $hotline ?>" class="hotline"
                                    style="color: #ff2400; font-size: 14px;    font-weight: 200;">
                                    <?php echo $hotline ?>
                                </a>
                            </p>

                            <p>&nbsp;</p>

                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>
    </div>
    <div id="skm_LockPane"></div>
</body>

</html>