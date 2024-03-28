import '../../imports.dart';
import 'item.dart';
import 'edit.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);
  @override
  State createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<CalculationProvider>(context, listen: false).loadCalculations()
    );
  }

  void addData() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      // barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(6),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 288,
                  minWidth: 288,
                ),
                child: Container(
                  height: 474,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Calculator(
                    saved: (value) async {
                      Calculation data = Calculation()
                        ..name = ''
                        ..calcData = double.parse(value)
                        ..note = '';
                      showOpenModal(
                        context,
                        title: settingsProvider.isJP ? '新規追加' : 'New',
                        content: CalculationEdit(
                          mode: 'new',
                          calculation: data,
                          updated: (response) {
                            if (response['result']) {
                              Navigator.of(context).pop(false);
                            } else {
                              showAlertDialog(context, content: response['error']);
                            }
                          },
                        )
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 50,
            title: Text(
              settingsProvider.isJP ? '計算記録' : 'CalculationList',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          body: Consumer<CalculationProvider>(
            builder: (context, calculationProvider, child) {
              final calculations = calculationProvider.calculations;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: calculations.isNotEmpty
                      ? ListView(
                          shrinkWrap: true,
                          children: [
                            ...calculations
                              .map((calculation) => CalculationItem(calculation: calculation))
                              .toList(),
                          ],
                        )
                      : Center(
                          child: Text(
                            settingsProvider.isJP ? 'まだデータが登録されていません' : 'No data registered yet',
                          ),
                        ),
                  ),
                ]
              );
            }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              addData();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            child: const Icon(LineIcons.calculator),
          ),
        );
      }
    );
  }
}