import '../imports.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String content,
  required VoidCallback onClick,
}) async {
  final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  var titleCaption = '確認';
  var cancelCaption = 'キャンセル';
  var doneCaption = 'OK';
  if (!settingsProvider.isJP) {
    titleCaption = 'Check';
    cancelCaption = 'Cancel';
    doneCaption = 'OK';
  }
  final isConfirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titleCaption, style: const TextStyle(fontSize: 16)),
      content: Text(content, style: const TextStyle(fontSize: 18)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelCaption),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(doneCaption),
        ),
      ],
    ),
  );
  if (isConfirmed ?? false) {
    onClick();
  }
}