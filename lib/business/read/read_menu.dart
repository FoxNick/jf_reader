import 'package:flutter/cupertino.dart';
import 'package:jf_reader/tools/screen.dart';
import 'package:provider/provider.dart';
import './read_page_state.dart';

class BottomItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback callBack;
  BottomItem(this.title, this.icon, this.callBack);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapUp: (_) {
          callBack();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Column(
            children: <Widget>[
              Image.asset(icon),
              SizedBox(height: 5),
              Text(title,
                  style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
            ],
          ),
        ));
  }
}

class ReadMenu extends StatelessWidget {
  const ReadMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReadPageState state = Provider.of<ReadPageState>(context);
    return state.showMenu
        ? Container(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTapUp: state.onTap,
                  child: Container(color: Color(0x00000000)),
                ),
                // Top Menu
                Positioned(
                  top:
                      -Screen.navigationBarHeight * (1 - state.animation.value),
                  // top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: state.paperColor,
                        boxShadow: [
                          BoxShadow(color: Color(0x22000000), blurRadius: 8)
                        ]),
                    height: Screen.navigationBarHeight,
                    padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(context);
                              },
                              child: Container(
                                width: 44,
                                height: Screen.navigationBarHeight,
                                child: Icon(CupertinoIcons.back),
                              )),
                        ),
                        Expanded(child: Container()),
                        // TODO: voice & more config
                        // Container(
                        //   width: 44,
                        //   child: Image.asset('res/read_icon_voice.png'),
                        // ),
                        // Container(
                        //   width: 44,
                        //   child: Image.asset('res/read_icon_more.png'),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Bottom Menu
                Positioned(
                    bottom: -(Screen.bottomSafeHeight + 110) *
                        (1 - state.animation.value),
                    // bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: state.paperColor,
                          boxShadow: [
                            BoxShadow(color: Color(0x22000000), blurRadius: 8)
                          ]),
                      padding: EdgeInsets.only(bottom: state.bottomSafeHeight),
                      child: Column(
                        children: <Widget>[
                          // buildProgressView(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              BottomItem('目录', 'res/read_icon_catalog.png', () {
                                state.setChapterListShow(true);
                              }),
                              BottomItem(
                                  '亮度', 'res/read_icon_brightness.png', () {}),
                              BottomItem('字体', 'res/read_icon_font.png', () {}),
                              BottomItem(
                                  '设置', 'res/read_icon_setting.png', () {}),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )
        : Container();
  }
}
