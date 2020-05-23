import 'dart:async';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/services/api_path.dart';
import 'package:stedfasts_scheduler/services/firestore_services.dart';

abstract class DriverDatabase {
  Future<void> setNewDriver(Driver driver);
  Stream<List<Driver>> driverStream();
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
}
