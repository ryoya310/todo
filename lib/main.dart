import './imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );
  // 最小ウィンドウサイズを設定
  const minSize = Size(400, 600);
  await DesktopWindow.setMinWindowSize(minSize);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider(isar)),
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
              theme: settingsProvider.currentTheme,
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
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 30,
      //   title: const Text(appName, style: TextStyle(fontSize: 20.0),),
      // ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
          MainPageContentComponent(title: 'Dashboard', controller: _motionTabBarController!),
          const TodoPage(),
          MainPageContentComponent(title: 'Dashboard', controller: _motionTabBarController!),
          const CalculatorPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: Footer(controller: _motionTabBarController!),
    );
  }
}

class MainPageContentComponent extends StatelessWidget {
  const MainPageContentComponent({
    required this.title,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String title;
  final MotionTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          const Text('Go to X page programmatically'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('Dashboard Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 2,
            child: const Text('Profile Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 3,
            child: const Text('Settings Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 4,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}