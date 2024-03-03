import '../imports.dart';

class ShakingIcon extends StatefulWidget {
  const ShakingIcon({Key? key}) : super(key: key);
  @override
  ShakingIconState createState() => ShakingIconState();
}

class ShakingIconState extends State<ShakingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationZ(_animation.value),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: const Icon(
        LineIcons.sketch,
        color: Colors.lightBlue,
      ),
    );
  }
}
