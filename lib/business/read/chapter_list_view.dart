import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:jf_reader/base/base.dart';
import 'package:jf_reader/tools/screen.dart';
import './read_page_state.dart';

class ChapterListView extends StatelessWidget {
  const ChapterListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReadPageState state = Provider.of<ReadPageState>(context);
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: 0,
          left: state.showChapters ? 0 : Screen.width,
          bottom: 0,
          width: Screen.width,
          child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  // key: barKey,
                  middle: Text(state.currentBook.bookName),
                  leading: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(CupertinoIcons.back),
                      onPressed: () {
                        // var height = barKey.currentContext.size.height;
                        state.setChapterListShow(false);
                      })),
              child: ListView.builder(
                itemCount: state.currentBook.chapters.length,
                itemBuilder: (BuildContext context, int index) {
                  ChapterModel chapter = state.currentBook.chapters[index];
                  return Container(
                    color: CupertinoColors.white,
                    child: GestureDetector(
                      onTapUp: (_){
                        state.gotoChapter(chapter.chapterID);
                        state.setChapterListShow(false);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        height: 40,
                        child: Text(chapter.name)
                      ),
                    ),
                  );
               },
              ),),
        )
      ],
    );
  }
}
