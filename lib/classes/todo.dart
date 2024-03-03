import 'package:isar/isar.dart';
part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;
  String? name;
  DateTime? dateFrom;
  DateTime? dateTo;
  String? address;
  String? url;
  String? note;
  bool isMessage = false;
  bool isComplete = false;
  bool isPointGet = false;
  DateTime? createdAt = DateTime.now();
}