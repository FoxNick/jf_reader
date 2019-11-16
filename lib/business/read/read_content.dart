import 'package:flutter/cupertino.dart';
import 'package:jf_reader/tools/screen.dart';
import 'package:provider/provider.dart';
import 'package:jf_reader/base/chapter/chapter.dart';
import './read_page_state.dart';
import './battery_view.dart';
import 'package:intl/intl.dart';

class ReadContentView extends StatelessWidget {
  const ReadContentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReadPageState state = Provider.of<ReadPageState>(context);
    if (state.isLoading) {
      return Container();
    }
    var format = DateFormat('HH:mm');
    var time = format.format(DateTime.now());
    int pages = state.currentPageOffsets.length;
    ChapterModel pre = state.previousChapter;
    ChapterModel next = state.nextChapter;
    if (pre != null) {
      pages += 1;
    }
    if (next != null) {
      pages += 1;
    }
    return Container(
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: state.pageController,
        itemCount: pages, // 上一章一页，当前章每页，下一章一页
        itemBuilder: (BuildContext context, int index) {
          var page = 0;
          String content = '';
          if (pre != null && index == 0) {
            content = pre.name;
          } else if (index == pages - 1 && next != null) {
            content = next.name;
          } else {
            page = index + 1 - (pre != null ? 1 : 0);
            ContentOffset offset = state.currentPageOffsets[page - 1];
            content = state.currentContent.substring(offset.start, offset.end);
          }

          return GestureDetector(
              onTapUp: state.onTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    15, state.topSafeHeight, 15, state.bottomSafeHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(state.currentChapter.name,
                        style: TextStyle(fontSize: 14, color: state.infoColor)),
                    Expanded(
                        child: Container(
                      color: Color(0x00000000),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: content,
                              style: TextStyle(fontSize: state.fontSize))
                        ]),
                        textAlign: TextAlign.justify,
                      ),
                    )),
                    Row(
                      children: <Widget>[
                        BatteryView(),
                        SizedBox(width: 10),
                        Text(time,
                            style: TextStyle(
                                fontSize: 11, color: state.infoColor)),
                        Expanded(child: Container()),
                        page > 0
                            ? Text('第$page页',
                                style: TextStyle(
                                    fontSize: 11, color: state.infoColor))
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ));
        },
        // onPageChanged: state.onPageChanged,
      ),
    );
  }
}
