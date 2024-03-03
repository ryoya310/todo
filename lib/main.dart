import './imports.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [TodoSchema, CalculationSchema, ShoppingSchema],
      directory: dir.path,
    );
    final now = DateTime.now();
    final todos = await isar.todos.filter().dateFromLessThan(now).and().dateToGreaterThan(now).findAll();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    for (final todo in todos) {
      var androidDetails = const AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.high,
        priority: Priority.high,
      );
      var iOSDetails = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidDetails, iOS: iOSDetails);
      await flutterLocalNotificationsPlugin.show(
        todo.id, // 通知ID
        'タスク通知', // 通知タイトル
        '${todo.name}の時間です', // 通知本文
        platformChannelSpecifics, // 通知の詳細設定
      );
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema, CalculationSchema, ShoppingSchema],
    directory: dir.path,
  );
  // 最小ウィンドウサイズを設定
  const minSize = Size(400, 600);
  await DesktopWindow.setMinWindowSize(minSize);

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );
  // Workmanager().registerPeriodicTask(
  //   "uniqueName", 
  //   "simpleTask",
  //   frequency: const Duration(minutes: 1),
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider(isar)),
        ChangeNotifierProvider(create: (context) => CalculationProvider(isar)),
        ChangeNotifierProvider(create: (context) => ShoppingProvider(isar)),
      ],
      child: MyApp(isar: isar),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return FutureBuilder(
          future: settingsProvider.loadInitialValues(),
          builder: (context, snapshot) {
            if (settingsProvider.isLoading) {
              return MaterialApp(
                home: Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 147, 200, 207),
                              Color.fromARGB(200, 228, 239, 233),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                        child: Center(
                          child: LoadingAnimationWidget.stretchedDots(
                            color: thmmeColor,
                            size: 100,
                          ),
                        ),
                      ),
                    ]
                  )
                ),
              );
            }
            return MaterialApp(
              title: appName,
              theme: ThemeData(
                brightness: settingsProvider.currentTheme,
                fontFamily: 'Noto_Sans_JP_Regular',
              ),
              home: AddPage(isar: isar),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ja'),
              ],
            );
          },
        );
      }
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.isar}) : super(key: key);
  final Isar isar;
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with TickerProviderStateMixin {

  MotionTabBarController? _motionTabBarController;
  @override
  void initState() {
    super.initState();
    initialization();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: const <Widget>[
          HomePage(),
          TodoPage(),
          ShoppingPage(),
          CalculatorPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Footer(controller: _motionTabBarController!),
    );
  }
}