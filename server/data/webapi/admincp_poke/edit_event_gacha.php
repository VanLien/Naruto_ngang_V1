<?php
	include('header.php');
	if (!$_SESSION['username_admin'] || $_REQUEST['id'] == null) movePage('index.php');
	
	
	      $id =  $_REQUEST['id'];
		// get info GiftPack
		$GetGiftInfo = $database->get("event_gacha_box", [
		"id",
		"boxName",
		"boxPrice"
        ], [
        "id" => $id 
        ],
        [
        "ORDER" => "event_gacha_box.id"
        ]);
		// end getgift info
	//var_dump($data);
	?>
<!--  END NAVBAR  -->

<?php include('sidebar.php'); ?>

<!-- jQuery UI -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script> 

<!-- jQuery UI CSS and JS for autocomplete -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="plugins/select2/css/select2.min.css">
<link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
<link rel="stylesheet" href="plugins/select2/css/select2.min.css">
<link rel="stylesheet" href="plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
<link rel="stylesheet" href="plugins/summernote/summernote-bs4.min.css">
<link rel="stylesheet" href="plugins/codemirror/codemirror.css">
<link rel="stylesheet" href="plugins/codemirror/theme/monokai.css">
<!-- SimpleMDE -->
<link rel="stylesheet" href="plugins/simplemde/simplemde.min.css">

