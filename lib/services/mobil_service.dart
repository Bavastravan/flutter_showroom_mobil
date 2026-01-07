import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mobil_model.dart';

class MobilService {
  final CollectionReference _mobilsRef = FirebaseFirestore.instance.collection('mobils');

  // Ambil semua mobil (real-time dengan Stream)
  Stream<List<MobilModel>> getMobilsStream() {
    return _mobilsRef.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => MobilModel.fromFirestore(doc)).toList()
    );
  }

  // Ambil semua mobil (sekali fetch)
  Future<List<MobilModel>> getAllMobils() async {
    final snapshot = await _mobilsRef.get();
    return snapshot.docs.map((doc) => MobilModel.fromFirestore(doc)).toList();
  }

  // Ambil satu mobil by ID
  Future<MobilModel?> getMobilById(String id) async {
    final doc = await _mobilsRef.doc(id).get();
    if (doc.exists) {
      return MobilModel.fromFirestore(doc);
    }
    return null;
  }

  // Tambah mobil baru
  Future<void> addMobil(MobilModel mobil) async {
    await _mobilsRef.add(mobil.toMap());
  }

  // Update mobil
  Future<void> updateMobil(String id, Map<String, dynamic> data) async {
    await _mobilsRef.doc(id).update(data);
  }

  // Hapus mobil
  Future<void> deleteMobil(String id) async {
    await _mobilsRef.doc(id).delete();
  }
}
