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

		<!-- /.card -->
</div>
</div>

<!-- /.row (main row) -->
</div><!-- /.container-fluid -->

<script>

function update_event() {
	var startDate = $('#startDate').val();
	var endDate = $('#endDate').val();
	var status = $('#status').val();
	var idEvent = $('#idEvent').val();
	var rate = $('#rate').val();
	$.ajax({
		url: "ajax/update_event_nap.php",
		method: 'POST',
		dataType: 'json',
		data: {
			startDate: startDate,
			endDate: endDate,
			rate: rate,
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
</script>


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