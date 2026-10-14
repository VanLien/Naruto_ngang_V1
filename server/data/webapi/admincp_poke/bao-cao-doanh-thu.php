<?php
include('header.php');
if (!$_SESSION['username_admin']) movePage('index.php');

// Xử lý bộ lọc
$filter_type = isset($_GET['filter_type']) ? $_GET['filter_type'] : 'month';
$selected_year = isset($_GET['year']) ? $_GET['year'] : date('Y');
$selected_month = isset($_GET['month']) ? $_GET['month'] : date('m');
$selected_date = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');
$start_date_range = isset($_GET['start_date']) ? $_GET['start_date'] : date('Y-m-d');
$end_date_range = isset($_GET['end_date']) ? $_GET['end_date'] : date('Y-m-d');

// Lấy dữ liệu tổng quan
$data = $database->query("SELECT SUM(menhgia) as TongTien FROM card WHERE trangthai = '2'")->fetchAll();
$dataBank = $database->query("SELECT SUM(menhgia) as TongTienBank FROM card WHERE (`mathe` = 'Bank' OR `mathe` = 'Momo') AND trangthai = '2'")->fetchAll();

foreach ($dataBank as $bank) {
    $tongtienBank = $bank['TongTienBank'];
}

foreach ($data as $item) {
    $tongtien = $item['TongTien'];
}

$tongtienThe = $tongtien - $tongtienBank;

// Lấy dữ liệu theo bộ lọc
$where_clause = "WHERE trangthai = '2'";
if ($filter_type == 'date') {
    $start_date = $selected_date . " 00:00:00";
    $end_date = $selected_date . " 23:59:59";
    $where_clause .= " AND created_at BETWEEN '{$start_date}' AND '{$end_date}'";
} elseif ($filter_type == 'month') {
    $start_date = $selected_year . "-" . $selected_month . "-01 00:00:00";
    $end_date = $selected_year . "-" . $selected_month . "-" . date('t', strtotime($start_date)) . " 23:59:59";
    $where_clause .= " AND created_at BETWEEN '{$start_date}' AND '{$end_date}'";
} elseif ($filter_type == 'year') {
    $start_date = $selected_year . "-01-01 00:00:00";
    $end_date = $selected_year . "-12-31 23:59:59";
    $where_clause .= " AND created_at BETWEEN '{$start_date}' AND '{$end_date}'";
} elseif ($filter_type == 'range') {
    $start_date = $start_date_range . " 00:00:00";
    $end_date = $end_date_range . " 23:59:59";
    $where_clause .= " AND created_at BETWEEN '{$start_date}' AND '{$end_date}'";
}

$filtered_data = $database->query("SELECT SUM(menhgia) as TongTien FROM card {$where_clause}")->fetchAll();
$filtered_bank = $database->query("SELECT SUM(menhgia) as TongTienBank FROM card {$where_clause} AND (`mathe` = 'Bank' OR `mathe` = 'Momo')")->fetchAll();

$filtered_tongtien = 0;
$filtered_tongtienBank = 0;

foreach ($filtered_data as $item) {
    $filtered_tongtien = $item['TongTien'] ?: 0;
}

foreach ($filtered_bank as $bank) {
    $filtered_tongtienBank = $bank['TongTienBank'] ?: 0;
}

$filtered_tongtienThe = $filtered_tongtien - $filtered_tongtienBank;

