<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');


?>
<!--  END NAVBAR  -->

<?php include('sidebar.php'); ?>

<link rel="stylesheet" href="plugins/select2/css/select2.min.css">
<link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-buttons/css/buttons.bootstrap4.min.css">

<link rel="stylesheet" href="plugins/icheck-bootstrap/icheck-bootstrap.min.css">
<link rel="stylesheet" href="plugins/daterangepicker/daterangepicker.css">
<link rel="stylesheet" href="plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->

    <!-- /.content-header -->

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            <!-- Small boxes (Stat box) -->
            <div class="row">
				<div class="col-12">
                <div class="card card-danger">
                    <div class="card-header">
                        <h3 class="card-title">Quản lý sự kiện</h3>
                    </div>
                    <div class="card-body">
<?php 

$event = $database->get(
	"event_tichluy",
	[
		"id",
		"name",
		"startDate",
		"endDate",
		"status"
	],
	[
		"status" => 1,
		"ORDER" => ["id" => "DESC"],
		"LIMIT" => 1
	]
);


?>
                        <div class="form-group">
                            <label>Bắt đầu:</label>
                            <div class="input-group date" id="startDate">
                                <input type="text" class="form-control"
                                    value="<?php echo $event['startDate']?>" >

                                <div class="input-group-append" data-target="#startDate"
                                    data-toggle="datetimepicker">
                                    <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                                </div>
                            </div>
                        </div>


                        <div class="form-group">
                            <label>Kết thúc:</label>
                            <div class="input-group date" id="endDate" data-target-input="nearest">
                                <input type="text" class="form-control datetimepicker-input"
                                    data-target="#endDate">
                                <div class="input-group-append" data-target="#endDate"
                                    data-toggle="datetimepicker">
                                    <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái:</label>
                            <div class="input-group date" id="reservationdatetime" data-target-input="nearest">
                                <input type="checkbox" name="my-checkbox" checked data-bootstrap-switch>
                            </div>
                        </div>
                    </div>





                </div>
				</div>


            </div>
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Lịch sử mua gói ingame</h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <table id="example1" class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>Username</th>
                                    <th>Gói</th>
                                    <th>Giá</th>
                                    <th>Thời Gian</th>


                                </tr>
                            </thead>
                            <tbody>
                                <?php 
								
								//$data = $database->query("SELECT  * FROM Account_Info")->fetchAll();
								$data = $database->select("log_rechagre", "*");
								//print_r($data);
								foreach($data as $history) {
									
							?>

                                <tr>

                                    <td><?php echo $history['username'] ?></td>
                                    <td><?php echo $history['rechargeName'] ?></td>
                                    <td><?php echo number_format($history['rechargePrice']) ?></td>
                                    <td><?php echo $history['timeDate'] ?></td>

                                </tr>

                                <?php } ?>
                                </tfoot>
                        </table>
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
$(function() {
    $("#example1").DataTable({
        "order": [
            [2, "desc"]
        ],
        "responsive": true,
        "lengthChange": false,
        "autoWidth": false,
        "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"]
    }).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');

});
</script>
<script src="plugins/moment/moment.min.js"></script>
<script src="plugins/inputmask/jquery.inputmask.min.js"></script>
<script src="plugins/daterangepicker/daterangepicker.js"></script>
<script src="plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
<script src="plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>

<script>
	    $('#startDate').datetimepicker(
			{ 
				icons: { time: 'far fa-clock' },
				 locale: 'ru'
			 }
		);
		$('#endDate').datetimepicker({ icons: { time: 'far fa-clock' } });

		$("input[data-bootstrap-switch]").each(function(){
      $(this).bootstrapSwitch('state', $(this).prop('checked'));
    });
</script>
<?php include('footer.php'); ?>