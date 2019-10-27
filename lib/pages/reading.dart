// 小说阅读页
import 'package:flutter/cupertino.dart';
class ReadingPage extends StatelessWidget {
  static const String route = '/details';

  /**
   * bookID:
   * chapterID:
   */
  final Map<String,String> arguments;

  ReadingPage(this.arguments);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // key: barKey,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child:Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        middle: Text('阅读页'),
      ),
      child: SafeArea(
        child: Text("${arguments["bookID"]}-${arguments["chapterID"]}}"),
      )
    );
  }
}

