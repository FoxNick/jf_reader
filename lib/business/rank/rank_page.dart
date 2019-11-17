import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './rank_page_state.dart';

class RankPage extends StatelessWidget {
  const RankPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RankPageState>(
      builder: (context) => RankPageState(),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              // key: barKey,
              middle: Text('书库'),
              trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.search),
                  onPressed: () {
                    // Navigator.of(context, rootNavigator: true).pop(context);
                  })),
          child: RankPageContent()),
    );
  }
}

class BookRankListView extends StatelessWidget {
  const BookRankListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 30,
          child:Text('第一序列')
        );
       },
      ),
    );
  }
}

class RankTypeView extends StatelessWidget {
  const RankTypeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height:40,
            alignment: Alignment.center,
            child:Text('玄幻')
          );
        },
      ),
    );
  }
}

class RankPageContent extends StatelessWidget {
  const RankPageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: RankTypeView(),
          ),
          Expanded(child: BookRankListView())
        ],
      ),
    );
  }
}
