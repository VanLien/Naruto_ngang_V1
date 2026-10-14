<?php
/**
 * CRON JOB - Xử lý hóa đơn nạp tiền
 *
 * URL: https://nap.bavuongdaichien.com/cron_invoice.php?key=acb_cron_napanime_2026
 *
 * Chức năng:
 * 1. Hủy các hóa đơn hết hạn (quá 30 phút)
 * 2. Check thanh toán qua API ACB
 * 3. Cộng xu cho hóa đơn đã thanh toán
 */

require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/config/bank_config.php';

// Kiểm tra key từ config
if (!isset($_GET['key']) || $_GET['key'] !== $bank_secret_key) {
    http_response_code(403);
    die("Access denied. Invalid key.");
}
require_once __DIR__ . '/processing/acb-lib.php';

// Debug function - echo ra màn hình
function cronDebug($message) {
    echo "[" . date('H:i:s') . "] " . $message . "<br>\n";
    flush();
}

// Log function - ghi vào file
function cronLog($message) {
    // Echo ra màn hình
    cronDebug($message);

    // Ghi vào file log
    $logFile = __DIR__ . '/logs/cron_invoice_' . date('Y-m-d') . '.log';
    $logDir = dirname($logFile);
    if (!is_dir($logDir)) {
        mkdir($logDir, 0755, true);
    }
    $time = date('Y-m-d H:i:s');
    file_put_contents($logFile, "[$time] $message\n", FILE_APPEND);
}

cronLog("=== CRON START ===");

// =====================================================
// LẤY LỊCH SỬ GIAO DỊCH TỪ ACB
// =====================================================
function getACBTransactions() {
    global $bank_code_username, $bank_code_password, $bank_code_stk, $bank_code_trans, $database;

    $transactions = [];

    try {
        cronDebug("📡 Đang kết nối ACB API...");
        cronDebug("- STK: " . $bank_code_stk);
        cronDebug("- Prefix: " . $bank_code_trans);

        // Lấy token từ database (bảng config)
        $tokenRow = $database->get("config", "*", ["key" => "acb_token"]);
        $token = $tokenRow ? $tokenRow['value'] : '';
        cronDebug("- Token: " . ($token ? "CÓ" : "KHÔNG CÓ"));

        $acb = new ACB($bank_code_username, $bank_code_password);
        $acb->clientId = "iuSuHYVufIUuNIREV0FB9EoLn9kHsDbm";

        // Lấy lịch sử giao dịch
        cronDebug("📥 Đang lấy lịch sử giao dịch...");
        $lichsu = $acb->LSGD($bank_code_stk, 50, $token);
        $result = json_decode($lichsu, true);

        cronDebug("- Response codeStatus: " . ($result['codeStatus'] ?? 'NULL'));

        // Nếu token hết hạn, login lại
        if (!isset($result['codeStatus']) || $result['codeStatus'] != '200') {
            cronLog("⚠️ Token hết hạn, đang login lại...");
            $login = $acb->login();

            if (isset($login['accessToken'])) {
                $token = $login['accessToken'];

                // Lưu token mới vào database (bảng config)
                if ($tokenRow) {
                    $database->update("config", ["value" => $token], ["key" => "acb_token"]);
                } else {
                    $database->insert("config", ["key" => "acb_token", "value" => $token]);
                }

                cronLog("✅ Login thành công, token mới đã lưu");

                // Lấy lại lịch sử với token mới
                $lichsu = $acb->LSGD($bank_code_stk, 50, $token);
                $result = json_decode($lichsu, true);
            } else {
                // Chỉ log error code, không log chi tiết response
                $errorCode = $login['errorCode'] ?? 'UNKNOWN';
                cronLog("❌ ERROR: Login ACB thất bại - Error code: " . $errorCode);
                return [];
            }
        }

        // Parse các giao dịch tiền vào
        cronDebug("📊 Đang parse giao dịch...");
        if (isset($result['data']) && is_array($result['data'])) {
            cronDebug("- Tổng số giao dịch từ API: " . count($result['data']));

            foreach ($result['data'] as $data) {
                if ($data['type'] == 'IN') {
                    $comment = $data['description'];
                    $amount = $data['amount'];

                    // Parse mã hóa đơn từ nội dung chuyển khoản
                    // Tìm pattern: NANIME + số (ví dụ: NANIME12345678)
                    $re = '/' . $bank_code_trans . '([0-9]+)/i';
                    preg_match($re, $comment, $matches);

                    if (!empty($matches[1])) {
                        $invoiceCode = $bank_code_trans . $matches[1];
                        $transactions[] = [
                            'invoice_code' => $invoiceCode,
                            'amount' => $amount,
                            'description' => $comment
                        ];
                        cronDebug("  ✓ Tìm thấy: $invoiceCode - " . number_format($amount) . "đ");
                    }
                }
            }
        } else {
            cronDebug("- Không có data trong response");
            cronDebug("- Raw response: " . $lichsu);
        }

        cronLog("✅ Lấy được " . count($transactions) . " giao dịch khớp từ ACB");

    } catch (Exception $e) {
        cronLog("❌ ERROR: " . $e->getMessage());
    }

    return $transactions;
}

