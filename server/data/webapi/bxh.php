<?php include("header.php") ?>

<body>
    <!--  Body Wrapper -->
    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">
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
                <?php include("sidebar.php") ?>
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
                            <a href="topup.html" target="_blank" class="btn btn-primary"><?php echo number_format($data['xu']) ?> XU <iconify-icon icon="tabler:coin"></iconify-icon> </a>
                            <li class="nav-item dropdown">
                                <a class="nav-link " href="javascript:void(0)" id="drop2" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="assets/images/backgrounds/poke.png" alt="" width="35" height="35" class="rounded-circle">
                                </a>
                                <div class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop2">
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
                            <h5 class="card-title fw-semibold mb-4">TOP 10 BXH Nạp XU</h5>
                            <div class="card">
                                <div class="card-body">
                                    <!-- lịch sử giao dịch ---->
                                    <div data-simplebar class="position-relative">
                                        <div class="table-responsive products-tabel" data-simplebar>
                                            <table class="table text-nowrap mb-0 align-middle table-hover">
                                                <thead class="fs-4">


                                                    <tr>
                                                        <th class="fs-3">TOP</th>
                                                        <th class="fs-3">Tên Tài Khoản</th>
                                                        <th class="fs-3">Tổng Nạp</th>
                                                    </tr>

                                                </thead>
                                                <tbody>
                                                    <?php
                                                    $data = $database->query(" SELECT SUM(menhgia) as TongTien ,username
                                                    FROM card 
                                                    WHERE trangthai = 2 
                                                    AND created_at BETWEEN '2024-07-01 12:03:56' AND '2024-09-01 12:03:56' GROUP BY username LIMIT 10")->fetchAll();
                                                    // $data = $database->select("card", "*",['username'=>$username]);
                                                    //print_r($data);
                                                    $i = 0;
                                                    foreach ($data as $history) {
                                                    $i++;
                                                    ?>
                                                        <tr>

                                                            <th><?php echo $i?></th>
                                                            <th><?php echo $history['username'] ?></th>
                                                            <th><?php echo number_format($history['TongTien']/1000) ?> Điểm</th>

                                                        </tr>
                                                    <?php }  ?>


                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php include("footer.php") ?>
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
        $(document).ready(function() {
            $("#card").hide();
            $("#atm").hide();

            $("#btn-card").click(function() {
                $("#card").show();
                $("#atm").hide();
            });
            $("#btn-atm").click(function() {
                $("#card").hide();
                $("#atm").show();
            });
        });
    </script>
</body>

</html>