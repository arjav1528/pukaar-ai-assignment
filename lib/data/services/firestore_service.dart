import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pukaar/data/models/activity_entry.dart';
import 'package:pukaar/data/models/metric_type.dart';
import 'package:pukaar/shared/utils/app_log.dart';

class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _entriesCol {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      pukaarLog('FirestoreService._entriesCol: Not signed in', tag: 'Pukaar.Firestore');
      throw StateError('Not signed in');
    }
    return _db.collection('users').doc(uid).collection('entries');
  }

  Future<void> addEntry({
    required MetricType metric,
    required num value,
    required String dateKey,
    String? note,
  }) async {
    pukaarLog(
      'FirestoreService.addEntry: metric=$metric value=$value dateKey=$dateKey',
      tag: 'Pukaar.Firestore',
    );
    await _entriesCol.add(<String, dynamic>{
      'metric': metric.firestoreValue,
      'value': value,
      'dateKey': dateKey,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    });
    pukaarLog('FirestoreService.addEntry: done', tag: 'Pukaar.Firestore');
  }

  Future<void> deleteEntry(String entryId) async {
    pukaarLog('FirestoreService.deleteEntry: $entryId', tag: 'Pukaar.Firestore');
    await _entriesCol.doc(entryId).delete();
  }

  /// Entries for one calendar day (client-sorted by `createdAt` desc).
  Stream<List<ActivityEntry>> streamEntriesForDateKey(String dateKey) {
    pukaarLog('FirestoreService.streamEntriesForDateKey: $dateKey', tag: 'Pukaar.Firestore');
    return _entriesCol.where('dateKey', isEqualTo: dateKey).snapshots().map((snap) {
      final list = snap.docs.map((d) => ActivityEntry.fromMap(d.id, d.data())).toList();
      list.sort((a, b) {
        final ta = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final tb = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return tb.compareTo(ta);
      });
      return list;
    });
  }

  /// All entries for history views (group by `dateKey` in UI).
  Stream<List<ActivityEntry>> streamAllEntries({int limit = 2000}) {
    pukaarLog('FirestoreService.streamAllEntries: limit=$limit', tag: 'Pukaar.Firestore');
    return _entriesCol.orderBy('createdAt', descending: true).limit(limit).snapshots().map(
          (snap) => snap.docs.map((d) => ActivityEntry.fromMap(d.id, d.data())).toList(),
        );
  }
}
