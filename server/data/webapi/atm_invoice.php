<?php include("header.php");
    require_once('config/bank_config.php');
    
    // Lấy user data
    $userData = $database->get("account", ["id", "username", "xu"], ["username" => $username]);
    
    // Kiểm tra có hóa đơn pending không
    $pendingInvoice = $database->get("invoice", "*", [
        "AND" => [
            "username" => $username,
            "status" => 0,
            "expired_at[>]" => date("Y-m-d H:i:s")
        ]
    ]);
?>

<style>
.invoice-box { background: #fff; border-radius: 10px; padding: 20px; margin: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
.amount-options { display: flex; flex-wrap: wrap; gap: 10px; margin: 15px 0; }
.amount-btn { padding: 12px 20px; border: 2px solid #ddd; border-radius: 8px; background: #fff; cursor: pointer; transition: all 0.3s; font-weight: bold; }
.amount-btn:hover, .amount-btn.active { border-color: #fa5b36; background: #fff5f3; color: #fa5b36; }
.qr-section { text-align: center; padding: 20px; }
.qr-section img { max-width: 250px; border-radius: 10px; }
.bank-info { background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 10px 0; }
.bank-info-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dashed #ddd; }
.bank-info-row:last-child { border-bottom: none; }
.copy-btn { background: #fa5b36; color: #fff; border: none; padding: 5px 15px; border-radius: 5px; cursor: pointer; font-size: 12px; }
.copy-btn:hover { background: #e04a28; }
.status-badge { padding: 5px 15px; border-radius: 20px; font-weight: bold; display: inline-block; }
.status-pending { background: #fff3cd; color: #856404; }
.status-success { background: #d4edda; color: #155724; }
.status-cancelled { background: #f8d7da; color: #721c24; }
.countdown { font-size: 24px; font-weight: bold; color: #fa5b36; }
.preview-xu { background: linear-gradient(135deg, #fa5b36, #ff8c69); color: #fff; padding: 15px; border-radius: 10px; text-align: center; margin: 15px 0; }
.preview-xu .xu-amount { font-size: 28px; font-weight: bold; }
.preview-xu-box { display: none; }
.input-amount-wrapper { position: relative; }
.input-amount-wrapper input { padding-right: 50px; }
.input-amount-wrapper .currency { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #666; }
.invoice-warning { background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; padding: 15px; margin: 15px 0; }
.invoice-warning ul { margin: 10px 0 0 0 !important; padding-left: 20px !important; list-style-type: disc !important; }
.invoice-warning ul li { display: list-item !important; margin-bottom: 8px; line-height: 1.6; }
.invoice-warning code { background: #fff; padding: 2px 8px; border-radius: 4px; color: #d63384; font-weight: bold; }
#btnPreviewXu { background: linear-gradient(135deg, #fa5b36, #ff8c69); border: none; color: #fff; font-size: 16px; }
#btnPreviewXu:hover { background: linear-gradient(135deg, #e04a28, #fa5b36); }
</style>

<div class="row giftcodeparent">
    <?php if ($pendingInvoice): ?>
    <!-- HIỂN THỊ HÓA ĐƠN ĐANG CHỜ THANH TOÁN -->
    <div class="invoice-box" id="invoiceDetail">
        <h2 class="titlegcmxh clearfix">
            <span class="fll"><i class="fa fa-file-text"></i> Hóa Đơn Nạp Tiền</span>
        </h2>
        
        <div style="text-align: center; margin: 20px 0;">
            <span class="status-badge status-pending" id="statusBadge">
                <i class="fa fa-clock-o"></i> Đang xử lý
            </span>
            <div style="margin-top: 15px;">
                <span>Thời gian còn lại: </span>
                <span class="countdown" id="countdown">--:--</span>
            </div>
        </div>

        <div class="row">
            <div class="col-md-5 qr-section">
                <?php
                $trans_code = $pendingInvoice['invoice_code'];
                $amount = $pendingInvoice['amount'];
                $qrUrl = "https://img.vietqr.io/image/{$bank_code_id}-{$bank_code_stk}-compact.png?amount={$amount}&addInfo={$trans_code}&accountName=" . urlencode($bank_code_ctk);
                ?>
                <img src="<?php echo $qrUrl; ?>" alt="QR Code" id="qrImage">
                <p style="margin-top: 10px; color: #666;">Quét mã QR để thanh toán</p>
                <button class="btn btn-primary" onclick="downloadQR()" style="margin-top: 10px;">
                    <i class="fa fa-download"></i> Tải QR Code
                </button>
            </div>
            
            <div class="col-md-7">
                <div class="bank-info">
                    <h4><i class="fa fa-university"></i> Thông tin chuyển khoản</h4>
                    
                    <div class="bank-info-row">
                        <span>Ngân hàng:</span>
                        <span><strong id="bankName"><?php echo $bank_code_name; ?></strong></span>
                    </div>
                    
                    <div class="bank-info-row">
                        <span>Số tài khoản:</span>
                        <span>
                            <strong id="bankAccount"><?php echo $bank_code_stk; ?></strong>
                            <button class="copy-btn" onclick="copyText('<?php echo $bank_code_stk; ?>')"><i class="fa fa-copy"></i></button>
                        </span>
                    </div>
                    
                    <div class="bank-info-row">
                        <span>Chủ tài khoản:</span>
                        <span><strong><?php echo $bank_code_ctk; ?></strong></span>
                    </div>
                    
                    <div class="bank-info-row">
                        <span>Số tiền:</span>
                        <span>
                            <strong style="color: #fa5b36;" id="invoiceAmount"><?php echo number_format($pendingInvoice['amount']); ?>đ</strong>
                            <button class="copy-btn" onclick="copyText('<?php echo $pendingInvoice['amount']; ?>')"><i class="fa fa-copy"></i></button>
                        </span>
                    </div>
                    
                    <div class="bank-info-row" style="background: #fff3cd; margin: 10px -15px -15px; padding: 15px; border-radius: 0 0 8px 8px;">
                        <span>Nội dung CK:</span>
                        <span>
                            <strong style="color: #d63384;" id="invoiceCode"><?php echo $pendingInvoice['invoice_code']; ?></strong>
                            <button class="copy-btn" onclick="copyText('<?php echo $pendingInvoice['invoice_code']; ?>')"><i class="fa fa-copy"></i></button>
                        </span>
                    </div>
                </div>

                <div class="preview-xu">
                    <div>Sau khi thanh toán, bạn sẽ nhận được:</div>
                    <div class="xu-amount"><?php echo number_format($pendingInvoice['xu_receive']); ?> Xu</div>
                </div>

                <div class="invoice-warning">
                    <div style="margin-bottom: 10px;"><strong><i class="fa fa-exclamation-triangle"></i> Lưu ý quan trọng:</strong></div>
                    <div style="display: block; margin-bottom: 8px;">• Chuyển <strong>đúng số tiền</strong>: <?php echo number_format($pendingInvoice['amount']); ?>đ</div>
                    <div style="display: block; margin-bottom: 8px;">• Nội dung <strong>PHẢI là</strong>: <code><?php echo $pendingInvoice['invoice_code']; ?></code></div>
                    <div style="display: block;">• Hóa đơn sẽ <strong>tự động hủy</strong> sau 30 phút</div>
                </div>

                <div style="text-align: center; margin-top: 20px;">
                    <button class="btn btn-danger" onclick="cancelInvoice('<?php echo $pendingInvoice['invoice_code']; ?>')">
                        <i class="fa fa-times"></i> Hủy hóa đơn
                    </button>
                    <a href="atm.php" class="btn btn-secondary" onclick="location.reload(); return false;">
                        <i class="fa fa-refresh"></i> Làm mới
                    </a>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" id="invoiceExpiredAt" value="<?php echo $pendingInvoice['expired_at']; ?>">
    <input type="hidden" id="currentInvoiceCode" value="<?php echo $pendingInvoice['invoice_code']; ?>">

    <?php else: ?>
    <!-- FORM TẠO HÓA ĐƠN MỚI -->
    <div class="invoice-box">
        <h2 class="titlegcmxh clearfix">
            <span class="fll"><i class="fa fa-credit-card"></i> Nạp Tiền Qua Ngân Hàng</span>
        </h2>

        <div style="margin: 10px 0;" class="text-note">
            <span class="fa fa-info-circle"></span>
            <b>Tỷ lệ nạp:</b> <span style="color: red;">100,000</span> VNĐ = <span style="color: red;"><?php echo number_format($bank_tyle_xu * 100000); ?></span> Xu
        </div>

        <form id="createInvoiceForm">
            <h4><i class="fa fa-money"></i> Chọn số tiền muốn nạp:</h4>

            <div class="amount-options">
                <button type="button" class="amount-btn" data-amount="10000">10,000đ</button>
                <button type="button" class="amount-btn" data-amount="20000">20,000đ</button>
                <button type="button" class="amount-btn" data-amount="50000">50,000đ</button>
                <button type="button" class="amount-btn" data-amount="100000">100,000đ</button>
                <button type="button" class="amount-btn" data-amount="200000">200,000đ</button>
                <button type="button" class="amount-btn" data-amount="500000">500,000đ</button>
                <button type="button" class="amount-btn" data-amount="1000000">1,000,000đ</button>
                <button type="button" class="amount-btn" data-amount="2000000">2,000,000đ</button>
            </div>

            <h4 style="margin-top: 20px;"><i class="fa fa-edit"></i> Hoặc nhập số tiền khác:</h4>
            <div class="input-amount-wrapper">
                <input type="number" class="form-control" id="customAmount" name="amount"
                       placeholder="Nhập số tiền (bội số 10,000)" min="10000" step="10000"
                       style="height: 50px; font-size: 18px;">
                <span class="currency">VNĐ</span>
            </div>

            <div class="preview-xu-box" id="previewXu" style="display: none;">
                <div style="margin-bottom: 5px;">Bạn sẽ nhận được:</div>
                <div class="xu-amount" id="previewXuAmount">0 Xu</div>
            </div>

            <div class="form-group" style="margin-top: 20px;">
                <button type="submit" class="btn btn-default btn-lg btn-block" id="btnCreateInvoice">
                    <i class="fa fa-file-text-o"></i> Tạo Hóa Đơn Nạp Tiền
                </button>
                <button type="button" class="btn btn-primary btn-lg btn-block" id="btnPreviewXu" style="display: none; margin-top: 10px;">
                    <i class="fa fa-diamond"></i> <span id="btnPreviewXuText">Bạn sẽ nhận được: 0 Xu</span>
                </button>
            </div>
        </form>
    </div>
    <?php endif; ?>

    <!-- LỊCH SỬ HÓA ĐƠN -->
    <div class="invoice-box">
        <h2 class="titlegcmxh clearfix">
            <span class="fll"><i class="fa fa-history"></i> Lịch sử hóa đơn gần đây</span>
        </h2>
        <table class="table table-bordered" style="width: 100%" id="invoiceHistory">
            <thead>
                <tr>
                    <th>Mã HĐ</th>
                    <th>Số tiền</th>
                    <th>Xu nhận</th>
                    <th>Trạng thái</th>
                    <th>Thời gian</th>
                </tr>
            </thead>
        </table>
    </div>
</div>

<script>
var tyLeKhuyenMai = <?php echo $bank_tyle_xu; ?>;
var selectedAmount = 0;

// DataTable cho lịch sử hóa đơn
$(function() {
    $('#invoiceHistory').DataTable({
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
        ajax: '/ajax/history-invoice.php',
        order: [[4, 'desc']],
        dom: 'rtip',
        columns: [
            { data: 'invoice_code', name: 'invoice_code' },
            { data: 'amount', name: 'amount' },
            { data: 'xu_receive', name: 'xu_receive' },
            { data: 'status', name: 'status' },
            { data: 'created_at', name: 'created_at' }
        ]
    });
});

// Chọn số tiền nhanh
document.querySelectorAll('.amount-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.amount-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        selectedAmount = parseInt(this.dataset.amount);
        document.getElementById('customAmount').value = selectedAmount;
        updatePreview(selectedAmount);
    });
});

// Nhập số tiền custom
document.getElementById('customAmount')?.addEventListener('input', function() {
    var amount = parseInt(this.value) || 0;
    selectedAmount = amount;
    document.querySelectorAll('.amount-btn').forEach(b => {
        b.classList.toggle('active', parseInt(b.dataset.amount) === amount);
    });
    updatePreview(amount);
});

// Cập nhật preview xu
function updatePreview(amount) {
    var btnPreviewXu = document.getElementById('btnPreviewXu');
    var btnPreviewXuText = document.getElementById('btnPreviewXuText');
    if (amount >= 10000) {
        var xu = Math.floor(amount * tyLeKhuyenMai);
        btnPreviewXuText.textContent = 'Bạn sẽ nhận được: ' + xu.toLocaleString('vi-VN') + ' Xu';
        btnPreviewXu.style.display = 'block';
    } else {
        btnPreviewXu.style.display = 'none';
    }
}

// Click nút preview xu cũng submit form
document.getElementById('btnPreviewXu')?.addEventListener('click', function() {
    document.getElementById('createInvoiceForm').dispatchEvent(new Event('submit'));
});

// Submit form tạo hóa đơn
document.getElementById('createInvoiceForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    var amount = parseInt(document.getElementById('customAmount').value) || 0;

    if (amount < 10000) {
        swal.fire({text: 'Số tiền tối thiểu là 10,000đ', icon: 'error'});
        return;
    }
    if (amount % 10000 !== 0) {
        swal.fire({text: 'Số tiền phải là bội số của 10,000đ', icon: 'error'});
        return;
    }

    var btn = document.getElementById('btnCreateInvoice');
    btn.disabled = true;
    btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang tạo...';

    fetch('ajax/create_invoice.php', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest'},
        body: 'amount=' + amount
    })
    .then(res => res.json())
    .then(data => {
        if (data.status === 0) {
            swal.fire({text: 'Tạo hóa đơn thành công!', icon: 'success'}).then(() => location.reload());
        } else {
            swal.fire({text: data.msg, icon: 'error'});
            btn.disabled = false;
            btn.innerHTML = '<i class="fa fa-file-text-o"></i> Tạo Hóa Đơn Nạp Tiền';
        }
    })
    .catch(err => {
        swal.fire({text: 'Lỗi kết nối, vui lòng thử lại', icon: 'error'});
        btn.disabled = false;
        btn.innerHTML = '<i class="fa fa-file-text-o"></i> Tạo Hóa Đơn Nạp Tiền';
    });
});

// Hủy hóa đơn
function cancelInvoice(code) {
    swal.fire({
        title: 'Xác nhận hủy?',
        text: 'Bạn có chắc muốn hủy hóa đơn này?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Hủy hóa đơn',
        cancelButtonText: 'Không'
    }).then(function(result) {
        if (result.isConfirmed) {
            fetch('ajax/cancel_invoice.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest'},
                body: 'invoice_code=' + code
            })
            .then(res => res.json())
            .then(data => {
                swal.fire({text: data.msg, icon: data.status === 0 ? 'success' : 'error'}).then(() => {
                    if (data.status === 0) location.reload();
                });
            });
        }
    });
}

// Copy text
function copyText(text) {
    navigator.clipboard.writeText(text).then(() => {
        swal.fire({text: 'Đã sao chép: ' + text, icon: 'success', timer: 1500, showConfirmButton: false});
    });
}

// Download QR Code
function downloadQR() {
    var qrImage = document.getElementById('qrImage');
    var invoiceCode = document.getElementById('currentInvoiceCode')?.value || 'QRCode';

    fetch(qrImage.src)
        .then(response => response.blob())
        .then(blob => {
            var link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'QR_' + invoiceCode + '.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(link.href);
            swal.fire({text: 'Đã tải QR Code!', icon: 'success', timer: 1500, showConfirmButton: false});
        })
        .catch(err => {
            // Fallback: mở ảnh trong tab mới
            window.open(qrImage.src, '_blank');
        });
}

// Countdown timer
var expiredAt = document.getElementById('invoiceExpiredAt')?.value;
if (expiredAt) {
    var expiredTime = new Date(expiredAt).getTime();
    var countdownEl = document.getElementById('countdown');
    var invoiceCode = document.getElementById('currentInvoiceCode')?.value;
    
    var countdownInterval = setInterval(function() {
        var now = new Date().getTime();
        var distance = expiredTime - now;
        
        if (distance < 0) {
            clearInterval(countdownInterval);
            countdownEl.textContent = 'Hết hạn';
            document.getElementById('statusBadge').className = 'status-badge status-cancelled';
            document.getElementById('statusBadge').innerHTML = '<i class="fa fa-times"></i> Đã hủy';
            return;
        }
        
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);
        countdownEl.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
    }, 1000);

    // Auto check status mỗi 10 giây
    setInterval(function() {
        fetch('ajax/check_invoice.php?invoice_code=' + invoiceCode, {
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 0 && data.data.invoice_status === 1) {
                clearInterval(countdownInterval);
                swal.fire({
                    title: 'Nạp tiền thành công!',
                    text: 'Bạn đã nhận được ' + data.data.xu_receive.toLocaleString('vi-VN') + ' Xu',
                    icon: 'success'
                }).then(() => location.reload());
            }
        });
    }, 10000);
}
</script>

<?php include("footer.php"); ?>

