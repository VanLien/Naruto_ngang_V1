<?php include ('../config/config.php');?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AdminCP </title>
    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Tempusdominus Bootstrap 4 -->
    <link rel="stylesheet" href="plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
    <!-- iCheck -->
    <link rel="stylesheet" href="plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- JQVMap -->
    <link rel="stylesheet" href="plugins/jqvmap/jqvmap.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <!-- overlayScrollbars -->
    <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
    <!-- Daterange picker -->
    <link rel="stylesheet" href="plugins/daterangepicker/daterangepicker.css">
    <!-- summernote -->
    <link rel="stylesheet" href="plugins/summernote/summernote-bs4.min.css">

    <link href="plugins/sweetalerts/sweetalert2.min.css" rel="stylesheet" type="text/css" />
    <link href="plugins/sweetalerts/sweetalert.css" rel="stylesheet" type="text/css" />
    <!-- jQuery -->
    <script src="plugins/jquery/jquery.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="plugins/jquery-ui/jquery-ui.min.js"></script>

</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">

        <!-- Preloader -->
        <div class="preloader flex-column justify-content-center align-items-center">
            <img class="animation__shake" src="dist/img/AdminLTELogo.png" alt="AdminLTELogo" height="60" width="60">
        </div>

        <!-- Navbar -->
        <nav class="main-header navbar navbar-expand navbar-white navbar-light">
            <!-- Left navbar links -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
                </li>
                <li class="nav-item d-none d-sm-inline-block">
                    <a href="<?php echo $url_trangchu;?>" class="nav-link">Trang Chủ</a>
                </li>
            </ul>

            <!-- Right navbar links -->
            <ul class="navbar-nav ml-auto">
                <!-- Navbar Search -->



                <li class="nav-item">
                    <a class="nav-link" data-widget="fullscreen" href="#" role="button">
                        <i class="fas fa-expand-arrows-alt"></i>
                    </a>
                </li>

            </ul>
        </nav>

        <?php 
if (!$_SESSION['username_admin']) movePage('index.php');
?>

        <!--  END NAVBAR  -->

        <?php include('sidebar.php'); ?>

        <link rel="stylesheet" href="plugins/select2/css/select2.min.css">
        <link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
        <link rel="stylesheet" href="plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
        <link rel="stylesheet" href="plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
        <link rel="stylesheet" href="plugins/datatables-buttons/css/buttons.bootstrap4.min.css">

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->

            <!-- /.content-header -->

            <!-- Main content -->
            <section class="content">
                <div class="container-fluid">
                    <!-- Small boxes (Stat box) -->

                </div>



                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Tìm kiếm nhân vật</h3>
                            </div>
                            <!-- /.card-header -->
                            <div class="card-body">

                                <form>
                                    <div class="card-body">

                                        <div class="form-group">
                                            <label>Loại tìm kiếm</label>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="searchType" id="searchCharacter" value="character" checked>
                                                <label class="form-check-label" for="searchCharacter">
                                                    Tên nhân vật
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="searchType" id="searchUsername" value="username">
                                                <label class="form-check-label" for="searchUsername">
                                                    Tên người dùng
                                                </label>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="searchInput" id="searchLabel">Tên nhân vật</label>
                                            <input type="text" class="form-control" id="searchInput"
                                                placeholder="Tên nhân vật">
                                        </div>

                                        <div id="searchResults" class="mt-3">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th>Tên người dùng</th>
                                                        <th>Tên nhân vật</th>
                                                        <th>Server</th>
                                                        <th>Cấp độ</th>
                                                        <th>VIP</th>
                                                        <th>Hiển thị</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="resultsBody">
                                                </tbody>
                                            </table>
                                        </div>

                                    
                                </form>

                            </div>


                            </script>
                            <!-- /.card-body -->
                        </div>
                    </div>
                    <!-- /.card -->
                </div>



                <!-- /.row (main row) -->
        </div><!-- /.container-fluid -->
        </section>
        <!-- /.content -->
    </div>
    <script src="plugins/inputmask/jquery.inputmask.min.js"></script>
    <script src="plugins/select2/js/select2.full.min.js"></script>
    <!-- DataTables  & Plugins -->
    <script src="plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
    <script src="plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
    <script src="plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
    <script src="plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
    <script src="plugins/datatables-buttons/js/buttons.bootstrap4.min.js"></script>
    <script src="plugins/jszip/jszip.min.js"></script>
    <script src="plugins/pdfmake/pdfmake.min.js"></script>
    <script src="plugins/pdfmake/vfs_fonts.js"></script>
    <script src="plugins/datatables-buttons/js/buttons.html5.min.js"></script>
    <script src="plugins/datatables-buttons/js/buttons.print.min.js"></script>
    <script src="plugins/datatables-buttons/js/buttons.colVis.min.js"></script>


    <script>
    $(document).ready(function() {
        let searchTimeout;
        
        // Xử lý thay đổi loại tìm kiếm
        $('input[name="searchType"]').on('change', function() {
            const searchType = $(this).val();
            const searchInput = $("#searchInput");
            const searchLabel = $("#searchLabel");
            
            if(searchType === 'username') {
                searchLabel.text('Tên người dùng');
                searchInput.attr('placeholder', 'Tên người dùng');
            } else {
                searchLabel.text('Tên nhân vật');
                searchInput.attr('placeholder', 'Tên nhân vật');
            }
            
            // Xóa kết quả cũ khi thay đổi loại tìm kiếm
            $("#resultsBody").html('');
        });
        
        $("#searchInput").on('input', function() {
            clearTimeout(searchTimeout);
            const searchValue = $(this).val();
            const searchType = $('input[name="searchType"]:checked').val();
            
            if(searchValue.length > 2) {
                searchTimeout = setTimeout(function() {
                    $.ajax({
                        url: '../gameAPI/checkRole.php',
                        method: 'GET',
                        data: { 
                            pattern: searchValue, 
                            key: 'admin',
                            searchType: searchType
                        },
                        success: function(response) {
                            console.log('Response:', response); // Debug log
                            let html = '';
                            
                            if(response && response.length > 0) {
                                response.forEach(function(item) {
                                    html += `
                                        <tr>
                                            <td>${item.userName || ''}</td>
                                            <td>${item.characterName || ''}</td>
                                            <td>${item.server || ''}</td>
                                            <td>${item.level || ''}</td>
                                            <td>${item.vip || ''}</td>
                                            <td>${item.display_name || ''}</td>
                                        </tr>
                                    `;
                                });
                            } else {
                                html = '<tr><td colspan="6" class="text-center">Không tìm thấy kết quả</td></tr>';
                            }
                            
                            $("#resultsBody").html(html);
                        },
                        error: function(xhr, status, error) {
                            console.error('Lỗi AJAX:', error);
                            $("#resultsBody").html('<tr><td colspan="6" class="text-center">Có lỗi xảy ra khi tìm kiếm</td></tr>');
                        }
                    });
                }, 500);
            } else {
                $("#resultsBody").html('');
            }
        });
    });
    </script>


    <?php include('footer.php'); ?>