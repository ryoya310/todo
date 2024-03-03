import '../imports.dart';

class Footer extends StatelessWidget {
  final MotionTabBarController controller;
  const Footer({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var labels = ['Home', 'Todo', 'Shopping', 'Calculation', 'Settings'];
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
      tabSize: 32,
      tabBarHeight: 46,
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Colors.blue[600],
      tabIconSize: 22.0,
      tabIconSelectedSize: 24.0,
      tabSelectedColor: Colors.blue[900],
      onTabItemSelected: (int value) async {
        controller.index = value;
      },
    );
  }
}