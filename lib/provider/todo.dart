import '../imports.dart';

class TodoProvider extends ChangeNotifier {
  final Isar isar;
  List<Todo> todos = [];
  List<Todo> todayList = [];

  TodoProvider(this.isar) {
    loadTodos();
  }

  void updateTodos() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadTodos() async {
    todos = await isar.todos.where()
      .sortByIsComplete()
      .thenByDateFrom()
      .findAll();
    updateTodos();
  }

  Future<Todo?> getTodoById(int id) async {
    return await isar.todos.get(id);
  }

  Future<List<Todo>> getTodoByToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59, 999);
    final todayList = await isar.todos.filter()
      .dateFromBetween(startOfDay, endOfDay)
      .sortByIsComplete()
      .thenByDateFrom()
      .findAll();
    return todayList;
  }

  Future<List<Todo>> getTodoByComplete() async {
    final todayList = await isar.todos.filter()
      .isCompleteEqualTo(true)
      .findAll();
    return todayList;
  }

  Future<Map<String, dynamic>> updateTodo(Todo updatedTodo) async {
    Map<String, dynamic> response = {
      'result': false,
      'error': '',
      'data': ''
    };
    try {
      await isar.writeTxn(() async {
        await isar.todos.put(updatedTodo);
      });
      loadTodos();
      response['result'] = true;
      response['data'] = updatedTodo.toString();
    } catch (e) {
      response['error'] = e.toString();
    }
    return response;
  }

  Future<void> completeTodoById(int todoId, bool isComplete) async {
    await isar.writeTxn(() async {
      final Todo? todoToUpdate = await isar.todos.get(todoId);
      if (todoToUpdate != null) {
        todoToUpdate.isComplete = !isComplete;
        await isar.todos.put(todoToUpdate);
      }
    });
    loadTodos();
  }

  Future<void> pointGetTodoById(int todoId) async {
    await isar.writeTxn(() async {
      final Todo? todoToUpdate = await isar.todos.get(todoId);
      if (todoToUpdate != null) {
        todoToUpdate.isPointGet = true;
        await isar.todos.put(todoToUpdate);
      }
    });
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(id);
    });
    loadTodos();
  }
}