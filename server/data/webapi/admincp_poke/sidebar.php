<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->


    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Sidebar user panel (optional) -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <img src="dist/img/user2-160x160.jpg" class="img-circle elevation-2" alt="User Image">
            </div>
            <div class="info">
                <a href="#" class="d-block">Quản lý ID</a>
            </div>
        </div>

        <!-- SidebarSearch Form -->
        <div class="form-inline">
            <div class="input-group" data-widget="sidebar-search">
                <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
                <div class="input-group-append">
                    <button class="btn btn-sidebar">
                        <i class="fas fa-search fa-fw"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->


                <li class="nav-item menu-open">
                    <a href="#" class="nav-link active">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Bảng điều khiển
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">


                    <li class="nav-item">
                            <a href="cauhinh.php" class="nav-link">
                                <i class="nav-icon fas fa-cog"></i>
                                <p>
                                   Cấu hình

                                </p>
                            </a>
                        </li>


                        <li class="nav-item">
                            <a href="the-cao.php" class="nav-link">
                                <i class="nav-icon fas fa-home"></i>
                                <p>
                                    Thống kê doanh thu

                                </p>
                            </a>
                        </li>

                        <li class="nav-item">
                            <a href="bao-cao-doanh-thu.php" class="nav-link">
                                <i class="nav-icon fas fa-file-alt"></i>
                                    <p>
                                        Báo cáo doanh thu

                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="danh-sach-thanh-vien.php" class="nav-link">
                                <i class="nav-icon fas fa-list"></i>
                                <p>
                                    Danh sách tài khoản

                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="checkNV.php" class="nav-link">
                                <i class="nav-icon fas fa-list"></i>
                                <p>
                                    Tìm kiếm nhân vật

                                </p>
                            </a>
                        </li>
                        <?php if(isSuperAdmin($_SESSION['username_admin'])){ ?>
                        <li class="nav-item">
                            <a href="congtienuser.php" class="nav-link">
                                <i class="nav-icon fas fa-plus"></i>
                                <p>
                                    Cộng tiền User

                                </p>
                            </a>
                        </li>
                        <?php } ?>
                        <li class="nav-item">
                            <a href=" lich-su-mua-goi.php" class="nav-link">
                                <i class="nav-icon fas fa-user"></i>
                                <p>
                                    Lịch Sử Mua Gói

                                </p>
                            </a>
                        </li>

                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-chart-pie"></i>
                                <p>
                                    Quản Lý Event Tích Nạp
                                    <i class="right fas fa-angle-left"></i>
                                </p>
                            </a>
                            <ul class="nav nav-treeview" style="display: none;">
   

                                <li class="nav-item">
                                    <a href="  quanlyeventtichluy.php" class="nav-link">
                                        <i class="far fa-circle nav-icon"></i>
                                        <p>Quản lý Tích Lũy Nạp</p>
                                    </a>
                                </li>

                                <li class="nav-item">
                                    <a href="lichsucodetichnap.php" class="nav-link">
                                        <i class="far fa-circle nav-icon"></i>
                                        <p>Lịch sử  CODE Tích Nạp</p>
                                    </a>
                                </li>



                            </ul>
                        </li>


                        
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-icon fas fa-chart-pie"></i>
                                <p>
                                    Quản Lý Event Gacha
                                    <i class="right fas fa-angle-left"></i>
                                </p>
                            </a>
                            <ul class="nav nav-treeview" style="display: none;">
                           
                                <li class="nav-item">
                                    <a href="  quanlyeventgacha.php" class="nav-link">
                                        <i class="far fa-circle nav-icon"></i>
                                        <p>Quản lý Event Gacha</p>
                                    </a>
                                </li>

                                <li class="nav-item">
                                    <a href="lichsucodetichnap.php" class="nav-link">
                                        <i class="far fa-circle nav-icon"></i>
                                        <p>Lịch sử  CODE Gacha</p>
                                    </a>
                                </li>



                            </ul>
                        </li>



                        <?php if(isSuperAdmin($_SESSION['username_admin'])){ ?>
                        <li class="nav-item">
                            <a href=" lich-su-admin.php" class="nav-link">
                                <i class="nav-icon fas fa-user"></i>
                                <p>
                                    Check lịch sử Admin

                                </p>
                            </a>
                        </li>
                        <?php } ?>

                        <li class="nav-item">
                            <a href="lich-su-thanh-vien.php" class="nav-link">
                                <i class="nav-icon fas fa-user"></i>
                                <p>
                                    Check lịch sử User

                                </p>
                            </a>
                        </li>



                    </ul>
                </li>

                <li class="nav-item">
                    <a href="changepassadmin.php" class="nav-link">
                        <i class="nav-icon fas fa-clock"></i>
                        <p>
                            Đổi mật khẩu Admin

                        </p>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="thoat.php" class="nav-link">
                        <i class="nav-icon fas fa-sign-out-alt"></i>
                        <p>
                            Thoát

                        </p>
                    </a>
                </li>

            </ul>
            </li>






            </ul>

        </nav>


        <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
</aside>