// Lấy dữ liệu cho biểu đồ
$chart_data = [];
if ($filter_type == 'range') {
    // Biểu đồ theo ngày trong khoảng thời gian
    $start = new DateTime($start_date_range);
    $end = new DateTime($end_date_range);
    $interval = new DateInterval('P1D'); // 1 ngày
    $period = new DatePeriod($start, $interval, $end->modify('+1 day'));
    
    foreach ($period as $date) {
        $day_start = $date->format('Y-m-d') . " 00:00:00";
        $day_end = $date->format('Y-m-d') . " 23:59:59";
        
        $day_data = $database->query("SELECT SUM(menhgia) as TongTien FROM card WHERE trangthai = '2' AND created_at BETWEEN '{$day_start}' AND '{$day_end}'")->fetchAll();
        
        $day_total = 0;
        foreach ($day_data as $item) {
            $day_total = $item['TongTien'] ?: 0;
        }
        
        $chart_data[] = [
            'month' => $date->format('d/m'),
            'total' => $day_total
        ];
    }
} else {
    // Biểu đồ theo tháng trong năm
    for ($i = 1; $i <= 12; $i++) {
        $month_start = $selected_year . "-" . str_pad($i, 2, '0', STR_PAD_LEFT) . "-01 00:00:00";
        $month_end = $selected_year . "-" . str_pad($i, 2, '0', STR_PAD_LEFT) . "-" . date('t', strtotime($month_start)) . " 23:59:59";
        
        $month_data = $database->query("SELECT SUM(menhgia) as TongTien FROM card WHERE trangthai = '2' AND created_at BETWEEN '{$month_start}' AND '{$month_end}'")->fetchAll();
        
        $month_total = 0;
        foreach ($month_data as $item) {
            $month_total = $item['TongTien'] ?: 0;
        }
        
        $chart_data[] = [
            'month' => date('M', strtotime($month_start)),
            'total' => $month_total
        ];
    }
}

// Lấy dữ liệu chi tiết giao dịch
$detail_query = "SELECT * FROM card {$where_clause} ORDER BY created_at DESC";
$detail_data = $database->query($detail_query)->fetchAll();

// Lấy top user nạp nhiều nhất trong thời gian báo cáo
$top_users_query = "SELECT username, COUNT(*) as so_giao_dich, SUM(menhgia) as tong_nap 
                   FROM card {$where_clause} 
                   GROUP BY username 
                   ORDER BY tong_nap DESC 
                   LIMIT 10";
