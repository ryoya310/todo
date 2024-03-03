import '../imports.dart';

Future<void> showAlertDialog(
  BuildContext context, {
  required String content,
  String? align = 'center',
}) async {

  MainAxisAlignment getMainAxisAlignment(String? align) {
    switch (align) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.center;
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      var errorCaption = 'エラー';
      var doneCaption = 'OK';
      if (!settingsProvider.isJP) {
        errorCaption = 'Error';
        doneCaption = 'OK';
      }
      return Column(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          AlertDialog(
            title: Text(errorCaption, style: const TextStyle(color: Colors.red, fontSize: 16)),
            content: Text(content, style: const TextStyle(fontSize: 18)),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            actions: <Widget>[
              TextButton(
                child: Text(doneCaption),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
