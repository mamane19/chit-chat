import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xave/core/datasources/datasource_service.dart';

/// An implementatioon of [IDataSourceService] with [FirebaseFirestore].
class FirestoreService implements IDataSourceService<Map<String, dynamic>> {
  /// Initializes a new [FirestoreService]
  const FirestoreService({
    required FirebaseFirestore firestore,
    required String collectionPath,
  })  : _firestore = firestore,
        _path = collectionPath;

  final FirebaseFirestore _firestore;
  final String _path;

  CollectionReference<Map<String, dynamic>> get _colection =>
      _firestore.collection(_path);

  @override
  Future<Map<String, dynamic>?> read(String ref) async {
    try {
      final doc = await _colection.doc(ref).get();
      return doc.data();
    } catch (e) {
      throw ReadException(message: '$e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAll() async {
    try {
      final data = <Map<String, dynamic>>[];
      final snap = await _colection.get();
      for (final doc in snap.docs) {
        data.add(doc.data());
      }
      return data;
    } catch (e) {
      throw ReadException(message: '$e');
    }
  }

  @override
  Future<void> update(String ref, Map<String, dynamic> data) async {
    try {
      await _colection.doc(ref).set(data);
    } catch (e) {
      throw UpdateException(message: '$e');
    }
  }

  @override
  Future<void> delete(String ref) async {
    try {
      await _colection.doc(ref).delete();
    } catch (e) {
      throw DeleteException(message: '$e');
    }
  }

  @override
  Future<void> write(String ref, Map<String, dynamic> data) async {
    try {
      await _colection.doc(ref).set(data);
    } catch (e) {
      throw WriteException(message: '$e');
    }
  }

  @override
  Future<void> clean() async {
    try {
      final batch = _firestore.batch();
      final snap = await _colection.get();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
    } catch (e) {
      throw DeleteException(message: '$e');
    }
  }

  @override
  Stream<Map<String, dynamic>> get dataStream {
    final _controler = StreamController<Map<String, dynamic>>();
    _colection.snapshots().listen((event) {
      for (final doc in event.docs) {
        _controler.sink.add(doc.data());
      }
    });
    return _controler.stream;
  }
}
