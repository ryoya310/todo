import '../../imports.dart';
import 'item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

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
        return Column(
          children: [
            SettingItem(
              title: settingsProvider.isJP ? 'ダークモード' : 'DarkMode',
              trailing: Switch(
                value: (settingsProvider.isDark == true),
                onChanged: (bool value) {
                  settingsProvider.toggleTheme();
                },
              ),
            ),
            SettingItem(
              title: settingsProvider.isJP ? 'Language: Switch to English' : '言語: 日本語に切替',
              trailing: Switch(
                value: (settingsProvider.isJP == true),
                onChanged: (bool value) {
                  settingsProvider.toggleLang();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}