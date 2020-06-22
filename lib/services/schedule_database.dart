import 'dart:async';
import 'package:meta/meta.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/api_path.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/firestore_services.dart';

abstract class ScheduleDatabase {
  Future<void> setNewSchedule(DaySchedule schedule);
  Stream<List<DaySchedule>> scheduleStream();
  Stream<List<DaySchedule>> weeksHoursStream(User user);
  Future<void> deleteScheduleForDriver({@required String scheduleId});
  Stream<List<DaySchedule>> weeksHoursStreamDriver(Driver driver);
}

class ScheduleFirestoreDatabase implements ScheduleDatabase {
  final _service = FirestoreService.instance;

  @override
  Future<void> setNewSchedule(DaySchedule schedule) async {
    return await _service.setData(
        path: APIPath.daySchedule(schedule.id), data: schedule.toMap());
  }

  @override
  Future<void> deleteScheduleForDriver({@required String scheduleId}) async {
    await _service.deleteData(path: APIPath.daySchedule(scheduleId));
  }

  @override
  Stream<List<DaySchedule>> scheduleStream() => _service.collectionStream(
      path: APIPath.daySchedules(),
      builder: (data, documentId) => DaySchedule.fromMap(data, documentId));

  @override
  Stream<List<DaySchedule>> weeksHoursStream(User user) =>
      _service.collectionStream<DaySchedule>(
        path: APIPath.daySchedules(),
        queryBuilder: user != null
            ? (query) => query.where('driverId', isEqualTo: user.uid)
            : null,
        builder: (data, documentId) => DaySchedule.fromMap(data, documentId),
      );
  @override
  Stream<List<DaySchedule>> weeksHoursStreamDriver(Driver driver) =>
      _service.collectionStream<DaySchedule>(
        path: APIPath.daySchedules(),
        queryBuilder: driver != null
            ? (query) => query.where('driverId', isEqualTo: driver.id)
            : null,
        builder: (data, documentId) => DaySchedule.fromMap(data, documentId),
      );

}
