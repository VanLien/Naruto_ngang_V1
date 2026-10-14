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

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<div class="content-header">
		<div class="row">

			<div class="col-3">
				<a href="add-new-pack_tich_luy.php"><button type="button" class="btn btn-block btn-danger btn-lg">Thêm Gói Tích Lũy</button></a>
			</div>
			<div class="col-3">
				<button type="button"  class="btn btn-block btn-danger btn-lg" onclick="reset_event()">Reset Event</button>
			</div>
		</div>
	</div>
	<!-- /.content-header -->

	<!-- Main content -->
	<section class="content">
		<div class="container-fluid">
			<!-- Small boxes (Stat box) -->


			<div class="row">
				<div class="col-6">
			
				</div>

				<script>
					function del_event(id) {
						var id = id;
						swal({
							title: 'Bạn có chắc?',
							text: "Xóa Event?",
							type: 'warning',
							showCancelButton: true,
							confirmButtonText: 'OK',
							padding: '2em'
						}).then(function(result) {
							if (result.value) {
								$.ajax({
									url: "ajax/del_event_tichluy.php",
									method: 'POST',
									dataType: 'json',
									data: {
										id: id,
										username: "<?php echo $_SESSION['username'] ?>"

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
				</script>
				<!-- /.card-body -->
<div class="col-12">
<div class="card">
			<div class="card-header">
				<h3 class="card-title">Quản lý Gói Nạp Tích Lũy</h3>
			</div>
			<!-- /.card-header -->
			<div class="card-body">
				<table id="example1" class="table table-bordered table-striped">
					<thead>
						<tr>
							<th>Tên</th>
							<th>Giá</th>
							<th>Content</th>
							<th>ID CODE</th>
							<th>Action</th>

						</tr>
					</thead>
					<tbody>
						<?php
						$data = $database->query("SELECT  * FROM event_tichluy_pack ORDER BY price ASC")->fetchAll();
						//print_r($data);
						foreach ($data as $gift) {

						?>

							<tr>

								<td>
									<font color="red"><strong><a href="edit_pack.php?id=<?php echo $gift['id'] ?>"><?php echo $gift['name'] ?></a></font></strong>
								</td>
								<td><?php echo number_format($gift['price'] )?></td>
								<td><?php echo $gift['content'] ?></td>
								<td><?php echo $gift['id_code'] ?></td>


								<td>
									<div class="btn-group">

										<a href="#" onclick="del_pack('<?php echo $gift['id'] ?>');"><button type="button" class="btn btn-block btn-danger">Xóa</button> </a>
										<a href="edit_pack.php?id=<?php echo $gift['id'] ?>"><button type="button" class="btn btn-block btn-success">Sửa</button> </a>
								</td>
							</tr>

						<?php } ?>
						</tfoot>
				</table>
			</div>

			<script>
				function del_pack(id) {
					var id = id;
					swal({
						title: 'Bạn có chắc?',
						text: "Xóa Gói này?",
						type: 'warning',
						showCancelButton: true,
						confirmButtonText: 'OK',
						padding: '2em'
					}).then(function(result) {
						if (result.value) {
							$.ajax({
								url: "ajax/del_pack_tichluy.php",
								method: 'POST',
								dataType: 'json',
								data: {
									id: id,
									username: "<?php echo $_SESSION['username'] ?>"

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

				function update_event() {
					var startDate = $('#startDate').val();
					var endDate = $('#endDate').val();
					var status = $('#status').val();
					var idEvent = $('#idEvent').val();
					$.ajax({
						url: "ajax/update_event_tichluy.php",
						method: 'POST',
						dataType: 'json',
						data: {
							startDate: startDate,
							endDate: endDate,
							idEvent: idEvent,
							status: status,
							username: "<?php echo $_SESSION['username'] ?>"

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
							}}
						})
					}


					function reset_event(){
								var id = $('#id').val();
								swal({
									title: 'Chắc chắn?',
									text: 'Chắc chắn xóa toàn bộ dữ liệu Log sự kiện tích lũy ?',
									icon: 'warning',
									buttons: true,
									dangerMode: true,
								}).then((willDelete) => {
									if (willDelete) {
										$.ajax({
											url: "ajax/reset_event_tichluy.php",
											method: 'POST',
											dataType: 'json',
											data: {id: id},
											success: function(resp){
											if(resp.type == 0){
												swal({
													title: 'Success',
													text: resp.msg,
													type: 'success',
													padding: '2em'
												})
												//reload code list
												
											}else{
												swal({
													title: 'Error',
													text: resp.msg,
													type: 'error',
													padding: '2em'
												})
											}
											}
										});
									}
								});
							}
				
			</script>
			</script>
			<!-- /.card-body -->
		</div>
			</div>
		</div>
		<!-- /.card -->
</div>
</div>

<!-- /.row (main row) -->
</div><!-- /.container-fluid -->




<div class="row">
	<div class="col-12">

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
			"responsive": true,
			"pageLength": 20,
			"order": [
				[1, "asc"]
			],
			"lengthChange": false,
			"autoWidth": false,
			"buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"]
		}).buttons().container().appendTo('#example1_wrapper .col-md-6:eq(0)');

	});

</script>


<?php include('footer.php'); ?>