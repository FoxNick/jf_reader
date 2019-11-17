import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../base/base.dart';
class ShelfPage extends StatelessWidget {
  const ShelfPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookShelfManager manager = Provider.of<BookShelfManager>(context);
    final GlobalKey barKey = GlobalKey();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        // key: barKey,
        middle: Text('我的书架'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child:Icon(CupertinoIcons.add),
          onPressed: () {
            // var height = barKey.currentContext.size.height;
            showCupertinoModalPopup<String>(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: const Text('添加书籍'),
                message: const Text('选择一种添加方式'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('从TXT下载链接导入'),
                    onPressed: () {
                      // Navigator.pop(context, 'Profiteroles');
                      Navigator.of(context,rootNavigator: true).pushNamed('/import');
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('搜索'),
                    onPressed: () {
                      Navigator.pop(context, 'Profiteroles');
                    },
                  ),
                ],

              )
            );
          },
        )
      ),
      child: SafeArea(
        child: bookListView(manager.bookList)
      ),
    );
  }
  Widget noCoverWidget(){
    return Container(
      width:80,
      height:100,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[Text('暂无封面')]
      )
    );
  }
  Widget bookListView(List<Book> bookList){
    if(bookList == null || bookList.length == 0){
      return Center(
        child: Text('书架里空空如也')
      );
    }
    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (BuildContext context, int index) {
        if(bookList.length <= index){
          return Row();
        }
        Book book = bookList[index];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context,rootNavigator: true).pushNamed('/reading',arguments:{
              "bookID":book.bookID,
              "chapterID":book.currentChapterID
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            height: 100.0,
            child: Row(
              children: <Widget>[
                (book.cover != null && book.cover.length > 0) ? ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:  book.cover,
                    width: 80,
                    height: 100,
                    placeholder: (context, url) => noCoverWidget(),
                    errorWidget: (context, url, error) => noCoverWidget(),
                  ),
                ) : noCoverWidget(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(book.bookName),
                        Text('已读到： ${book.currentChapterName}',style: TextStyle(fontSize: 14, color:Global.subtitleGrayColor),overflow: TextOverflow.ellipsis),
                        Text('最新： ${book.latestChapterName}',style: TextStyle(fontSize: 14, color:Global.subtitleGrayColor),overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                )
              ],
            )
          )
        );
     },
    );
  }
}