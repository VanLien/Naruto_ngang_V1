<?php include ("header.php") ?>

<body>
    <!--  Body Wrapper -->
    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
        data-sidebar-position="fixed" data-header-position="fixed">
        <!-- Sidebar Start -->
        <aside class="left-sidebar">
            <!-- Sidebar scroll-->
            <div>
                <div class="brand-logo d-flex align-items-center justify-content-between">
                    <a href="<?php echo $url_site ?>" class="text-nowrap logo-img">
                        <img src="assets/images/logos/logo.png" alt="" />
                    </a>
                    <div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
                        <i class="ti ti-x fs-8"></i>
                    </div>
                </div>
                <!-- Sidebar navigation-->
<?php include("sidebar.php")?>
                <!-- End Sidebar navigation -->
            </div>
            <!-- End Sidebar scroll-->
        </aside>
        <!--  Sidebar End -->
        <!--  Main wrapper -->
        <div class="body-wrapper">
            <!--  Header Start -->
            <header class="app-header">
                <nav class="navbar navbar-expand-lg navbar-light">
                    <ul class="navbar-nav">
                        <li class="nav-item d-block d-xl-none">
                            <a class="nav-link sidebartoggler " id="headerCollapse" href="javascript:void(0)">
                                <i class="ti ti-menu-2"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link " href="javascript:void(0)">
                                <iconify-icon icon="solar:bell-linear" class="fs-6"></iconify-icon>
                                <div class="notification bg-primary rounded-circle"></div>
                            </a>
                        </li>
                    </ul>
                    <div class="navbar-collapse justify-content-end px-0" id="navbarNav">
                        <ul class="navbar-nav flex-row ms-auto align-items-center justify-content-end">
                            <a href="topup.html" target="_blank"
                                class="btn btn-primary"><?php echo number_format($data['xu']) ?> XU <iconify-icon
                                    icon="tabler:coin"></iconify-icon> </a>
                            <li class="nav-item dropdown">
                                <a class="nav-link " href="javascript:void(0)" id="drop2" data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                    <img src="assets/images/backgrounds/poke.png" alt="" width="35" height="35"
                                        class="rounded-circle">
                                </a>
                                <div class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up"
                                    aria-labelledby="drop2">
                                    <div class="message-body">
                                        <a href="security.html" class="d-flex align-items-center gap-2 dropdown-item">
                                            <i class="ti ti-user fs-6"></i>
                                            <p class="mb-0 fs-3">Bảo mật tài khoản</p>
                                        </a>
                                        <a href="topup.html" class="d-flex align-items-center gap-2 dropdown-item">
                                            <i class="ti ti-mail fs-6"></i>
                                            <p class="mb-0 fs-3">Nạp thẻ</p>
                                        </a>

                                        <a href="thoat.html" class="btn btn-outline-primary mx-3 mt-2 d-block">Thoát</a>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>
            <!--  Header End -->
            <div class="body-wrapper-inner">
                <div class="container-fluid">


                    <div class="card" id="history">
                        <div class="card-body">
                            <h5 class="card-title fw-semibold mb-4">Chọn nhân vật và máy chủ</h5>
                            <div class="card">
                                <div class="card-body">
                                <?php 
                                if($_SESSION['roleName'] != ""){
                                    echo '<div class="alert alert-success" role="alert">
                                    Nhân vật <b>'.$_SESSION['roleName'].' </b> đã được chọn
                                  </div>';
                                  ?>
                                   

                                   <form action="ajax/chonnv.php"
                                        onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;">
                                        <?php echo createSign($time, $sign); ?>
                                            
                                            <input type="hidden" name="type" value="resetNV">
                                            
                                        <button type="submit" class="btn btn-primary">Chọn Nhân Vật Khác</button>
                                    </form>
                                  <?php
                                }else {
                                ?>
                                    <form action="ajax/chonnv.php"
                                        onsubmit="APIMUMOBILE.submitTarget(this,'#alertResult');return false;">
                                        <?php echo createSign($time, $sign); ?>


                                        <div class="mb-3">
                                            <label for="exampleInputEmail1" class="form-label">Máy chủ :</label>
                                            <select class="form-control select-control" name="server" required="">
                                                <option value="">Chọn máy chủ</option>
                                                <?php
                                                $data = $database->query("SELECT  * FROM `server` WHERE `status` = 1 ORDER BY id")->fetchAll();

                                                foreach ($data as $server) {

                                                    echo '<option value="' . $server['srv_name'] . '">' . $server['name'] . '</option>';

                                                }
                                                ?>
                                            </select>
                                        </div>

                                        <div class="mb-3" id="chonnv">
                                            <label for="exampleInputEmail1" class="form-label">Chọn nhân vật:</label>
                                            <select class="form-control select-control" name="roleID" required="">
                                                <option value="">Chọn nhân vật</option>
                                            </select>
              
                                        </div>

                                        <button type="submit" class="btn btn-primary">Chọn Nhân Vật</button>
                                    </form>
                                    <?php } ?>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php include ("footer.php") ?>
    </div>
    <div id="skm_LockPane"></div>
    <script src="assets/libs/jquery/dist/jquery.min.js"></script>
    <script src="assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/sidebarmenu.js"></script>
    <script src="assets/js/app.min.js"></script>
    <script src="assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="assets/libs/simplebar/dist/simplebar.js"></script>
    <script src="js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.2/dist/sweetalert2.min.css" rel="stylesheet">
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <script>

        $(document).ready(function () {
            $('select[name="server"]').change(function () {
                var server = $(this).val();
                $.ajax({
                    url: 'gameAPI/getRoleList.php',
                    type: 'POST',
                    data: {
                        username: '<?php echo $_SESSION['username'] ?>',
                        server: server
                    },
                    success: function (data) {
                        $('#chonnv').html(data);
                    }
                });
            });
        });
    </script>
</body>

</html>