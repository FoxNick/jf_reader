// 小说阅读页
import 'package:flutter/cupertino.dart';
import 'package:jf_reader/tools/screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './read_page_state.dart';
import './read_content.dart';
import './read_menu.dart';

class ReadingPage extends StatelessWidget {
  static const String route = '/reading';

  /**
   * bookID:
   * chapterID:
   */
  String bookID;
  String chapterID;

  ReadingPage(arguments){
    bookID = arguments['bookID'];
    chapterID = arguments['chapterID'];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReadPageState>(
      builder: (context) => ReadPageState(bookID,chapterID,context),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            Positioned(left: 0, top: 0, right: 0, bottom: 0, child: Image.asset('res/read_bg.png', fit: BoxFit.cover)),
            ReadContentView(),
            ReadMenu()
          ],
        ),
      ),
    );
  }
}