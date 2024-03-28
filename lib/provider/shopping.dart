import '../imports.dart';

class ShoppingProvider extends ChangeNotifier {
  final Isar isar;
  List<Shopping> shoppings = [];
  List<Shopping> todayList = [];

  ShoppingProvider(this.isar) {
    loadShoppings();
  }

  void updateShoppings() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadShoppings() async {
    shoppings = await isar.shoppings.where()
      .sortByIsComplete()
      .thenByDate()
      .findAll();
    updateShoppings();
  }

  Future<Shopping?> getShoppingById(int id) async {
    return await isar.shoppings.get(id);
  }

  Future<List<Shopping>> getShoppingByToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59, 999);
    final todayList = await isar.shoppings.filter()
      .dateBetween(startOfDay, endOfDay)
      .findAll();
    return todayList;
  }

  Future<List<Shopping>> getShoppingByComplete() async {
    final todayList = await isar.shoppings.filter()
      .isCompleteEqualTo(true)
      .findAll();
    return todayList;
  }

  Future<Map<String, dynamic>> updateShopping(Shopping updatedShopping) async {
    Map<String, dynamic> response = {
      'result': false,
      'error': '',
      'data': ''
    };
    try {
      await isar.writeTxn(() async {
        await isar.shoppings.put(updatedShopping);
      });
      loadShoppings();
      response['result'] = true;
      response['data'] = updatedShopping.toString();
    } catch (e) {
      response['error'] = e.toString();
    }
    return response;
  }

  Future<void> completeShoppingById(int shoppingId, bool isComplete) async {
    await isar.writeTxn(() async {
      final Shopping? shoppingToUpdate = await isar.shoppings.get(shoppingId);
      if (shoppingToUpdate != null) {
        shoppingToUpdate.isComplete = !isComplete;
        await isar.shoppings.put(shoppingToUpdate);
      }
    });
    loadShoppings();
  }

  Future<void> pointGetShoppingById(int shoppingId) async {
    await isar.writeTxn(() async {
      final Shopping? shoppingToUpdate = await isar.shoppings.get(shoppingId);
      if (shoppingToUpdate != null) {
        shoppingToUpdate.isPointGet = true;
        await isar.shoppings.put(shoppingToUpdate);
      }
    });
    loadShoppings();
  }

  Future<void> deleteShopping(int id) async {
    await isar.writeTxn(() async {
      await isar.shoppings.delete(id);
    });
    loadShoppings();
  }
}