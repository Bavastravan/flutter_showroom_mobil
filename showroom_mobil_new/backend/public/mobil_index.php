<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once '../config/database.php'; // koneksi $pdo

try {
    $stmt = $pdo->query('SELECT * FROM mobil ORDER BY created_at DESC');
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'message' => 'Data mobil berhasil diambil',
        'data'    => $rows,
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Terjadi kesalahan saat mengambil data mobil',
        'data'    => [],
    ]);
}
