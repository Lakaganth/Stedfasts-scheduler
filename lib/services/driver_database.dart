import 'dart:async';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/services/api_path.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/firestore_services.dart';

abstract class DriverDatabase {
  Future<void> setNewDriver(Driver driver);
  Stream<List<Driver>> driverStream();
  Stream<List<Driver>> driverProfile(User user);
}

class DriveFirestoreDatabase implements DriverDatabase {
  final _service = FirestoreService.instance;

  @override
  Future<void> setNewDriver(Driver driver) async {
    return await _service.setData(
        path: APIPath.driver(driver.id), data: driver.toMap());
  }

  @override
  Stream<List<Driver>> driverStream() => _service.collectionStream(
        path: APIPath.drivers(),
        builder: (data, documentId) => Driver.fromMap(data, documentId),
      );

  @override
  Stream<List<Driver>> driverProfile(User user) =>
      _service.collectionStream<Driver>(
        path: APIPath.drivers(),
        queryBuilder: user != null
            ? (query) => query.where('id', isEqualTo: user.uid)
            : null,
        builder: (data, documentId) => Driver.fromMap(data, documentId),
      );
}
