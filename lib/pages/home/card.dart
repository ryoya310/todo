import '../../imports.dart';

class WavePainter extends CustomPainter {
  final double waveAnimationValue;
  WavePainter(this.waveAnimationValue);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height);
    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, size.height - 7 * sin((i / size.width * 2 * pi) + waveAnimationValue));
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CardWidget extends StatefulWidget {
  final String subCaption;
  final String result;
  final Map<String, int> todo;
  final Map<String, int> shopping;

  const CardWidget({
    Key? key,
    required this.subCaption,
    required this.result,
    required this.todo,
    required this.shopping,
  }) : super(key: key);

  @override
  CardWidgetState createState() => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    return Container(
      height: 135.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient( 
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Color.fromARGB(255, 111, 173, 203),
            Color.fromARGB(255, 64, 130, 244),
          ], 
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return CustomPaint(
                    painter: WavePainter(_controller.value * 2 * pi),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.subCaption,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -4),
                            child: const Text(
                              'TODO',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('lib/assets/images/logo.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                LineIcons.sketch,
                                color: Colors.yellowAccent
                              ),
                              const SizedBox(width: 3,),
                              Text(
                                widget.todo['all_complete'].toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ]
                          ),
                          const SizedBox(width: 14,),
                          Row(
                            children: [
                              const Icon(
                                LineIcons.sketch,
                                color: Colors.deepOrange
                              ),
                              const SizedBox(width: 3,),
                              Text(
                                widget.shopping['all_complete'].toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ]
                          ),
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 4),
                            child: Text(
                              settingsProvider.isJP ? '本日のタスク' : 'Today\'s task',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Text(
                              widget.result,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}