$top_users_data = $database->query($top_users_query)->fetchAll();
?>

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
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Báo Cáo Doanh Thu Chi Tiết</h1>
                </div>
            </div>
        </div>
    </div>

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            <!-- Bộ lọc -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Bộ Lọc Báo Cáo</h3>
                        </div>
                        <div class="card-body">
                            <form method="GET" action="">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Loại Báo Cáo:</label>
                                            <select name="filter_type" class="form-control" onchange="this.form.submit()">
                                                <option value="date" <?php echo $filter_type == 'date' ? 'selected' : ''; ?>>Theo Ngày</option>
                                                <option value="month" <?php echo $filter_type == 'month' ? 'selected' : ''; ?>>Theo Tháng</option>
                                                <option value="year" <?php echo $filter_type == 'year' ? 'selected' : ''; ?>>Theo Năm</option>
                                                <option value="range" <?php echo $filter_type == 'range' ? 'selected' : ''; ?>>Khoảng Thời Gian</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Năm:</label>
                                            <select name="year" class="form-control" onchange="this.form.submit()">
                                                <?php for ($year = date('Y'); $year >= 2020; $year--): ?>
                                                    <option value="<?php echo $year; ?>" <?php echo $selected_year == $year ? 'selected' : ''; ?>><?php echo $year; ?></option>
                                                <?php endfor; ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3" id="month_select" style="<?php echo $filter_type == 'month' ? '' : 'display:none;'; ?>">
                                        <div class="form-group">
                                            <label>Tháng:</label>
                                            <select name="month" class="form-control" onchange="this.form.submit()">
                                                <?php for ($month = 1; $month <= 12; $month++): ?>
                                                    <option value="<?php echo str_pad($month, 2, '0', STR_PAD_LEFT); ?>" <?php echo $selected_month == str_pad($month, 2, '0', STR_PAD_LEFT) ? 'selected' : ''; ?>><?php echo date('F', mktime(0, 0, 0, $month, 1)); ?></option>
                                                <?php endfor; ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3" id="date_select" style="<?php echo $filter_type == 'date' ? '' : 'display:none;'; ?>">
                                        <div class="form-group">
                                            <label>Ngày:</label>
                                            <input type="date" name="date" class="form-control" value="<?php echo $selected_date; ?>" onchange="this.form.submit()">
                                        </div>
                                    </div>
                                    <div class="col-md-3" id="start_date_select" style="<?php echo $filter_type == 'range' ? '' : 'display:none;'; ?>">
                                        <div class="form-group">
                                            <label>Từ Ngày:</label>
                                            <input type="date" name="start_date" class="form-control" value="<?php echo $start_date_range; ?>" onchange="this.form.submit()">
                                        </div>
                                    </div>
                                    <div class="col-md-3" id="end_date_select" style="<?php echo $filter_type == 'range' ? '' : 'display:none;'; ?>">
                                        <div class="form-group">
                                            <label>Đến Ngày:</label>
                                            <input type="date" name="end_date" class="form-control" value="<?php echo $end_date_range; ?>" onchange="this.form.submit()">
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thống kê tổng quan -->
            <div class="row">
                <div class="col-md-3 col-sm-6 col-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-info"><i class="fas fa-chart-line"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Tổng Doanh Thu</span>
                            <span class="info-box-number"><?php echo number_format($filtered_tongtien); ?> VNĐ</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6 col-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-success"><i class="fas fa-university"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Bank / Momo</span>
                            <span class="info-box-number"><?php echo number_format($filtered_tongtienBank); ?> VNĐ</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6 col-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-warning"><i class="fas fa-credit-card"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Thẻ Cào</span>
                            <span class="info-box-number"><?php echo number_format($filtered_tongtienThe); ?> VNĐ</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6 col-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-danger"><i class="fas fa-users"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Số Giao Dịch</span>
                            <span class="info-box-number"><?php echo count($detail_data); ?></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <?php 
                                if ($filter_type == 'range') {
                                    echo "Biểu Đồ Doanh Thu Từ " . date('d/m/Y', strtotime($start_date_range)) . " Đến " . date('d/m/Y', strtotime($end_date_range));
                                } else {
                                    echo "Biểu Đồ Doanh Thu Theo Tháng (" . $selected_year . ")";
                                }
                                ?>
                            </h3>
                        </div>
                        <div class="card-body">
                            <canvas id="revenueChart" style="height: 300px;"></canvas>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Bảng top user -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Top 10 User Nạp Nhiều Nhất</h3>
                        </div>
                        <div class="card-body">
                            <table id="topUsersTable" class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>Xếp Hạng</th>
                                        <th>Tên User</th>
                                        <th>Số Giao Dịch</th>
                                        <th>Tổng Nạp</th>
                                        <th>Trung Bình/Giao Dịch</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php 
                                    $rank = 1;
                                    foreach ($top_users_data as $user): 
                                        $trung_binh = $user['so_giao_dich'] > 0 ? round($user['tong_nap'] / $user['so_giao_dich']) : 0;
                                    ?>
                                        <tr>
                                            <td>
                                                <?php if ($rank <= 3): ?>
                                                    <span class="badge badge-<?php echo $rank == 1 ? 'warning' : ($rank == 2 ? 'secondary' : 'success'); ?>">
                                                        <?php echo $rank; ?>
                                                    </span>
                                                <?php else: ?>
                                                    <span class="badge badge-info"><?php echo $rank; ?></span>
                                                <?php endif; ?>
                                            </td>
                                            <td>
                                                <strong><?php echo htmlspecialchars($user['username']); ?></strong>
                                            </td>
                                            <td>
                                                <span class="badge badge-primary"><?php echo number_format($user['so_giao_dich']); ?></span>
                                            </td>
                                            <td>
                                                <strong class="text-success"><?php echo number_format($user['tong_nap']); ?> VNĐ</strong>
                                            </td>
                                            <td>
                                                <?php echo number_format($trung_binh); ?> VNĐ
                                            </td>
                                        </tr>
                                    <?php 
                                    $rank++;
                                    endforeach; 
                                    ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            
            <!-- Bảng chi tiết -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Chi Tiết Giao Dịch</h3>
                        </div>
                        <div class="card-body">
                            <table id="detailTable" class="table table-bordered table-striped">
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
                                        <th>Thời Gian</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($detail_data as $card): ?>
                                        <tr>
                                            <td><?php echo strtoupper($card['id']); ?></td>
                                            <td><?php echo $card['username']; ?></td>
                                            <td><?php echo number_format($card['menhgia']); ?></td>
                                            <td><?php echo $card['loaithe']; ?></td>
                                            <td><?php echo $card['seri']; ?></td>
                                            <td><?php echo $card['mathe']; ?></td>
                                            <td><?php echo $card['idgiaodich']; ?></td>
                                            <td>
                                                <?php
                                                switch ($card['trangthai']) {
                                                    case 4:
                                                        echo "<span class='badge badge-info'>Đang chờ xử lý</span>";
                                                        break;
                                                    case 3:
                                                        echo "<span class='badge badge-danger'>Thẻ sai</span>";
                                                        break;
                                                    case 2:
                                                        echo "<span class='badge badge-success'>Đã duyệt</span>";
                                                        break;
                                                }
                                                ?>
                                            </td>
                                            <td><?php echo date('d/m/Y H:i:s', strtotime($card['created_at'])); ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script src="plugins/select2/js/select2.full.min.js"></script>
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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
$(function() {
    // Khởi tạo DataTable cho bảng chi tiết
    $("#detailTable").DataTable({
        "responsive": true,
        "lengthChange": false,
        "autoWidth": false,
        "buttons": ["copy", "csv", "excel", "pdf", "print", "colvis"],
        "order": [[8, "desc"]]
    }).buttons().container().appendTo('#detailTable_wrapper .col-md-6:eq(0)');

    // Khởi tạo DataTable cho bảng top user
    $("#topUsersTable").DataTable({
        "responsive": true,
        "lengthChange": false,
        "autoWidth": false,
        "buttons": ["copy", "csv", "excel", "pdf", "print"],
        "order": [[0, "asc"]], // Sắp xếp theo tổng nạp giảm dần
        "pageLength": 10,
        "paging": false, // Không phân trang vì chỉ có 10 user
        "info": false, // Ẩn thông tin phân trang
        "searching": false // Ẩn tìm kiếm
    }).buttons().container().appendTo('#topUsersTable_wrapper .col-md-6:eq(0)');

    // Xử lý hiển thị/ẩn bộ lọc
    $('select[name="filter_type"]').change(function() {
        var filterType = $(this).val();
        if (filterType == 'month') {
            $('#month_select').show();
            $('#date_select').hide();
            $('#start_date_select').hide();
            $('#end_date_select').hide();
        } else if (filterType == 'date') {
            $('#month_select').hide();
            $('#date_select').show();
            $('#start_date_select').hide();
            $('#end_date_select').hide();
        } else if (filterType == 'range') {
            $('#month_select').hide();
            $('#date_select').hide();
            $('#start_date_select').show();
            $('#end_date_select').show();
        } else {
            $('#month_select').hide();
            $('#date_select').hide();
            $('#start_date_select').hide();
            $('#end_date_select').hide();
        }
    });

    // Biểu đồ doanh thu
    var ctx = document.getElementById('revenueChart').getContext('2d');
    var chartData = <?php echo json_encode($chart_data); ?>;
    
    var revenueChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartData.map(item => item.month),
            datasets: [{
                label: 'Doanh Thu (VNĐ)',
                data: chartData.map(item => item.total),
                backgroundColor: 'rgba(54, 162, 235, 0.8)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('vi-VN').format(value) + ' VNĐ';
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Doanh Thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' VNĐ';
                        }
                    }
                }
            }
        }
    });
});
</script>

<?php include('footer.php'); ?> 