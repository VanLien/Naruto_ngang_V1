<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');
$idcode = $_REQUEST['id'];
//if (!$idcode) movePage('index.php');

$data = $database->get("shopcode", [
	"code_name",
	"code_id",
	"content",
	"price",
	"status"
], [
	"code_id" => $idcode
]);


if ($_FILES) {
    //Checking if file is selected or not
    if ($_FILES['file']['name'] != "") {
  
      //Checking if the file is plain text or not
      if (isset($_FILES) && $_FILES['file']['type'] != 'text/plain') {
		$note = "Chỉ nhận file txt";
          exit();
      } 
     $note = "Cập nhật thành công";
      //Getting and storing the temporary file name of the uploaded file
      $fileName = $_FILES['file']['tmp_name'];
    
      //Throw an error message if the file could not be open
      $file = fopen($fileName,"r") or exit("Unable to open file!");
     
      // Reading a .txt file line by line
      while(!feof($file)) {
		
		$idcode = $_REQUEST['id'];
        $code = trim(fgets($file));
		$data = $database->insert("giftcode", [
			"code" => $code,
			"code_id" => $idcode
			]);
		if($data)
		{
			$note = "Cập nhật thành công";
		}else {

			$note = "Cập nhật code thất bại";
		}
      }
     

      fclose($file);
  } else {
      if (isset($_FILES) && $_FILES['file']['type'] == '')
	  $note = "Cập nhật code thất bại";
    }
}


?>
<!--  END NAVBAR  -->

<?php include('sidebar.php'); ?>

<!-- jQuery UI -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>

<link rel="stylesheet" href="plugins/select2/css/select2.min.css">
<link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
<link rel="stylesheet" href="plugins/select2/css/select2.min.css">
<link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/summernote/summernote-bs4.min.css">
<style>
	.list-group-item {
		position: relative;
		display: block;
		padding: .75rem 1.25rem;
		background-color: #dbedff;
		border: 1px solid rgba(0, 0, 0, .125);
	}

	.list-group-item-action {
		width: 100%;
		color: #ff0404;
		text-align: inherit;
	}

	li.list-group-item.primary.list-group-item-action:hover {
		/* color: black; */
		background-color: #17a2b8;
	}


	#cameraFileInput {
		display: none;
	}

	#pictureFromCamera {
		width: 50%;
		height: auto;
		margin-top: 16px;
	}

	.btn {
		display: inline-block;

		color: white;
		padding: 8px 12px;
		border-radius: 4px;
		font-size: 16px;
		cursor: pointer;
	}

	.btn:hover {
		filter: brightness(0.9);
	}

	button.managecoin {
		width: 120px;
	}
</style>


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<div class="content-header">

	</div>
	<!-- /.content-header -->

	<!-- Main content -->
	<section class="content">
		<div class="container-fluid">
			<!-- Small boxes (Stat box) -->


			<div class="row">
				<div class="col-8">
				<?php if($note)
						 { ?>
					<div class="alert alert-primary" role="alert">
					<?php echo $note;?>
					</div>
						<?php } ?>
					<div class="card card-primary">
						<div class="card-header">
							<h3 class="card-title">Thông tin Code</h3>
						</div>

							<?php $actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]"; ?>
							<form action="<?php echo $actual_link; ?>" method="post" enctype="multipart/form-data">
							<input type="file" name="file" size="60" />
				
												<!-- /.card-body -->

							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Thêm</button>
							</div>
						</form>


						<script>
		

							$("#addcode").submit(function(event) {
								var code = $('#code').val();
								var code_id = '<?php echo $idcode ?>';
								

								$.ajax({
									url: "ajax/add_code.php",
									method: 'POST',
									dataType: 'json',
									data: {
										code_id: code_id,
										code: code
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
												location.reload();
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
								});
								return false;
								event.preventDefault();
							});
						</script>
					</div>
				</div>


			</div>
			<!-- /.row (main row) -->
		</div><!-- /.container-fluid -->
	</section>
	<!-- /.content -->
</div>
<script src="plugins/inputmask/jquery.inputmask.min.js"></script>
<script src="plugins/select2/js/select2.full.min.js"></script>



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
<script src="plugins/summernote/summernote-bs4.min.js"></script>




<?php include('footer.php'); ?>