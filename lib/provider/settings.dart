import '../imports.dart';

class SettingsProvider extends ChangeNotifier {
  bool isLoading = true;
  // テーマ
  Brightness currentTheme = Brightness.dark;
  bool isDark = true;

  // 言語
  String currentLang = 'ja_JP';
  bool isJP = true;

  // 初期読込
  Future<void> loadInitialValues() async {
    Map<String, dynamic> settings = await readSettings();
    // テーマ
    if (settings['theme'] != null) {
      currentTheme = settings['theme'] == 'dark' ? Brightness.dark : Brightness.light;
      isDark = settings['theme'] == 'dark';
    }
    // 言語
    if (settings['lang'] != null) {
      currentLang = settings['lang'] == 'ja' ? 'ja_JP' : 'en';
      isJP = settings['lang'] == 'ja';
    }
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
  }

  // テーマ変更 [保存]
  Future<void> toggleTheme() async {
    isDark = !isDark;
    currentTheme = isDark ? Brightness.dark : Brightness.light;
    String saveTheme = isDark ? 'dark' : 'light';
    await saveSettings({'theme': saveTheme});
    notifyListeners();
  }

  // 言語変更 [保存]
  Future<void> toggleLang() async {
    isJP = !isJP;
    currentLang = isJP ? 'ja_JP' : 'en';
    String saveTheme = isJP ? 'ja' : 'en';
    await saveSettings({'lang': saveTheme});
    notifyListeners();
  }
}

// JSONを保存
Future<void> saveSettings(Map<String, dynamic> newSettings) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory('${directory.path}/$appName');
    if (!await appDir.exists()) {
      await appDir.create();
    }
    final file = File('${appDir.path}/settings.json');

    Map<String, dynamic> currentSettings = {};
    // 既存の設定を読む
    if (await file.exists()) {
      String contents = await file.readAsString();
      currentSettings = contents != '' ? jsonDecode(contents) : {};
    }

    // 新しい設定で既存の設定を上書き
    currentSettings.addAll(newSettings);

    await file.writeAsString(jsonEncode(currentSettings));
  } catch (e) {
    debugPrint("Error saving settings: $e");
  }
}

// JSONを読込
Future<Map<String, dynamic>> readSettings() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory('${directory.path}/$appName');
    if (!await appDir.exists()) {
      await appDir.create();
    }
    final file = File('${appDir.path}/settings.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } else {
      String defaultSettings = await rootBundle.loadString('lib/assets/json/settings.json');
      await file.writeAsString(defaultSettings);
      return jsonDecode(defaultSettings);
    }
  } catch (e) {
    return {};
  }
}