// =====================================================
// PHẦN 1: HỦY CÁC HÓA ĐƠN HẾT HẠN
// =====================================================
function cancelExpiredInvoices() {
    global $database;

    cronDebug("🗑️ Kiểm tra hóa đơn hết hạn...");

    // Lấy các hóa đơn đang xử lý và đã hết hạn
    $expiredInvoices = $database->select("invoice", "*", [
        "AND" => [
            "status" => 0,
            "expired_at[<]" => date("Y-m-d H:i:s")
        ]
    ]);

    cronDebug("- Tìm thấy " . count($expiredInvoices) . " hóa đơn hết hạn");

    $cancelCount = 0;
    foreach ($expiredInvoices as $invoice) {
        $update = $database->update("invoice", [
            "status" => 2,
            "cancelled_at" => date("Y-m-d H:i:s"),
            "note" => "Tự động hủy do hết hạn (CRON)"
        ], ["id" => $invoice['id']]);

        if ($update) {
            $cancelCount++;
            cronLog("  ❌ Hủy: {$invoice['invoice_code']} - User: {$invoice['username']}");
        }
    }

    cronLog("🗑️ Đã hủy $cancelCount hóa đơn hết hạn");
    return $cancelCount;
}

// =====================================================
// PHẦN 2: XỬ LÝ CỘNG XU CHO HÓA ĐƠN ĐÃ THANH TOÁN
// =====================================================
function processPaidInvoices($acbTransactions) {
    global $database, $tyle_khuyenmai, $eventGacha;

    cronDebug("💰 Kiểm tra hóa đơn chờ thanh toán...");

    // Lấy các hóa đơn đang xử lý (status = 0)
    $pendingInvoices = $database->select("invoice", "*", [
        "status" => 0
    ]);

    cronDebug("- Có " . count($pendingInvoices) . " hóa đơn đang chờ");
    cronDebug("- Có " . count($acbTransactions) . " giao dịch ACB để so khớp");

    $processedCount = 0;
    foreach ($pendingInvoices as $invoice) {
        cronDebug("  🔍 Kiểm tra: {$invoice['invoice_code']} - " . number_format($invoice['amount']) . "đ");

        // Check xem hóa đơn có trong danh sách giao dịch ACB không
        $isPaid = false;
        $bankTransactionId = null;

        foreach ($acbTransactions as $trans) {
            // So khớp mã hóa đơn VÀ số tiền
            if (strtoupper($trans['invoice_code']) == strtoupper($invoice['invoice_code'])
                && $trans['amount'] == $invoice['amount']) {
                $isPaid = true;
                $bankTransactionId = $trans['description']; // Lưu nội dung CK làm mã GD
                cronDebug("    ✓ KHỚP với giao dịch: " . $trans['description']);
                break;
            }
        }

        // ĐÃ THANH TOÁN - CỘNG XU
        if ($isPaid) {
            $result = completeInvoice($invoice, $bankTransactionId);
            if ($result) {
                $processedCount++;
                cronLog("  ✅ THÀNH CÔNG: {$invoice['invoice_code']} - Cộng {$invoice['xu_receive']} xu cho {$invoice['username']}");
            }
        } else {
            cronDebug("    ✗ Chưa tìm thấy giao dịch khớp");
        }
    }

    cronLog("💰 Đã xử lý $processedCount hóa đơn thanh toán thành công");
    return $processedCount;
}

