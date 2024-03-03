import '../imports.dart';

Future<void> showOpenModal(
  BuildContext context, {
  required String title,
  required Widget content,
}) async {
  final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  var backColor = settingsProvider.isDark
    ? const Color.fromARGB(255, 33, 33, 33)
    : Colors.white;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(radiusSize),
              topRight: Radius.circular(radiusSize),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: content,
              ),
            ],
          ),
        ),
      );
    },
  );
}