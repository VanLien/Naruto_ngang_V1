<?php
// =====================================================
// CẤU HÌNH NGÂN HÀNG ACB
// =====================================================

$bank_code_id  = '970416';           // Mã ngân hàng (BIN)
$bank_code_name  = 'ACB';            // Tên ngân hàng hiển thị
$bank_code_stk = 'so tai khoan';          // Số tài khoản nhận tiền
$bank_code_ctk = 'ten chu tai khoan'; // Chủ tài khoản
$bank_code_username  = 'taikhoan';      // Username đăng nhập ACB App
$bank_code_password  = 'matkhau';  // Password đăng nhập ACB App
$bank_code_trans = 'INV';         // Prefix nội dung chuyển khoản

// =====================================================
// CẤU HÌNH TỶ LỆ XU
// =====================================================
// Công thức: xu_nhận = số_tiền * tỷ_lệ
// Ví dụ: 100,000đ * 0.001 = 100 xu

// Tỷ lệ nạp Bank (chuyển khoản)
$bank_tyle_xu = 2;  // 1,000đ = 1 xu

// Tỷ lệ nạp Card (thẻ cào) - thường thấp hơn do chiết khấu
$card_tyle_xu = 2;  // Để 0.0008 thì 1,250đ = 1 xu (chiết khấu 20%)

// Token Cron
$bank_secret_key = 'acb_cron_napanime_2026';