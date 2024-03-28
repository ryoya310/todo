import '../../imports.dart';
import 'chart.dart';

class ItemWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<dynamic> todayItems;
  final dynamic allLength;
  final VoidCallback onPressed;

  const ItemWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.todayItems,
    required this.allLength,
    required this.onPressed,
  }) : super(key: key);

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> with SingleTickerProviderStateMixin {
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
    // リスト
    int itemsCompleteLength = 0;
    for (dynamic item in widget.todayItems) {
      itemsCompleteLength += item.isComplete ? 1 : 0;
    }
    Widget buildWidgets(BuildContext context) {
      int itemCount = widget.todayItems.length;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, i) {
          final items = widget.todayItems[i];
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 25,
                    width: 5,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      items.name ?? '-',
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              if (i < widget.todayItems.length - 1) const SizedBox(height: 10),
            ],
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
        color: itemBackColor,
        borderRadius: BorderRadius.circular(radiusSize),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => widget.onPressed(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0.0),
                    fixedSize: MaterialStateProperty.all(const Size(30.0, 30.0)),
                  ),
                  child: Icon(widget.icon),
                )
              ]
            )
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 縦方向の中央に配置
              children: [
                widget.todayItems.isNotEmpty
                  ? Expanded(
                      child: Row(
                        children: [
                          Expanded(child: 
                            SingleChildScrollView(
                              child: buildWidgets(context)
                            )
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 125,
                            width: 125,
                            child: MyPieChart(
                              color: widget.color,
                              num1: itemsCompleteLength,
                              num2: widget.todayItems.length - itemsCompleteLength
                            )
                          )
                        ]
                      )
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 横方向の中央に配置
                      children: [
                        ElevatedButton(
                          onPressed: () => widget.onPressed(),
                          child: Text(settingsProvider.isJP ? 'データを作成' : 'Create Data'),
                        )
                      ]
                    )
              ]
            ),
          ),
        ]
      )
    );
  }
}