import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/widgets.dart';
import 'pages/shelf.dart';
import 'model/book_manager.dart';
import 'pages/reading.dart';
void main(){
  return runApp(
    MultiProvider(
      providers: [
        ListenableProvider<BookShelfManager>.value(value: BookShelfManager()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: '咕噜阅读器',
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        "/reading": (context) => ReadingPage(ModalRoute.of(context).settings.arguments)
      },
    );
  }
}
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('res/shelf.png')),
            title: Text('书架'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('res/search.png')),
            title: Text('搜索'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('res/mine.png')),
            title: Text('我的'),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return ShelfPage();
                break;
              default:
                return ShelfPage();
            }
          },
        );
      }
    );
  }
}