import 'package:fl_chart/fl_chart.dart';
import '../../imports.dart';

class MyPieChart extends StatefulWidget {
  final Color color;
  final int num1;
  final int num2;
  const MyPieChart({
    Key? key,
    required this.color,
    required this.num1,
    required this.num2,
  }) : super(key: key);
  @override
  MyPieChartState createState() => MyPieChartState();
}

class MyPieChartState extends State<MyPieChart> {
  late double num1;
  late double num2;
  @override
  void initState() {
    super.initState();
    num1 = widget.num1.toDouble();
    num2 = widget.num2.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
        double size = constraints.maxHeight;

        String centerText = settingsProvider.isJP
          ? num2 == 0 ? '達成' : '残: ${num2.toInt()}'
          : num2 == 0 ? 'Complete' : 'Rem: ${num2.toInt()}';

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        value: num1,
                        color: widget.color,
                        title: '',
                        radius: size * 0.12,
                      ),
                      PieChartSectionData(
                        value: num2,
                        color: Colors.grey,
                        title: '',
                        radius: size * 0.12,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: size * 0.35,
                  ),
                ),
                num2 == 0
                  ? Text(
                      centerText,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Horizon',
                        color: widget.color
                      )
                    )
                  : Text(
                      centerText,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Horizon',
                        color: widget.color
                      )
                    )
              ],
            ),
          ),
        );
      },
    );
  }
}