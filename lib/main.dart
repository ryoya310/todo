import './imports.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema, CalculationSchema, ShoppingSchema],
    directory: dir.path,
  );
  if (Platform.isAndroid || Platform.isIOS) {
    await _initGoogleMobileAds();
  }
  // ウィンドウサイズを設定
  await DesktopWindow.setWindowSize(const Size(400, 800));
  await DesktopWindow.setMinWindowSize(const Size(400, 800));
  await DesktopWindow.setMaxWindowSize(const Size(600, 1000));

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

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
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
                primarySwatch: Colors.green,
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

class _AddPageState extends State<AddPage> with TickerProviderStateMixin, WidgetsBindingObserver {

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
        children: <Widget>[
          HomePage(motionTabBarController: _motionTabBarController),
          const TodoPage(),
          const ShoppingPage(),
          const CalculatorPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: Footer(controller: _motionTabBarController!),
    );
  }
}