<?php
require '../vendor/autoload.php';  // Composer autoload

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JWTHandler {

    private $secret_key = "vuongthuthanthoai@";  // Thay thế bằng khóa bí mật của bạn
    private $issuer = "https://id.daichienpoke.com";  // Địa chỉ phát hành token

    // Tạo JWT token
    public function generateToken($data) {
        $payload = [
            'iss' => $this->issuer,         // Issuer
            'iat' => time(),                // Thời gian phát hành
            'exp' => time() + (60 * 60),    // Thời gian hết hạn (1 giờ)
            'data' => $data                 // Dữ liệu người dùng
        ];

        // Tạo và trả về token
        return JWT::encode($payload, $this->secret_key, 'HS256');
    }

    // Giải mã và kiểm tra JWT token
    public function validateToken($jwt) {
        if(!$jwt) {
            return [
                'status' => false,
                'message' => 'Token không tồn tại'
            ];
        }
        try {
            // Giải mã token
            $decoded = JWT::decode($jwt, new Key($this->secret_key, 'HS256'));

            // Trả về dữ liệu nếu token hợp lệ
            return [
                'status' => true,
                'data' => $decoded->data
            ];
        } catch (Exception $e) {
            // Token không hợp lệ hoặc đã hết hạn
            return [
                'status' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    // Kiểm tra nếu token hợp lệ từ request
    public function getBearerToken() {
        $headers = getallheaders();  // Lấy tất cả header từ request

        if (isset($headers['Authorization'])) {
            $authHeader = $headers['Authorization'];
            if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
                return $matches[1];  // Trả về token
            }
        }
        return null;  // Không có token trong header
    }
}
