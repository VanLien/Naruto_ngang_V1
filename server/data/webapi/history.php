<?php include("header.php") ?>

<div class="row giftcodeparent">
    <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Lịch sử nạp</a></span>
    </h2>
    <table class="table table-bordered" style="width: 99%" id="topup">
        <thead>
            <tr>
                <th>Loại</th>
                <th>Tiền Nạp</th>
                <th>Xu Nhận</th>
                <th>Seri</th>
                <th>Trạng Thái</th>
                <th>Thời Gian</th>
            </tr>
        </thead>
    </table>
    <div class="clear10"></div>
    <h2 class="titlegcmxh clearfix">
        <span class="fll"><a>Lịch sử hoạt động</a></span>
    </h2>
    <table class="table table-bordered" style="width: 99%" id="active">
        <thead>
            <tr>
                <th>STT</th>
                <th>Hình Thức</th>
                <th>Nội Dung</th>
                <th>Thời Gian</th>
            </tr>
        </thead>
    </table>
    <script>
    $(function() {
        $('#topup').DataTable({
            processing: true,
            serverSide: true,
            scroller: true,
            autoWidth: true,
            language: {
                "lengthMenu": "_MENU_",
                "zeroRecords": "Không có dữ liệu",
                "info": "",
                "infoEmpty": "Không có dữ liệu",
                "infoFiltered": "(Lọc từ _MAX_ tổng số dòng)",
                "loadingRecords": "Đang tải...",
                "processing": "Đang tải...",
                "search": "",
                "paginate": {
                    "first": "Trang đầu",
                    "last": "Trang cuối",
                    "next": '<i class="fa fa-angle-double-right"></i>',
                    "previous": '<i class="fa fa-angle-double-left"></i>'
                },
            },
            ajax: '/ajax/history-topup.php',
            order: [
                [5, 'desc']
            ],
            dom: 'rtip',
            columns: [{
                    data: 'loaithe',
                    name: 'loaithe'
                },
                {
                    data: 'menhgia',
                    name: 'menhgia'
                },
                {
                    data: 'xu_receive',
                    name: 'xu_receive'
                },
                {
                    data: 'seri',
                    name: 'seri'
                },
                {
                    data: 'trangthai',
                    name: 'trangthai'
                },
                {
                    data: 'created_at',
                    name: 'created_at',
                }
            ]
        });

        $('#active').DataTable({
            processing: true,
            serverSide: true,
            scroller: true,
            autoWidth: true,
            language: {
                "lengthMenu": "_MENU_",
                "zeroRecords": "Không có dữ liệu",
                "info": "",
                "infoEmpty": "Không có dữ liệu",
                "infoFiltered": "(Lọc từ _MAX_ tổng số dòng)",
                "loadingRecords": "Đang tải...",
                "processing": "Đang tải...",
                "search": "",
                "paginate": {
                    "first": "Trang đầu",
                    "last": "Trang cuối",
                    "next": '<i class="fa fa-angle-double-right"></i>',
                    "previous": '<i class="fa fa-angle-double-left"></i>'
                },
            },
            ajax: '/ajax/history.php',
            order: [
                [3, 'desc']
            ],
            dom: 'rtip',
            columns: [{
                    data: 'id',
                    name: 'id',
                    "render": function(data, type, full, meta) {
                        return meta.row + 1;
                    }
                },
                {
                    data: 'type',
                    name: 'type'
                },
                {
                    data: 'Content',
                    name: 'Content'
                },
                {
                    data: 'timeDate',
                    name: 'timeDate'
                },
            ]
        });
    });
    </script>
</div>

<?php include("footer.php") ?>