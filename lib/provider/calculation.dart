import '../imports.dart';

class CalculationProvider extends ChangeNotifier {
  final Isar isar;
  List<Calculation> calculations = [];

  CalculationProvider(this.isar) {
    loadCalculations();
  }

  void updateCalculations() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadCalculations() async {
    calculations = await isar.calculations.where().sortByCalcDataDesc().findAll();
    updateCalculations();
  }

  Future<Calculation?> getCalculationById(int id) async {
    return await isar.calculations.get(id);
  }

  Future<Map<String, dynamic>> updateCalculation(Calculation updatedCalculation) async {
    Map<String, dynamic> response = {
      'result': false,
      'error': '',
      'data': ''
    };
    try {
      await isar.writeTxn(() async {
        await isar.calculations.put(updatedCalculation);
      });
      loadCalculations();
      response['result'] = true;
      Calculation calculation = updatedCalculation;
      response['data'] = calculation;
    } catch (e) {
      response['error'] = e.toString();
    }
    return response;
  }

  Future<void> completeCalculationById(int calculationId, bool isComplete) async {
    await isar.writeTxn(() async {
      final Calculation? calculationToUpdate = await isar.calculations.get(calculationId);
      if (calculationToUpdate != null) {
        calculationToUpdate.isComplete = !isComplete;
        await isar.calculations.put(calculationToUpdate);
      }
    });
    loadCalculations();
  }

  Future<void> pointGetCalculationById(int calculationId) async {
    await isar.writeTxn(() async {
      final Calculation? calculationToUpdate = await isar.calculations.get(calculationId);
      if (calculationToUpdate != null) {
        calculationToUpdate.isPointGet = true;
        await isar.calculations.put(calculationToUpdate);
      }
    });
    loadCalculations();
  }

  Future<void> deleteCalculation(int id) async {
    await isar.writeTxn(() async {
      await isar.calculations.delete(id);
    });
    loadCalculations();
  }
}