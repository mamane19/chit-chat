/// An interface that interacts with a data source.
///
/// The generic type [T] is the type of object handled.
abstract class IDataSourceService<T> {
  /// Gets an object from the data source.
  Future<T?> read(String ref);

  /// Writes [data] to the source.
  Future<void> write(String ref, T data);

  /// Update data using its reference.
  Future<void> update(String ref, T data);

  /// Deletes the data on the [ref].
  Future<void> delete(String ref);

  /// Gets all items from data source.
  Future<List<T>> readAll();

  /// Deletes everything from this data source.
  Future<void> clean();

  /// Streams data.
  Stream<T> get dataStream;
}

/// An exception thrown when an operation in the data source fails.
abstract class DataSourceException implements Exception {
  /// Initializes a new [DataSourceException]
  const DataSourceException({this.message});

  /// Error message.
  final String? message;

  @override
  String toString() => '$runtimeType::$message';
}

/// Exception thrown when reading data from a source fails.
class ReadException extends DataSourceException {
  /// Initiailzes a new [ReadException].
  const ReadException({String? message}) : super(message: message);
}

/// Exception thrown when writing data to the source fails.
class WriteException extends DataSourceException {
  /// Initiailzes a new [WriteException].
  const WriteException({String? message}) : super(message: message);
}

/// Exception thrown when updating data fails.
class UpdateException extends DataSourceException {
  /// Initiailzes a new [UpdateException].
  const UpdateException({String? message}) : super(message: message);
}

/// Exception thrown when delelting data fails.
class DeleteException extends DataSourceException {
  /// Initialilzes a new [DeleteException].
  const DeleteException({String? message}) : super(message: message);
}
