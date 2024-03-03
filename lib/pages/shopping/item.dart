import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../imports.dart';
import 'edit.dart';

class ShoppingItem extends StatelessWidget {
  final Shopping shopping;
  const ShoppingItem({
    Key? key,
    required this.shopping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopping = this.shopping;
    final shoppingProvider = Provider.of<ShoppingProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: itemBackColor,
        borderRadius: BorderRadius.circular(radiusSize),
      ),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (BuildContext context) {
                shoppingProvider.completeShoppingById(shopping.id, shopping.isComplete);
              },
              backgroundColor: shopping.isComplete ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              icon: shopping.isComplete ? LineIcons.arrowLeft : LineIcons.check,
            ),
            SlidableAction(
              autoClose: false,
              onPressed: (BuildContext context) async {
                showConfirmDialog(
                  context,
                  content: settingsProvider.isJP ? '削除しますか？' : 'Do you want to delete it?',
                  onClick: () {
                    shoppingProvider.deleteShopping(shopping.id);
                    Slidable.of(context)?.close();
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radiusSize),
                bottomRight: Radius.circular(radiusSize),
              ),
              icon: LineIcons.alternateTrashAlt,
            ),
          ],
        ),
        child: ListTile(
          hoverColor: Colors.transparent,
          title: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                color: Colors.deepOrange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopping.name ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 28.0)
                    ),
                    Row(
                      children: [
                        Text(
                          shopping.date != null ? DateFormat('yyyy/MM/dd').format(shopping.date!) : '-',
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          shopping.note ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          trailing: Visibility(
            visible: shopping.isComplete,
            child: const SizedBox(
              child: Icon(
                LineIcons.sketch,
                color: Colors.deepOrange
              ),
            ),
          ),
          onLongPress: () async {
            showOpenModal(
              context,
              title: settingsProvider.isJP ? '編集' : 'Edit',
              content: ShoppingEdit(mode: 'edit', shopping: shopping)
            );
          },
        )
      )
    );
  }
}