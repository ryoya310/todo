import 'package:isar/isar.dart';
part 'shopping.g.dart';

@collection
class Shopping {
  Id id = Isar.autoIncrement;
  String? name;
  DateTime? date;
  String? note;
  bool isComplete = false;
  bool isPointGet = false;
  DateTime? createdAt = DateTime.now();
}