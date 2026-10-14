
<?php
    include("config/config.php");
    $username = $_SESSION['username'];
    if (!$_SESSION['username']) movePage('login.html');	
        
    $data = $database->get("account", [
        "id",
        "username",
        "email",
        "phone",
        "regDate",
        "xu",
        "pass2",
        "lastTimeLogin",
        "LastLoginIP"
    ], [
    "username" => $username
    ]);

    //var_dump($data) ;
    
    $time = time();
    
    $sign = md5($time.$key.$username);
    ?>


<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <meta name="robots" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-title" content="" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="shortcut icon" type="image/x-icon" href="images/favicon.png" />
    <link rel="icon" type="image/x-icon" href="/images/favicon.png">
    <title><?php echo $title;?></title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="copyright" content="" />
    <meta name="keywords" content="" />
    <meta property="og:site_name" content="" />
    <meta property="og:title" content="<?php echo $title;?>" />
    <meta property="og:description" content="" />
    <meta property="og:image" content="images/banner.jpg" />
    <meta property="og:image:type" content="image/jpeg" />
    <link href="css/font.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/jquery-ui.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/rwdgrid.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/style.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/style_new.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/emoticons.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/font-awesome.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/font-awesome-animation.min.css?v=333" rel="stylesheet" type="text/css" />
    <link href="css/responsiveslides.css?v=333" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="css/jquery.dataTables.min.css">
    <link href="css/custom.css?v=333" rel="stylesheet" type="text/css" />
    <script src="js/sweetalert.all.js?v=333" type="text/javascript"></script>
    <script type="text/javascript" src="js/jquery-1.11.1.min.js?v=333"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Maven+Pro:wght@400..900&display=swap" rel="stylesheet">



        <!-- Meta Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '583107378171789');
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id=583107378171789&ev=PageView&noscript=1"
/></noscript>
<!-- End Meta Pixel Code -->


        <!-- Meta Pixel Code -->
<script>
    !function(f,b,e,v,n,t,s)
    {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
    n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];
    s.parentNode.insertBefore(t,s)}(window, document,'script',
    'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '1160621275170608');
    fbq('track', 'PageView');
    </script>
    <noscript><img height="1" width="1" style="display:none"
    src="https://www.facebook.com/tr?id=1160621275170608&ev=PageView&noscript=1"
    /></noscript>
    <!-- End Meta Pixel Code -->
</head>


    <!-- Meta Pixel Code -->
    <script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '717355314116966');
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id=717355314116966&ev=PageView&noscript=1"
/></noscript>
<!-- End Meta Pixel Code -->


<!-- Meta Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '1243622837537234');
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id=1243622837537234&ev=PageView&noscript=1"
/></noscript>
<!-- End Meta Pixel Code -->

<body>
    <div id="fb-root"></div>
    <div id="sb-site" class="container">
        <div class="mp-pusher" id="mp-pusher">
            <div class="scroller marbt80">
                <style>
                    .loginuser i.fa-commenting-o {
                        line-height: 17px;
                    }
                </style>
                <style>
                    .ngoaia {
                        background: rgba(0, 0, 0, 0) linear-gradient(to top, rgb(0, 0, 0), transparent) repeat scroll 0 0;
                        bottom: 0;
                        height: 33%;
                        left: 0;
                        position: absolute;
                        width: 100%;
                        z-index: 3;
                    }

                    .ngoaia a {
                        bottom: 15px;
                        color: #fff;
                        display: inline-block;
                        font-size: 15px;
                        left: 20px;
                        line-height: 18px;
                        margin: auto;
                        max-height: 91%;
                        overflow: hidden;
                        position: absolute;
                        width: calc(100% - 30px);
                        z-index: 5;
                    }
                </style>
                <div class="container clearfix topga">
                    <div class="headergame">
                        <a href=""><img style="width:100%" id="slide" 
                                src="images/banner.jpg" alt="hihihehe"></a>
                    </div>
                    <div class="row botgame clearfix" style="margin-top: -20px; padding: 0!important;">
                        <div class="fll" style="margin-left: 5px;">
                            <a href=""><img align="left" class="avataruser" id="avataruser"
                                    src="images/logo.png" alt="hihihehe"></a>
                        </div>
                        <div class="row clearfix xxxxxx" style="margin-top: 30px;">
                            <div class="fll" style="padding-left: 10px;">
                            <a class="btn-default flr" href="topup.html"
                                style="border: 1px solid #4188D8; border-radius:4px; padding: 4px 10px; color: #4188D8; margin-top: 10px; margin-right: 4px">
                                Xu : <?php echo number_format($data['xu']);?>
                            </a>
                               
                            </div>
                            <a class="btn-default flr" href="thoat.html"
                                style="border: 1px solid #fa5b36; border-radius:4px; padding: 4px 10px; color: #fa5b36; margin-top: 10px; margin-right: 4px">
                                Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
                <div class="container button_">
                    <div class="row ds-center menubottom1">
                        <div class="col-xs-5ths text-center"><a href="/card.html"><i
                                    class="fa fa-money fontsize40 color3"></i>
                                <div class="margintext">Nạp Thẻ Cào</div>
                            </a></div>

                           
                        <div class="col-xs-5ths text-center"><a href="/nap-tien.html"><i
                                    class="fa fa-money fontsize40 color3"></i>
                                <div class="margintext">Nạp Banking</div>
                            </a></div>

                            <div class="col-xs-5ths text-center"><a href="history.html"><i
                                    class="fa fa-calendar-o fontsize40 color4"></i>
                                <div class="margintext">Lịch sử</div>
                            </a></div>
                            
                    </div>
                </div>