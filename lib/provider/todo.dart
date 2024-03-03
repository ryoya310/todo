import '../imports.dart';

class TodoProvider extends ChangeNotifier {
  final Isar isar;
  List<Todo> todos = [];

  TodoProvider(this.isar) {
    loadTodos();
  }

  void updateTodos() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadTodos() async {
    todos = await isar.todos.where().sortByDateFrom().findAll();
    updateTodos();
  }

  Future<Todo?> getTodoById(int id) async {
    return await isar.todos.get(id);
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    await isar.writeTxn(() async {
      await isar.todos.put(updatedTodo);
    });
    loadTodos();
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