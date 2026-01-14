<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // sesuaikan untuk produksi

require_once '../config/database.php'; // koneksi $pdo (PDO)

// Ambil data dari POST (bisa form-data atau JSON)
$input = $_POST;
if (empty($input)) {
    $raw = file_get_contents('php://input');
    $input = json_decode($raw, true) ?? [];
}

$nama       = trim($input['nama'] ?? '');
$email      = trim($input['email'] ?? '');
$alamat     = trim($input['alamat'] ?? '');
$no_telpon  = trim($input['no_telpon'] ?? '');
$password   = $input['password'] ?? '';

// Validasi sederhana
if ($nama === '' || $email === '' || $password === '') {
    echo json_encode([
        'success' => false,
        'message' => 'Nama, email, dan password wajib diisi',
    ]);
    exit;
}

// Cek email sudah terdaftar atau belum
try {
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        echo json_encode([
            'success' => false,
            'message' => 'Email sudah terdaftar',
        ]);
        exit;
    }

    // Hash password
    $passwordHash = password_hash($password, PASSWORD_DEFAULT);

    // Insert user baru
    $stmt = $pdo->prepare(
        'INSERT INTO users (nama, email, alamat, no_telpon, password_hash, role)
         VALUES (?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $nama,
        $email,
        $alamat,
        $no_telpon,
        $passwordHash,
        'customer', // default role
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Registrasi berhasil',
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Terjadi kesalahan server',
    ]);
}
