import 'package:intl/intl.dart';
import '../../imports.dart';

class ShoppingEdit extends StatefulWidget  {

  final String mode;
  final Shopping shopping;
  final Function(Map<String, dynamic>)? updated;
  const ShoppingEdit({
    Key? key,
    required this.mode,
    required this.shopping,
    this.updated
  }) : super(key: key);

  @override
  State<ShoppingEdit> createState() => _ShoppingEditState();
}
class _ShoppingEditState extends State<ShoppingEdit> {

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void submit(mode, shopping) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final shoppingProvider = Provider.of<ShoppingProvider>(context, listen: false);
    if (nameController.text.isEmpty) {
      showAlertDialog(context, content: settingsProvider.isJP ? 'タイトルを入力してください。' : 'Please enter your task.');
      return;
    }

    DateTime? date;
    if (dateController.text.isNotEmpty && dateController.text.isNotEmpty) {
      date = combineDateAndTime(dateController.text, '00:00:00');
    }

    // Shoppingクラスのインスタンスを作成
    final Shopping instance = Shopping()
      ..name = nameController.text
      ..date = date
      ..note = noteController.text
      ..isComplete = false
      ..isPointGet = false
      ..createdAt = shopping?.createdAt ?? DateTime.now();
      if (shopping != null && mode == 'edit') {
        instance.id = shopping.id;
      }
    Map<String, dynamic> response = await shoppingProvider.updateShopping(instance);
    cancel();
    if (widget.updated != null) {
      widget.updated!(response);
    }
  }

  void cancel() async {
    if (!mounted) return;
    nameController.clear();
    dateController.clear();
    noteController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = 32;
    double fontSize= 20;
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final mode = widget.mode;
    final shopping = widget.shopping;
    var initialDate = DateTime.now();
    if (shopping.name != null) {
      nameController.text = shopping.name!;
    }
    if (shopping.date != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(shopping.date!);
      initialDate = shopping.date!;
    }
    if (shopping.note != null) {
      noteController.text = shopping.note!;
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
                  Icon(LineIcons.moneyBill, size: fontSize,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: settingsProvider.isJP ? '日付' : 'Date',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            locale: Locale(settingsProvider.isJP ? 'ja' : 'en'),
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 36000)),
                          );
                          if (picked != null) {
                            DateTime dateOnly = DateTime(picked.year, picked.month, picked.day);
                            dateController.text = DateFormat('yyyy-MM-dd').format(dateOnly);
                          }
                        },
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
                submit(mode, shopping);
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