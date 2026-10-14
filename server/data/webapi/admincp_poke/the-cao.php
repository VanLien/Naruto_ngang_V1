<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');
$data = $database->query("SELECT SUM(menhgia) as TongTien  FROM card WHERE trangthai = '2'")->fetchAll();
$dataBank = $database->query("SELECT SUM(menhgia) as TongTienBank  FROM card WHERE `mathe` = 'Bank' OR `mathe` = 'Momo' AND trangthai = '2' ")->fetchAll();

foreach ($dataBank as $bank) {
    $tongtienBank =  $bank['TongTienBank'];
}

foreach ($data as $item) {
    $tongtien =  $item['TongTien'];
}

$tongtienThe = $tongtien - $tongtienBank;

$today = date("Y-m-d 00:00:00");
$endtoday = date("Y-m-d 23:59:59");

$getCurrentDate = $database->query("SELECT sum(menhgia)  as Homnay FROM card WHERE created_at BETWEEN '{$today}'  AND '{$endtoday}' AND trangthai =2  ")->fetchAll();
foreach ($getCurrentDate as $datas) {
    $todaynap = $datas['Homnay'];
}
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
    <div class="content-header">
        <div class="row">
            <div class="col-md-3 col-sm-6 col-12">
                <div class="info-box">
                    <span class="info-box-icon bg-warning"><i class="far fa-heart"></i></span>

                    <div class="info-box-content">
                        <span class="info-box-text">Tổng tiền nạp</span>
                        <span class="info-box-number"><?php echo number_format($tongtien); ?> VNĐ</span>
                        <span class="info-box-number">Bank / Momo : <?php echo number_format($tongtienBank); ?> VNĐ</span>
                        <span class="info-box-number">Thẻ Cào : <?php echo number_format($tongtienThe); ?> VNĐ</span>
                    </div>
                    <!-- /.info-box-content -->
                </div>
            </div>

            <div class="col-md-3 col-sm-6 col-12">
                <div class="info-box">
                    <span class="info-box-icon bg-success"><i class="	fa fa-credit-card"></i></span>

                    <div class="info-box-content">
                        <span class="info-box-text">Tổng tiền nạp hôm nay </span>
                        <span class="info-box-number"><?php echo number_format($todaynap); ?> VNĐ</span>
                        <a href="javascript:void(0);" onclick="xoagiaodichrac();"><button type="button" class="btn btn-block btn-danger">Xóa Giao Dịch Rác</button> </a>
                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#vipUser">
                            Xem danh sách VIP
                        </button>
                    </div>

                    <!-- /.info-box-content -->
                </div>
            </div>

        </div>
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            <!-- Small boxes (Stat box) -->


            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Danh sách thẻ nạp</h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <table id="example1" class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>ID Giao Dịch</th>
                                        <th>Tài Khoản</th>
                                        <th>Mệnh Giá</th>
                                        <th>Loại Thẻ</th>
                                        <th>Seri</th>
                                        <th>Pin</th>
                                        <th>ID Giao Dịch</th>
                                        <th>Status</th>
                                        <th>Time</th>

                                        <th>Action</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <?php


                                    $data = $database->query("SELECT * FROM card ORDER BY id DESC")->fetchAll();
                                    //print_r($data);
                                    foreach ($data as $card) {

                                    ?>

                                        <tr>
                                            <td><?php echo strtoupper($card['id']) ?></td>
                                            <td><?php echo $card['username'] ?></td>
                                            <td><?php echo number_format($card['menhgia']) ?></td>
                                            <td><?php echo $card['loaithe'] ?></td>
                                            <td><?php echo $card['seri'] ?></td>
                                            <td><?php echo $card['mathe'] ?></td>
                                            <td><?php echo $card['idgiaodich'] ?></td>
                                            <th>
                                                <?php
                                                switch ($card['trangthai']) {
                                                    case 4:
                                                        echo "<font color='blue'>Đang chờ sử lý</font>";
                                                        break;
                                                    case 3:
                                                        echo "<font color='red'>Thẻ sai</font>";
                                                        break;
                                                    case 2:
                                                        echo "<font color='#006400'>Đã duyệt</font>";
                                                        break;
                                                }
                                                ?>


                                            </th>
                                            <td>

                                                <?php
                                                echo $card['created_at'];
                                                ?>

                                            </td>

                                            <td>
                                                <?php if ($card['trangthai'] != 2) { ?>
                                                    <a href="javascript:void(0);" onclick="duyetthe('<?php echo $card['idgiaodich'] ?>');"><button type="button" class="btn btn-block btn-danger">Duyệt GD</button> </a>
                                                <?php } ?>
                                            </td>

                                        </tr>

                                    <?php } ?>
                                    </tfoot>
                            </table>
                        </div>

                        <!-- /.card-body -->
                    </div>
                </div>
                <!-- /.card -->
            </div>

            <div class="modal fade " id="vipUser">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Danh sách top nạp</h4>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">


                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                       
                                        <th>User</th>
                                        <th>Tổng Nạp</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>

                                <?php 
                                $dataSum = $database->query("SELECT username , SUM(menhgia) as tongtien  FROM card WHERE trangthai = 2 GROUP BY username ORDER BY tongtien DESC")->fetchAll();
                                foreach ($dataSum as $dataVIP) {
                                    ?>
                                    <tr>
                                    
                                        <td><?php echo $dataVIP['username'] ?></td>
                                        <td>
                                        <?php echo number_format($dataVIP['tongtien'])?>
                                        </td>
                                        
                                    </tr>
                            <?php 
                                }
                                ?>
                                    
                                   
                                   
                                </tbody>
                            </table>

                        </div>
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

                        </div>
                    </div>
                    <!-- /.info-box-content -->
                </div>
            </div>

            <script>
                function duyetthe(idgiaodich) {
                    var idgiaodich = idgiaodich;
                    swal({
                        title: 'Bạn có chắc?',
                        text: "duyệt giao dịch này ?",
                        type: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'OK',
                        padding: '2em'
                    }).then(function(result) {
                        if (result.value) {
                            $.ajax({
                                url: "ajax/duyetthe.php",
                                method: 'POST',
                                dataType: 'json',
                                data: {
                                    idgiaodich: idgiaodich,
                                    username: "<?php echo $_SESSION['username'] ?>",
                                },
                                success: function(resp) {
                                    if (resp.type == 0) {

                                        swal({
                                            title: 'Success',
                                            text: resp.msg,
                                            type: 'success',
                                            padding: '2em'
                                        })

                                        window.setTimeout(function() {
                                            window.location.reload();
                                        }, 1000);
                                    } else {


                                        swal({
                                            title: 'Error',
                                            text: resp.msg,
                                            type: 'error',
                                            padding: '2em'
                                        })
                                    }
                                }
                            })
                        }
                    })
                }



                function xoagiaodichrac() {
                    swal({
                        title: 'Bạn có chắc?',
                        text: "Xóa toàn bộ giao dịch rác chưa được duyệt?",
                        type: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'OK',
                        padding: '2em'
                    }).then(function(result) {
                        if (result.value) {
                            $.ajax({
                                url: "ajax/xoagiaodichrac.php",
                                method: 'POST',
                                dataType: 'json',
                                data: {
                                    username: "<?php echo $_SESSION['username'] ?>",
                                },
                                success: function(resp) {
                                    if (resp.type == 0) {

                                        swal({
                                            title: 'Success',
                                            text: resp.msg,
                                            type: 'success',
                                            padding: '2em'
                                        })

                                        window.setTimeout(function() {
                                            window.location.reload();
                                        }, 1000);
                                    } else {


                                        swal({
                                            title: 'Error',
                                            text: resp.msg,
                                            type: 'error',
                                            padding: '2em'
                                        })
                                    }
                                }
                            })
                        }
                    })
                }
            </script>
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
    $(function() {
        $("#example1").DataTable({
            "order": [
                [0, "desc"]
            ],
            "responsive": true,
            "lengthChange": false,
            "autoWidth": false,
            "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"]
        }).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');

    });
</script>


<?php include('footer.php'); ?>