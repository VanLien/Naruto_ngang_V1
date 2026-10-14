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
                            <h3 class="card-title">Quản lý dữ liệu Gacha & Thống kê</h3>
                        </div>
                        <div class="card-body">
                            
                            <div class="row">
                                <div class="col-12">
                                 <?php $songuoithamgia = $database->query("SELECT COUNT(DISTINCT username) FROM event_gacha")->fetchColumn();?>
                                 <h3>Số người tham gia: <?php echo $songuoithamgia; ?></h3>

                                 Bảng xếp hạng TOP 10
                                 <div class="table-responsive">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>Tên</th>
                                                <th>Điểm</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                           // Lấy danh sách top từ gacha log
$getData = $database->query("SELECT username, sum(point) as pointTotal FROM event_gacha_log GROUP BY username ORDER BY pointTotal DESC LIMIT 10")->fetchAll(PDO::FETCH_ASSOC);

                                            foreach ($getData as $row) {
                                                echo "<tr>";
                                                echo "<td>" . $row['username'] . "</td>";
                                                echo "<td>" . $row['pointTotal'] . "</td>";
                                                echo "</tr>";
                                            }
                                            ?>
                                        </tbody>
                                    </table>
                                 </div>

                                 



          
                                  <button class="btn btn-danger" onclick="resetData()">Reset Data</button>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
				
				<div class="col-3">
					<div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Thêm Gói Điểm Gacha</h3>
                        </div>

                        <div class="card-body">
                            <select name="rank" id="rank" class="form-control">
                                <?php 
                                $rank = getConfig("rankGacha"); 
                                ?>
                                <option value="1" <?php if($rank == 1) echo "selected"; ?>>Mở BXH</option>
                                <option value="0" <?php if($rank == 0) echo "selected"; ?>>Tắt BXH</option>
                            </select>
                        </div>

                        <div class="card-body">
                            <form id="add_pack" method="post" action="">
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Tên Gói</label>
                                    <input type="text" class="form-control" id="name" placeholder="">
                                </div>
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Giá Gói</label>
                                    <input type="number" class="form-control" id="price" placeholder="">
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary">Thêm Gói</button>
                            </form>
                        </div>
                    </div>
					</div>
				</div>
			
            <div class="col-9">
				<div class="card">
					<div class="card-header">
					<h3 class="card-title">Thể lệ</h3>
					</div>
					<div class="card-body">
						<textarea class="form-control" id="rule" placeholder=""><?php
                        $rule = file_get_contents('../../gameGacha/rule.txt');
                        echo $rule;
                        ?></textarea>
						<button type="button" class="btn btn-primary" onclick="update_rule()">Cập nhật</button>
					</div>

				</div>
            </div>
			</div>



            <div class="row">
                <!-- /.card-body -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Quản lý Gói Điểm Gacha</h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <table id="example1" class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>Tên</th>
                                        <th>Giá</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
						$data = $database->query("SELECT  * FROM event_gacha_box ORDER BY boxPrice ASC")->fetchAll();
						//print_r($data);
						foreach ($data as $gift) {
						?>
                                    <tr>
                                        <td>
                                            <font color="red"><strong><a
                                                        href="edit_event_gacha.php?id=<?php echo $gift['id'] ?>"><?php echo $gift['boxName'] ?></a>
                                            </font></strong>
                                        </td>
                                        <td><?php echo number_format($gift['boxPrice'] )?></td>
                                        <td>
                                            <div class="btn-group">

                                                <a href="#" onclick="del_event('<?php echo $gift['id'] ?>');"><button
                                                        type="button" class="btn btn-block btn-danger">Xóa</button> </a>
                                                <a href="edit_event_gacha.php?id=<?php echo $gift['id'] ?>"><button
                                                        type="button" class="btn btn-block btn-success">Sửa</button>
                                                </a>
                                        </td>
                                    </tr>

                                    <?php } ?>
                                    </tfoot>
                            </table>
                        </div>


                        <!-- /.card-body -->
                    </div>
                </div>
            </div>
            <!-- /.card -->


        </div>
    </section>
</div>

<!-- /.row (main row) -->
</div><!-- /.container-fluid -->





<script>
    $(document).ready(function() {
        $('#rank').change(function() {
            update_rank();
        });
    });

    function update_rank() {
        var rank = $('#rank').val();
        $.ajax({
            url: "ajax/update_rank_gacha.php",
            method: 'POST',
            data: {
                rank: rank
            },
            dataType: 'json',
            success: function(resp) {
                if (resp) {
                    swal({
                        title: 'Success',
                        text: resp.msg,
                        type: 'success',
                        padding: '2em'
                    })  
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
    }

    function resetData() {
        swal({
            title: 'Bạn có chắc?',
            text: "Xóa dữ liệu Gacha?",
            type: 'warning',
            showCancelButton: true,
        }).then(function(result) {  
            if (result.value) {
                $.ajax({
                    url: "ajax/reset_gacha_data.php",
                    method: 'POST',
                    dataType: 'json',
                    data: {
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
                        }   
                    }
                })
            }
        })
    }
    
	function update_rule() {
		var rule = $('#rule').summernote('code'); // Lấy nội dung HTML từ Summernote
		
		// Debug: Log độ dài nội dung
		console.log("Content length: " + rule.length);
		console.log("Content preview: " + rule.substring(0, 100) + "...");
		
		// Kiểm tra nội dung
		if(!rule || rule.trim() === '') {
			swal({
				title: 'Error',
				text: 'Vui lòng nhập nội dung thể lệ',
				type: 'error',
				padding: '2em'
			});
			return;
		}
		
		$.ajax({
			url: "ajax/update_gacha_rule.php",
			method: 'POST',
			dataType: 'json',
			data: {
				rule: rule,
				username: "<?php echo $_SESSION['username_admin'] ?>"
			},
			success: function(resp) {
				if (resp.type == 0) {
					swal({
						title: 'Success',
						text: resp.msg,
						type: 'success',
						padding: '2em'
					})
				} else {
					swal({
						title: 'Error',
						text: resp.msg,
						type: 'error',
						padding: '2em'
					})
				}
			},
			error: function(xhr, status, error) {
				console.error("AJAX Error:", error);
				swal({
					title: 'Error',
					text: 'Lỗi kết nối: ' + error,
					type: 'error',
					padding: '2em'
				});
			}
		})
	}

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
$("#add_pack").submit(function(event) {
    var price = $('#price').val();
    var name = $('#name').val();
    $.ajax({
        url: "ajax/add_event_gacha.php",
        method: 'POST',
        dataType: 'json',
        data: {
            price: price,
            name: name,

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

function del_event(id) {
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
                url: "ajax/del_event_gacha.php",
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
            }
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