import '../../imports.dart';
import 'item.dart';
import 'edit.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);
  @override
  State createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<ShoppingProvider>(context, listen: false).loadShoppings()
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
              settingsProvider.isJP ? '買い物リスト' : 'ShoppingList',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          body: Consumer<ShoppingProvider>(
            builder: (context, shoppingProvider, child) {
              final shoppings = shoppingProvider.shoppings;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: shoppings.isNotEmpty
                      ? ListView(
                          shrinkWrap: true,
                          children: [
                            ...shoppings
                              .map((shopping) => ShoppingItem(shopping: shopping))
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
              Shopping data = Shopping();
                showOpenModal(
                  context,
                  title: settingsProvider.isJP ? '新規追加' : 'New',
                  content: ShoppingEdit(
                    mode: 'new',
                    shopping: data,
                    updated: (response) {
                      if (!response['result']) {
                        showAlertDialog(context, content: response['error']);
                      }
                    },
                  )
                );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }
}