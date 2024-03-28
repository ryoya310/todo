import 'package:flutter_slidable/flutter_slidable.dart';
import '../../imports.dart';
import 'edit.dart';

class CalculationItem extends StatelessWidget {
  final Calculation calculation;
  const CalculationItem({
    Key? key,
    required this.calculation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculation = this.calculation;
    final calculationProvider = Provider.of<CalculationProvider>(context, listen: false);
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
              autoClose: false,
              onPressed: (BuildContext context) async {
                showConfirmDialog(
                  context,
                  content: settingsProvider.isJP ? '削除しますか？' : 'Do you want to delete it?',
                  onClick: () {
                    calculationProvider.deleteCalculation(calculation.id);
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
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatNumber(calculation.calcData??0),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 24.0)
                    ),
                    Row(
                      children: [
                        Text(
                          calculation.name ?? '-',
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          calculation.note ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          onLongPress: () async {
            showOpenModal(
              context,
              title: settingsProvider.isJP ? '編集' : 'Edit',
              content: CalculationEdit(mode: 'edit', calculation: calculation)
            );
          },
        )
      )
    );
  }
}