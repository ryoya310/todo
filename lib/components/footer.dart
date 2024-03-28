import '../imports.dart';

class Footer extends StatelessWidget {
  final MotionTabBarController controller;
  const Footer({Key? key, required this.controller}): super(key: key);
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    var labels = settingsProvider.isJP
      ? ['Home', 'Todo', 'Shop', 'Calc', 'Settings']
      : ['Home', 'Todo', 'Shop', 'Calc', 'Settings'];

    return MotionTabBar(
      controller: controller,
      initialSelectedTab: 'Home',
      useSafeArea: true,
      labels: labels,
      icons: const [
        LineIcons.home,
        LineIcons.tasks,
        LineIcons.shoppingCartArrowDown,
        LineIcons.calculator,
        LineIcons.cog
      ],
      tabSize: 30,
      tabBarHeight: 40,
      textStyle: const TextStyle(
        fontSize: 10,
        color: Colors.blue,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Colors.blue[600],
      tabIconSize: 20.0,
      tabIconSelectedSize: 22.0,
      tabSelectedColor: Colors.blue,
      onTabItemSelected: (int value) async {
        controller.index = value;
      },
    );
  }
}