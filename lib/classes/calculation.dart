import 'package:isar/isar.dart';
part 'calculation.g.dart';

@collection
class Calculation {
  Id id = Isar.autoIncrement;
  String? name;
  double? calcData;
  String? note;
  bool isComplete = false;
  bool isPointGet = false;
  DateTime? createdAt = DateTime.now();
}