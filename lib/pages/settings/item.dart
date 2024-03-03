import '../../imports.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Widget trailing;
  final double boxHeight;

  const SettingItem({
    Key? key,
    required this.title,
    required this.trailing,
    this.boxHeight = 55.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 14),
      decoration: BoxDecoration(
        color: itemBackColor,
        borderRadius: BorderRadius.circular(radiusSize),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 40,
            child: trailing,
          ),
        ),
      ),
    );
  }
}