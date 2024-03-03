import 'package:intl/intl.dart';
import '../../imports.dart';

class TodoEdit extends StatefulWidget  {

  final String mode;
  final Todo todo;
  const TodoEdit({
    Key? key,
    required this.mode,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoEdit> createState() => _TodoEditState();
}
class _TodoEditState extends State<TodoEdit> {

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeFromController = TextEditingController();
  final timeToController = TextEditingController();
  final addressController = TextEditingController();
  final urlController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeFromController.dispose();
    timeToController.dispose();
    addressController.dispose();
    urlController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // 日付と時間を組み合わせる
  DateTime combineDateAndTime(String dateString, String timeString) {
    final date = DateFormat('yyyy-MM-dd').parse(dateString);
    final time = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(timeString));
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void submit(mode, todo) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    if (nameController.text.isEmpty) {
      showAlertDialog(context, content: settingsProvider.isJP ? 'タスクを入力してください。' : 'Please enter your task.');
      return;
    }
    if (dateController.text.isEmpty) {
      showAlertDialog(context, content: settingsProvider.isJP ? '日付を入力してください。' : 'Please enter your date.');
      return;
    }

    DateTime? timeFrom;
    if (timeFromController.text.isNotEmpty && dateController.text.isNotEmpty) {
      final dateFrom = combineDateAndTime(dateController.text, timeFromController.text);
      timeFrom = dateFrom;
    }

    DateTime? timeTo;
    if (timeToController.text.isNotEmpty && dateController.text.isNotEmpty) {
      final dateTo = combineDateAndTime(dateController.text, timeToController.text);
      timeTo = dateTo;
    }

    // Todoクラスのインスタンスを作成
    final Todo instance = Todo()
      ..name = nameController.text
      ..dateFrom = timeFrom
      ..dateTo = timeTo
      ..address = addressController.text
      ..url = urlController.text
      ..note = noteController.text
      ..isComplete = false
      ..isPointGet = false
      ..createdAt = todo?.createdAt ?? DateTime.now();
      if (todo != null && mode == 'edit') {
        instance.id = todo.id;
      }
    todoProvider.updateTodo(instance);
    cancel();
  }

  void cancel() async {
    if (!mounted) return;
    nameController.clear();
    dateController.clear();
    timeFromController.clear();
    timeToController.clear();
    addressController.clear();
    urlController.clear();
    noteController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 32;
    double fontSize= 20;
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final mode = widget.mode;
    final todo = widget.todo;
    var initialDate = DateTime.now();
    if (todo.name != null) {
      nameController.text = todo.name!;
    }
    if (todo.dateFrom != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(todo.dateFrom!);
      initialDate = todo.dateFrom!;
      if (mode == 'new') {
        timeFromController.text = DateFormat('HH:mm').format(DateTime.now());
      } else {
        timeFromController.text = DateFormat('HH:mm').format(todo.dateFrom!);
      }
    }
    if (todo.dateTo != null) {
      timeToController.text = DateFormat('HH:mm').format(todo.dateTo!);
      if (mode == 'new') {
        timeToController.text = DateFormat('HH:mm').format(DateTime.now());
      } else {
        timeToController.text = DateFormat('HH:mm').format(todo.dateTo!);
      }
    }
    if (todo.address != null) {
      addressController.text = todo.address!;
    }
    if (todo.url != null) {
      urlController.text = todo.url!;
    }
    if (todo.note != null) {
      noteController.text = todo.note!;
    }

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  const SizedBox(width: 2),
                  Container(
                    width: 4,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight - 2,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? 'タスク' : 'Task',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.5)
                        ),
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.calendar, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '日付' : 'Date',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            locale: Locale(settingsProvider.isJP ? 'ja' : 'en'),
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 36000)),
                          );
                          if (picked != null) {
                            dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.clock, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: timeFromController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '時間(始)' : 'TimeFrom',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Localizations.override(
                                context: context,
                                locale: Locale(settingsProvider.isJP ? 'ja' : 'en'),
                                child: child!,
                              );
                            },
                          ).then((picked) => {
                            if (picked != null) {
                              timeFromController.text = picked.format(context)
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: timeToController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '時間(至)' : 'TimeTo',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Localizations.override(
                                context: context,
                                locale: Locale(settingsProvider.isJP ? 'ja' : 'en'),
                                child: child!,
                              );
                            },
                          ).then((picked) => {
                            if (picked != null) {
                              timeToController.text = picked.format(context)
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.mapMarker, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '場所' : 'Address',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.link, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? 'URL' : 'URL',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.edit, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? 'メモ' : 'Note',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                submit(mode, todo);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(LineIcons.check),
            ),
          ]
        )
      ]
    );
  }
}