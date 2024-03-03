import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../imports.dart';
import 'item.dart';
import 'edit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}): super(key: key);
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focused = DateTime.now();
  DateTime? selected;
  Map<DateTime, List> eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<TodoProvider>(context, listen: false).loadTodos()
    );
    selected = focused;
  }

  String formatDate(DateTime selected, bool isJP) {
    initializeDateFormatting();
    final locale = isJP ? 'ja' : 'en';
    final format = isJP ? 'yyyy年MM月dd日(E)' : 'yyyy/MM/dd(E)';
    final formatter = DateFormat(format, locale);
    final formattedDate = formatter.format(selected);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          body: Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              final todos = todoProvider.todos;
              final Map<DateTime, List<Todo>> eventsList = {};
              for (final Todo todo in todos) {
                DateTime? todoDateFrom = todo.dateFrom;
                if (todoDateFrom != null) {
                  DateTime key = DateTime(todoDateFrom.year, todoDateFrom.month, todoDateFrom.day);
                  if (!eventsList.containsKey(key)) {
                    eventsList[key] = [todo];
                  } else {
                    eventsList[key]!.add(todo);
                  }
                }
              }
              String? date = '-';
              if (selected != null) {
                date = formatDate(selected!, settingsProvider.isJP);
              }
              final events = LinkedHashMap<DateTime, List>(
                equals: isSameDay,
                hashCode: getHashCode,
              )..addAll(eventsList);

              List getEventForDay(DateTime day) {
                return events[day] ?? [];
              }

              return Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: itemBackColor,
                      borderRadius: BorderRadius.circular(radiusSize),
                    ),
                    child: TableCalendar(
                      locale: settingsProvider.currentLang,
                      rowHeight: 42,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime(DateTime.now().year + 50, 12, 31),
                      focusedDay: focused,
                      eventLoader: getEventForDay,
                      calendarFormat: calendarFormat,
                      onFormatChanged: (format) {
                        if (calendarFormat != format) {
                          setState(() {
                            calendarFormat = format;
                          });
                        }
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(selected, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(selected, selectedDay)) {
                          setState(() {
                            selected = selectedDay;
                            focused = focusedDay;
                          });
                          getEventForDay(selectedDay);
                        }
                      },
                      onPageChanged: (focusedDay) {
                        focused = focusedDay;
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      availableGestures: AvailableGestures.all,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final weekday = day.weekday;
                          TextStyle? textStyle;
                          if (weekday == DateTime.saturday) {
                            textStyle = const TextStyle(color: Colors.blue);
                          } else if (weekday == DateTime.sunday) {
                            textStyle = const TextStyle(color: Colors.red);
                          }
                          return Center(
                            child: Text(
                              DateFormat.d().format(day),
                              style: textStyle,
                            ),
                          );
                        },
                        dowBuilder: (context, day) {
                          final weekdayString = DateFormat.E(settingsProvider.currentLang).format(day); 
                          if (day.weekday == DateTime.sunday) {
                            return Center(
                              child: Text(
                                weekdayString,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          else if (day.weekday == DateTime.saturday) {
                            return Center(
                              child: Text(
                                weekdayString,
                                style: const TextStyle(color: Colors.blue),
                              ),
                            );
                          }
                          return null;
                        },
                        markerBuilder: <Widget>(context, date, events) {
                          if (events.isNotEmpty) {
                            return Positioned(
                              right: 5,
                              top: 5,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red[300],
                                ),
                                width: 16.0,
                                height: 16.0,
                                child: Center(
                                  child: Text(
                                    '${events.length}',
                                    style: const TextStyle().copyWith(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            date,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      children: [
                        ...getEventForDay(selected!)
                          .map((todo) => TodoItem(todo: todo))
                          .toList(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 74.0),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Todo todo = Todo()
                ..name = ''
                ..dateFrom = selected;
              showOpenModal(
                context,
                title: settingsProvider.isJP ? '新規追加' : 'New',
                content: TodoEdit(mode: 'new', todo: todo)
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }
}