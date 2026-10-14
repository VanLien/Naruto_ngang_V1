<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');	
$data = $database->query("SELECT COUNT(username) as TongUSer  FROM account")->fetchAll();
foreach ($data as $item)
{
	$TongUSer =  $item['TongUSer'];
}
$today = date("Y-m-d 00:00:00");
$endtoday = date("Y-m-d 23:59:59");
$getCurrentDate = $database->query("SELECT count(*)  as Homnay FROM account WHERE regDate BETWEEN '{$today}'  AND '{$endtoday}'  ")->fetchAll();
foreach ($getCurrentDate as $datas)
{
	$todayreg = $datas['Homnay'];
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
              <span class="info-box-icon bg-warning"><i class="far fa-user"></i></span>

              <div class="info-box-content">
                <span class="info-box-text">Tổng thành viên</span>
                <span class="info-box-number"> <?php echo number_format($TongUSer); ?> Tổng  User</span>
              </div>
            </div>
			</div>



			
			<div class="col-md-3 col-sm-6 col-12">
			<div class="info-box">
              <span class="info-box-icon bg-warning"><i class="far fa-user"></i></span>
			<div class="info-box-content">
                <span class="info-box-text">Tổng thành viên đăng ký hôm nay <?php echo date("Y-m-d"); ?></span>
                <span class="info-box-number"> <?php echo number_format($todayreg); ?>  User</span>
              </div>
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
							<h3 class="card-title">Danh thành viên</h3>
						</div>
						<!-- /.card-header -->
						<div class="card-body">
							<table id="example1" class="table table-bordered table-striped">
								<thead>
									<tr>
										<th>ID</th>
										<th>Account</th>
										<th>Pass1</th>
										<th>Pass2</th>
										<th>Email</th>
										<th>SDT</th>
										<th>regDate</th>
										<th>Xu</th>
										<th>AccID</th>
										<th>Action</th>
										
									</tr>
								</thead>
								<tbody>
									<?php 
								
							
								$data = $database->query("SELECT *  
FROM account
")->fetchAll();

								foreach($data as $user) {
									
							?>
								
										<tr>
										<td><?php echo $user['id'] ?></td>
											<td><?php echo $user['username'] ?></td>
											<td><?php echo $user['password'] ?></td>
											<td><?php echo $user['pass2'] ?></td>
											<td><?php echo $user['email'] ?></td>
											<td><?php echo $user['phone'] ?></td>
											<td><?php echo $user['regDate'] ?></td>
                                            <td><?php echo number_format($user['xu']) ?></td>
											<td><?php echo $user['account_id'] ?></td>
								
												<td>
													<div class="btn-group">
														<a href="javascript:void(0);" onclick="banaccount('<?php echo $user['name']?>');"><button type="button" class="btn btn-block btn-danger">Xóa</button> </a>
														<a href="edit_user.php?id=<?php echo $user['username']?>"><button type="button" class="btn btn-block btn-warning">Sửa</button> </a>
													
													
														</td>
													</tr>
													
												<?php } ?>    
										</tfoot>
									</table>
								</div>
								
<script>
				
			
			function banaccount(id) {
				var id = id;	
				swal({
					title: 'Bạn có chắc?',
					text: "Xóa tài khoản ?",
					type: 'warning',
					showCancelButton: true,
					confirmButtonText: 'OK',
					padding: '2em'
					}).then(function(result) {
					if (result.value) {
						$.ajax({					
							url: "ajax/banacc.php",
							method: 'POST',
							dataType: 'json',
							data: {
								id: id,
								username: "<?php echo $_SESSION['username']?>",
								
							},
							success: function (resp) {
								if(resp.type == 0){
									
									swal({
										title: 'Success',
										text: resp.msg,
										type: 'success',
										padding: '2em'
									})
									
									window.setTimeout(function(){
										window.location.reload();
									}, 1000);
									}else{
									
									
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
			
			
			
						function unbanaccount(id) {
				var id = id;	
				swal({
					title: 'Bạn có chắc?',
					text: "UnBan acc ?",
					type: 'warning',
					showCancelButton: true,
					confirmButtonText: 'OK',
					padding: '2em'
					}).then(function(result) {
					if (result.value) {
						$.ajax({					
							url: "ajax/unbanacc.php",
							method: 'POST',
							dataType: 'json',
							data: {
								id: id,
								username: "<?php echo $_SESSION['username']?>",
							},
							success: function (resp) {
								if(resp.type == 0){
									
									swal({
										title: 'Success',
										text: resp.msg,
										type: 'success',
										padding: '2em'
									})
									
									window.setTimeout(function(){
										window.location.reload();
									}, 1000);
									}else{
									
									
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
			$(function () {
				$("#example1").DataTable({
					"responsive": true, "lengthChange": false, "autoWidth": false,
					"buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"]
				}).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');
				
			});
		</script>
		
		
<?php include('footer.php'); ?>																																				