import 'package:flutter_slidable/flutter_slidable.dart';
import '../../imports.dart';
import 'edit.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = this.todo;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: itemBackColor,
        borderRadius: BorderRadius.circular(radiusSize),
      ),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (BuildContext context) {
                todoProvider.completeTodoById(todo.id, todo.isComplete);
              },
              backgroundColor: todo.isComplete ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              icon: todo.isComplete ? LineIcons.arrowLeft : LineIcons.check,
            ),
            SlidableAction(
              autoClose: false,
              onPressed: (BuildContext context) async {
                showConfirmDialog(
                  context,
                  content: settingsProvider.isJP ? '削除しますか？' : 'Do you want to delete it?',
                  onClick: () {
                    todoProvider.deleteTodo(todo.id);
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radiusSize),
                bottomRight: Radius.circular(radiusSize),
              ),
              icon: LineIcons.alternateTrashAlt,
            ),
          ],
        ),
        child: ListTile(
          hoverColor: Colors.transparent,
          title: Row(
            children: [
              Column(
                children: [
                  Text(todo.dateFrom != null
                    ? '${todo.dateFrom!.hour.toString().padLeft(2, '0')}:${todo.dateFrom!.minute.toString().padLeft(2, '0')}'
                    : ''),
                  Text(todo.dateTo != null
                    ? '${todo.dateTo!.hour.toString().padLeft(2, '0')}:${todo.dateTo!.minute.toString().padLeft(2, '0')}'
                    : ''),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                height: 50,
                width: 4,
                color: Colors.blue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.name ?? '-',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      todo.address ?? '-',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          trailing: Visibility(
            visible: todo.isComplete,
            child: const SizedBox(
              child: Icon(
                LineIcons.sketch,
                color: Colors.lightBlue
              ),
            ),
          ),
          onTap: () async {
            showOpenModal(
              context,
              title: settingsProvider.isJP ? '編集' : 'Edit',
              content: TodoEdit(mode: 'edit', todo: todo)
            );
          },
        )
      )
    );
  }
}