/**
 * Hoàn tất hóa đơn - Cộng xu cho user
 */
function completeInvoice($invoice, $bankTransactionId = null) {
    global $database, $eventGacha;

    try {
        // Bắt đầu transaction
        $database->pdo->beginTransaction();

        // 1. Cập nhật trạng thái hóa đơn
        $updateInvoice = $database->update("invoice", [
            "status" => 1,
            "paid_at" => date("Y-m-d H:i:s"),
            "bank_transaction_id" => $bankTransactionId,
            "note" => "Thanh toán thành công (CRON)"
        ], ["id" => $invoice['id']]);

        if (!$updateInvoice) {
            throw new Exception("Lỗi cập nhật hóa đơn");
        }

        // 2. Cộng xu cho user
        $updateUser = $database->update("account", [
            "xu[+]" => $invoice['xu_receive']
        ], ["username" => $invoice['username']]);

        if (!$updateUser) {
            throw new Exception("Lỗi cộng xu cho user");
        }

        // 3. Thêm lượt quay gacha (nếu có event)
        if ($eventGacha) {
            addLuotQuay($invoice['username'], $invoice['amount']);
        }

        // 4. Ghi log lịch sử
        $content = "Nạp tiền thành công: " . number_format($invoice['amount']) . "đ - Nhận " . $invoice['xu_receive'] . " xu (Mã: {$invoice['invoice_code']})";
        AddUserHistory($invoice['username'], $content, 'TopUP');

        // 5. Insert vào bảng card để thống kê
        $database->insert("card", [
            "username" => $invoice['username'],
            "loaithe" => "Bank",
            "menhgia" => $invoice['amount'],
            "xu_receive" => $invoice['xu_receive'],
            "mathe" => $invoice['invoice_code'],
            "seri" => $bankTransactionId ?? "CRON",
            "trangthai" => 2,
            "idgiaodich" => $invoice['invoice_code'],
            "created_at" => date("Y-m-d H:i:s")
        ]);

        // Commit transaction
        $database->pdo->commit();
        return true;

    } catch (Exception $e) {
        // Rollback nếu có lỗi
        $database->pdo->rollBack();
        cronLog("ERROR: " . $e->getMessage() . " - Invoice: {$invoice['invoice_code']}");
        return false;
    }
}

/**
 * Hủy hóa đơn thủ công (dùng khi cần)
 */
function cancelInvoice($invoiceId, $reason = "Hủy bởi CRON") {
    global $database;

    $invoice = $database->get("invoice", "*", ["id" => $invoiceId]);
    if (!$invoice || $invoice['status'] != 0) {
        return false;
    }

    $update = $database->update("invoice", [
        "status" => 2,
        "cancelled_at" => date("Y-m-d H:i:s"),
        "note" => $reason
    ], ["id" => $invoiceId]);

    if ($update) {
        cronLog("Hủy hóa đơn: {$invoice['invoice_code']} - Lý do: $reason");
        return true;
    }
    return false;
}

// =====================================================
// CHẠY CRON
// =====================================================

echo "<pre style='background:#1e1e1e;color:#0f0;padding:20px;font-family:monospace;'>";
echo "╔══════════════════════════════════════════════════════════╗\n";
echo "║       🏦 ACB PAYMENT CRON - NAPANIME                     ║\n";
echo "╚══════════════════════════════════════════════════════════╝\n\n";

// 1. Hủy hóa đơn hết hạn
cancelExpiredInvoices();

echo "\n";

// 2. Lấy lịch sử giao dịch từ ACB
$acbTransactions = getACBTransactions();

echo "\n";

// 3. Xử lý hóa đơn đã thanh toán
processPaidInvoices($acbTransactions);

echo "\n";
cronLog("=== CRON END ===");

echo "\n╔══════════════════════════════════════════════════════════╗\n";
echo "║       ✅ CRON COMPLETED - " . date('Y-m-d H:i:s') . "            ║\n";
echo "╚══════════════════════════════════════════════════════════╝\n";
echo "</pre>";

