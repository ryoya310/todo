import '../../imports.dart';
import 'card.dart';
import 'item.dart';

class HomePage extends StatefulWidget {
  final MotionTabBarController? motionTabBarController;
  const HomePage({
    Key? key,
    this.motionTabBarController
  }): super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final todoProvider = Provider.of<TodoProvider>(context, listen: false);
        final shopProvider = Provider.of<ShoppingProvider>(context, listen: false);
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            todoProvider.getTodoByToday(),
            todoProvider.getTodoByComplete(),
            shopProvider.getShoppingByToday(),
            shopProvider.getShoppingByComplete(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final results = snapshot.data!;
            // 今日のTODOリスト
            final List<dynamic> todoTodayList = results[0].cast<Todo>();
            int todoCompleteLength = 0;
            for (Todo todo in todoTodayList) {
              todoCompleteLength += todo.isComplete ? 1 : 0;
            }
            final todoAllLength = results[1].length;

            // 今日の買い物リスト
            final List<dynamic> shoppingTodayList = results[2].cast<Shopping>();
            int shoppingCompleteLength = 0;
            for (Shopping shopping in shoppingTodayList) {
              shoppingCompleteLength += shopping.isComplete ? 1 : 0;
            }
            final shoppingAllLength = results[3].length;

            // まとめ
            final completeLength = todoCompleteLength + shoppingCompleteLength;
            final allCompleteLength = todoTodayList.length + shoppingTodayList.length;
            String result = '$completeLength / $allCompleteLength';
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: itemBackColor,
                        borderRadius: BorderRadius.circular(radiusSize),
                      ),
                      child: CardWidget(
                        subCaption: formatDate(DateTime.now(), settingsProvider.isJP),
                        result: result,
                        todo: {
                          'today_complete': todoCompleteLength,
                          'today_all': todoTodayList.length,
                          'all_complete': todoAllLength,
                        },
                        shopping: {
                          'today_complete': shoppingCompleteLength,
                          'today_all': shoppingTodayList.length,
                          'all_complete': shoppingAllLength,
                        },
                      )
                    ),
                    ItemWidget(
                      title: settingsProvider.isJP ? 'やることリスト' : 'TodoList',
                      icon: LineIcons.tasks,
                      color: Colors.yellow,
                      todayItems: todoTodayList,
                      allLength: todoAllLength,
                      onPressed: () {
                        widget.motionTabBarController?.index = 1;
                      }
                    ),
                    ItemWidget(
                      title: settingsProvider.isJP ? '買い物リスト' : 'ShoppingList',
                      icon: LineIcons.shoppingCartArrowDown,
                      color: Colors.deepOrange,
                      todayItems: shoppingTodayList,
                      allLength: shoppingAllLength,
                      onPressed: () {
                        widget.motionTabBarController?.index = 2;
                      }
                    ),
                  ],
                )
              )
            );
          },
        );
      },
    );
  }
}