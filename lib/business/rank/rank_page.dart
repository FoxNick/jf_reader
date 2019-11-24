import 'package:flutter/cupertino.dart';
import 'package:jf_reader/base/global.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './rank_page_state.dart';
import './model/rank_page_model.dart';

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
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed('/search');
                  })),
          child: RankPageContent()),
    );
  }
}

class BookRankListView extends StatelessWidget {
  const BookRankListView({Key key}) : super(key: key);
  Widget noCoverWidget() {
    return Container(
        width: 80,
        height: 100,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('暂无封面')]));
  }

  @override
  Widget build(BuildContext context) {
    RankPageState state = Provider.of<RankPageState>(context);
    return Container(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () {
              return state.onRefresh();
            },
          ),
          SliverSafeArea(
            top: false, // Top safe area is consumed by the navigation bar.
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  RankBookModel model = state.currentCategoryModel.books[index];
                  return Container(
                      height: 30,
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Text(model.bookName),
                              Expanded(child: Container()),
                              Container(
                                  width: 70,
                                  alignment: Alignment.centerRight,
                                  child: Text(model.hot)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(CupertinoIcons.heart_solid,
                                  color: Color(0xFFFF0000))
                            ],
                          ),
                          onTapUp: (_) {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed('/search',
                                    arguments: model.bookName);
                          }));
                },
                childCount: state.currentCategoryBookCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '来源：百度搜索风云榜',
                    style: Global.rankPageTipTextStyle,
                  ))),
        ],
      ),
    );
  }
}

class RankTypeView extends StatelessWidget {
  const RankTypeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RankPageState state = Provider.of<RankPageState>(context);
    return ListView.builder(
      itemCount: state.categoryCount,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              state.setSelectedIdx(index);
            },
            child: Container(
                height: 50,
                alignment: Alignment.center,
                color: state.selectedCategoryIndex == index
                    ? CupertinoColors.white
                    : Global.translucentColor,
                child: Text(
                  state.rankPageModel.rankCategoryModels[index].categoryName,
                  style: state.selectedCategoryIndex == index
                      ? Global.rankCategorySelectedTextStyle
                      : Global.rankCategoryTextStyle,
                )));
      },
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
            width: 80,
            child: RankTypeView(),
          ),
          Expanded(child: BookRankListView())
        ],
      ),
    );
  }
}
