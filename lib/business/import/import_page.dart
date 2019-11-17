// 导入小说页
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './import_page_state.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImportPageState>(
      builder: (context) => ImportPageState(),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              // key: barKey,
              middle: Text('导入书籍'),
              leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.back),
                  onPressed: () {
                    // var height = barKey.currentContext.size.height;
                    Navigator.of(context, rootNavigator: true).pop(context);
                  })),
          child: ImportPageContent()),
    );
  }
}

class ImportPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImportPageState state = Provider.of<ImportPageState>(context);
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(height: 60),
          Container(
            height: 40,
              color: CupertinoColors.white,
              child: Row(
                children: <Widget>[
                  Container(width: 20),
                  Text('链接：'),
                  Expanded(
                      child: CupertinoTextField(
                        placeholder: '请输入链接，支持zip和txt',
                        onChanged: (content) {
                          state.currentContent = content;
                        },
                      ),
                      flex: 1),
                ],
              )),
          CupertinoButton(
            child: Text("确认"),
            onPressed: () {
              state.loadFromUrl(state.currentContent);
            },
          )
        ],
      ),
    );
  }
}