<style>
	
	.list-group-item {
    position: relative;
    display: block;
    padding: .75rem 1.25rem;
    background-color: #dbedff;
    border: 1px solid rgba(0,0,0,.125);
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
	background-color: #00b531;
	color: white;
	padding: 8px 12px;
	border-radius: 4px;
	font-size: 16px;
	cursor: pointer;
	}
	
	.btn:hover {
	filter: brightness(0.9);
	}
	
	/* Autocomplete styling */
	.ui-autocomplete {
		background-color: #fff;
		border: 1px solid #ccc;
		border-radius: 4px;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		max-height: 200px;
		overflow-y: auto;
		z-index: 1000;
	}
	
	.ui-autocomplete .ui-menu-item {
		padding: 8px 12px;
		border-bottom: 1px solid #eee;
		cursor: pointer;
	}
	
	.ui-autocomplete .ui-menu-item:hover {
		background-color: #f8f9fa;
	}
	
	.ui-autocomplete .ui-menu-item.ui-state-focus {
		background-color: #007bff;
		color: white;
	}
	
	.item-preview {
		margin-top: 10px;
		display: none;
	}
	
	.item-preview img {
		max-width: 50px;
		max-height: 50px;
		border: 1px solid #ddd;
		border-radius: 4px;
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
				<div class="col-12">
					<div class="card card-primary">
						<div class="card-header">
							<h3 class="card-title">Sửa Gói Điểm Gacha</h3>
						</div>
						
			
							<div class="card-body">

								<div class="form-group">
									<label for="exampleInputEmail1">Tên Gói</label>
									<input type="text" class="form-control" id="name" value="<?php echo $GetGiftInfo['boxName']?>"  placeholder="">
								</div>

									
								<div class="form-group">
									<label for="exampleInputEmail1">Giá Gói</label>
									<input type="text" class="form-control" id="price" value="<?php echo $GetGiftInfo['boxPrice']?>"  placeholder="">
								</div>
								

								<div class="form-group">
									<label for="exampleInputEmail1">Danh sách Item</label>
									<div id="itemList">

									<?php
									$box = $GetGiftInfo['boxPrice'];
									$getIDCodeList = $database->query("SELECT id,itemName,itemImage,itemNum from event_gacha_item where box = $box")->fetchAll();
									foreach ($getIDCodeList as $item) {
										//list item ul with image
										echo "<ul>";
										echo "<li><img src='".$item['itemImage']."' alt='".$item['itemName']."' width='50' height='50'>".$item['itemName']." x ".$item['itemNum']." - <a href='javascript:void(0)' onclick='deleteItem(".$item['id'].")'>Xóa</a> </li> ";
										echo "</ul>";
									}
									?>
									</div>
								</div>
								<!-- 
								add item 
								autocomplete item name images from json item.json								
								-->
								<div class="form-group" style="display: flex; gap: 10px;">
									<label for="exampleInputEmail1">Thêm Item</label>
									<input type="text" class="form-control" id="itemName" placeholder="Tên Item" autocomplete="off" style="width: 300px;">
									<input type="text" class="form-control" id="itemImage" placeholder="Hình ảnh" autocomplete="off" style="width: 300px;">
									<input type="text" class="form-control" id="itemNum" placeholder="Số lượng" autocomplete="off" style="width: 300px;">
									<input type="text" hidden class="form-control" id="box" value="<?php echo $box?>">
									<button class="btn btn-primary " id="addItem">Thêm</button>
								</div>
								
								<div class="item-preview" id="itemPreview">
									<strong>Ảnh:</strong> <img id="previewImage" src="" alt="Preview">
								</div>

								<script>
									$(document).ready(function() {
										// Load item data for autocomplete
										var itemData = [];
										
										$.getJSON('item.json', function(data) {
											// Convert data to jQuery UI autocomplete format
											itemData = data.map(function(item) {
												return {
													label: item.label,
													value: item.value
												};
											});
											
											// Initialize autocomplete
											$('#itemName').autocomplete({
												source: function(request, response) {
													var term = request.term.toLowerCase();
													var matches = itemData.filter(function(item) {
														return item.label.toLowerCase().indexOf(term) !== -1;
													});
													response(matches);
												},
												minLength: 1,
												select: function(event, ui) {
													// Auto-fill the image URL when item is selected
													$('#itemImage').val(ui.item.value);
													$('#itemName').val(ui.item.label);

													
													// Show preview with correct path
													var imagePath = '/images/' + ui.item.value;
													$('#previewImage').attr('src', imagePath);
													$('#itemPreview').show();
													
													return false; // Prevent default behavior
												}
											});
										}).fail(function(jqXHR, textStatus, errorThrown) {
											console.error('Error loading item data:', textStatus, errorThrown);
										});
										
										// Clear preview when input is cleared
										$('#itemName').on('input', function() {
											if ($(this).val() === '') {
												$('#itemImage').val('');
												$('#itemPreview').hide();
											}
										});
									});
								</script>


							<!-- Nhập code -->
							<div class="form-group">
								<?php
								$countCode = $database->count("event_gacha_boxcode", [
									"box" => $box
								]);
								$countUsed = $database->count("event_gacha_boxcode", [
									"box" => $box,
									"status" => 1
								]);
								?>
								<label for="exampleInputEmail1">Nhập Code ( Đang có <?php echo $countCode?>  code, đã sử dụng <?php echo $countUsed?> code)</label>
								<textarea type="text" cols="30" rows="10" class="form-control" id="code" placeholder="Nhập danh sách code ( mỗi dòng 1 code)"></textarea>
								<input type="text" hidden class="form-control" id="box" value="<?php echo $box?>">
								<button class="btn btn-primary " style="margin-top: 10px;" id="addCode">Nhập Code</button>
								<button class="btn bg-danger " style="margin-top: 10px;" id="deleteCode">Xóa toàn bộ code </button>
							</div>

									
							
								
							</div>
							<!-- /.card-body -->

						<script>
							//delete code
							$('#deleteCode').click(function(){
								var box = $('#box').val();
								swal({
									title: 'Are you sure?',
									text: 'Are you sure you want to delete all codes?',
									icon: 'warning',
									buttons: true,
									dangerMode: true,
								}).then((willDelete) => {
									if (willDelete) {
										$.ajax({
											url: "ajax/delete_event_gacha_code.php",
											method: 'POST',
											dataType: 'json',
											data: {box: box},
											success: function(resp){
											if(resp.type == 0){
												swal({
													title: 'Success',
													text: resp.msg,
													type: 'success',
													padding: '2em'
												})
												//reload code list
												$('#codeList').load(location.href + ' #codeList');
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
							});
							

							//add code
							$('#addCode').click(function(){
								var code = $('#code').val();
								var box = $('#box').val();
								$.ajax({
									url: "ajax/add_event_gacha_code.php",
									method: 'POST',
									dataType: 'json',
									data: {code: code, box: box},
									success: function(resp){
										if(resp.type == 0){
											swal({
												title: 'Success',
												text: resp.msg,
												type: 'success',
												padding: '2em'
											})
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
							});

							
							//delete item
							function deleteItem(id){
								$.ajax({
									url: "ajax/delete_event_gacha_item.php",
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
											//reload item list
											$('#itemList').load(location.href + ' #itemList');
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

							//add item
							$('#addItem').click(function(){
								var itemName = $('#itemName').val();
								var itemImage = $('#itemImage').val();
								var itemNum = $('#itemNum').val();
								var box = $('#box').val();

								$.ajax({
									url: "ajax/add_event_gacha_item.php",
									method: 'POST',
									dataType: 'json',
									data: {itemName: itemName, itemImage: itemImage, itemNum: itemNum, box: box},
									success: function(resp){
										if(resp.type == 0){
											swal({
												title: 'Success',
												text: resp.msg,
												type: 'success',
												padding: '2em'
											})
											//reload item list
										$('#itemList').load(location.href + ' #itemList');
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
<!-- CodeMirror -->
<script src="plugins/codemirror/codemirror.js"></script>
<script src="plugins/codemirror/mode/css/css.js"></script>
<script src="plugins/codemirror/mode/xml/xml.js"></script>
<script src="plugins/codemirror/mode/htmlmixed/htmlmixed.js"></script>




<?php include('footer.php'); ?>																																									