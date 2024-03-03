import '../../imports.dart';

class CalculationEdit extends StatefulWidget  {

  final String mode;
  final Calculation calculation;
  final Function(Map<String, dynamic>)? updated;
  const CalculationEdit({
    Key? key,
    required this.mode,
    required this.calculation,
    this.updated
  }) : super(key: key);

  @override
  State<CalculationEdit> createState() => _CalculationEditState();
}
class _CalculationEditState extends State<CalculationEdit> {

  final nameController = TextEditingController();
  final calcDataController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    calcDataController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void editData() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
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
                ),
                child: Container(
                  height: 474,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Calculator(
                    saved: (value) async {
                      calcDataController.text = value;
                      Navigator.of(context).pop(false);
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

  void submit(mode, calculation) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final calculationProvider = Provider.of<CalculationProvider>(context, listen: false);
    if (nameController.text.isEmpty) {
      showAlertDialog(context, content: settingsProvider.isJP ? 'タイトルを入力してください。' : 'Please enter your task.');
      return;
    }
    if (calcDataController.text.isEmpty) {
      showAlertDialog(context, content: settingsProvider.isJP ? '金額を入力してください。' : 'Please enter your amount.');
      return;
    }

    // Calculationクラスのインスタンスを作成
    final Calculation instance = Calculation()
      ..name = nameController.text
      ..note = noteController.text
      ..isComplete = false
      ..isPointGet = false
      ..createdAt = calculation?.createdAt ?? DateTime.now();
      try {
        instance.calcData = double.parse(calcDataController.text);
      } catch (e) {
        instance.calcData = null;
      }
      if (calculation != null && mode == 'edit') {
        instance.id = calculation.id;
      }
    Map<String, dynamic> response = await calculationProvider.updateCalculation(instance);
    cancel();
    if (widget.updated != null) {
      widget.updated!(response);
    }
  }

  void cancel() async {
    if (!mounted) return;
    nameController.clear();
    calcDataController.clear();
    noteController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 32;
    double fontSize= 20;
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final mode = widget.mode;
    final calculation = widget.calculation;
    if (calculation.name != null) {
      nameController.text = calculation.name!;
    }
    if (calculation.calcData != null) {
      calcDataController.text = calculation.calcData!.toString();
    }
    if (calculation.note != null) {
      noteController.text = calculation.note!;
    }

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  const SizedBox(width: 2),
                  Container(
                    width: 4,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight - 2,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? 'タイトル' : 'Title',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.5)
                        ),
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.calculator, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: calcDataController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '金額' : 'Amount',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(LineIcons.edit, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? 'メモ' : 'Note',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                submit(mode, calculation);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(LineIcons.check),
            ),
          ]
        )
      ]
    );
  }
}