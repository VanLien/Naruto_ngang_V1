<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');


	$dataPost = array(
				"access_token" => "Fcp1Nv1qFNLd2KAjpVKm4XQuneslxqpJZH2X8NuMYSEb7yyosZ", //token từ hệ thống
				"phone" => "0848550666", //số điện thoại Momo muốn lấy giao dịch
				"limit" => 10, //giới hạn số kết quảo trả về
				"offset" => 0 //Vị trí lấy kết quả
				);
	$curl = curl_init();
	curl_setopt_array($curl, array(
		CURLOPT_URL => "https://momosv3.apimienphi.com/api/getTransHistory",
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_SSL_VERIFYPEER => false,
		CURLOPT_MAXREDIRS => 10,
		CURLOPT_TIMEOUT => 30,
		CURLOPT_CUSTOMREQUEST => "POST",
		CURLOPT_POSTFIELDS => json_encode($dataPost),
		CURLOPT_HTTPHEADER => array(
			"Content-Type: application/json",
			"accept: application/json",
			"cache-control: no-cache"
								),
		));

	$response = curl_exec($curl);
	curl_close($curl);
	//hiện kết quả

	$data = json_decode($response, true);
 	$dataTrans = $data["data"];	




	function checkMOMO()
	{

	$dataPost = array(
				"access_token" => "Fcp1Nv1qFNLd2KAjpVKm4XQuneslxqpJZH2X8NuMYSEb7yyosZ", //token từ hệ thống
				"phone" => "0848550666" //số điện thoại Momo muốn lấy giao dịch
				
				);
	$curl = curl_init();
	curl_setopt_array($curl, array(
		CURLOPT_URL => "https://momosv3.apimienphi.com/api/getMomoInfo",
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_SSL_VERIFYPEER => false,
		CURLOPT_MAXREDIRS => 10,
		CURLOPT_TIMEOUT => 30,
		CURLOPT_CUSTOMREQUEST => "POST",
		CURLOPT_POSTFIELDS => json_encode($dataPost),
		CURLOPT_HTTPHEADER => array(
			"Content-Type: application/json",
			"accept: application/json",
			"cache-control: no-cache"
								),
		));

	$response = curl_exec($curl);
	curl_close($curl);
	//hiện kết quả
	$data = json_decode($response, true);
 	return $data["data"];	

	}


	$info = checkMOMO();
	

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
                    <span class="info-box-icon bg-success"><i class="	fa fa-credit-card"></i></span>
					
					<?php 
					
					echo 'Số dư hiện tại MOMO: ';
					echo number_format($info['balance']);
					?>
					


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
                                        <th>Thời gian</th>
                                        <th>Loại</th>
                                        <th>Số tiền</th>
                                        <th>Desc</th>
										<th>Comment</th>
               

                                    </tr>
                                </thead>
                                <tbody>
                                    <?php


                                  
                                    //print_r($data);
                                    foreach ($dataTrans as $list) {

                                    ?>

                                        <tr>
                                           
                                            <td><?php echo $list['id'] ?></td>
											<td><?php echo $list['clientTime'] ?></td>
											<td><?php echo $list['tranType'] ?></td>
                                        	<td><?php echo number_format($list['amount'])?></td>
											<td><?php echo $list['desc'] ?></td>
											<td><?php echo $list['comment'] ?></td>
  
  

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