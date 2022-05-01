import 'package:hive_flutter/hive_flutter.dart';
import 'package:xave/core/datasources/datasource_service.dart';

/// Implementation of [IDataSourceService] that uses [Hive].
class HiveService<T> implements IDataSourceService<T> {
  /// Initializes a new [HiveService].
  const HiveService({required Box<T> box}) : _box = box;
  final Box<T> _box;

  @override
  Future<List<T>> readAll() async {
    return _box.values.toList();
  }

  @override
  Future<T?> read(String ref) async {
    try {
      return _box.get(ref);
    } catch (e) {
      throw ReadException(message: '$e');
    }
  }

  @override
  Future<void> write(String ref, T data) async {
    try {
      await _box.put(ref, data);
    } catch (e) {
      throw UpdateException(message: '$e');
    }
  }

  @override
  Future<void> update(String ref, T data) async {
    try {
      await _box.put(ref, data);
    } catch (e) {
      throw UpdateException(message: '$e');
    }
  }

  @override
  Future<void> delete(String ref) async {
    try {
      await _box.delete(ref);
    } catch (e) {
      throw DeleteException(message: '$e');
    }
  }

  @override
  Future<void> clean() async {
    try {
      await _box.clear();
    } catch (e) {
      throw DeleteException(message: '$e');
    }
  }

  @override
  Stream<T> get dataStream => throw UnimplementedError();
}
