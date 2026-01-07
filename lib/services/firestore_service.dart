import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // === Mobil ===
  Future<List<Map<String, dynamic>>> getAllMobils() async {
    final snapshot = await _db.collection('mobils').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>?> getMobilById(String id) async {
    final doc = await _db.collection('mobils').doc(id).get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  Future<void> addMobil(Map<String, dynamic> data) async {
    await _db.collection('mobils').add(data);
  }

  Future<void> updateMobil(String id, Map<String, dynamic> data) async {
    await _db.collection('mobils').doc(id).update(data);
  }

  Future<void> deleteMobil(String id) async {
    await _db.collection('mobils').doc(id).delete();
  }

  // === Booking ===
  Future<void> addBooking(Map<String, dynamic> data) async {
    await _db.collection('bookings').add(data);
  }

  Future<List<Map<String, dynamic>>> getBookingsByUser(String userId) async {
    final snapshot = await _db.collection('bookings').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // === User ===
  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // === Tambah service lain: booking servis, sparepart, garansi ===
  // Struktur dan operasi serupa, tinggal duplikasi/ganti nama collection saja

}
