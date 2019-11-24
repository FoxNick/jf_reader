import 'package:flutter/cupertino.dart';
import 'package:jf_reader/base/global.dart';
import 'package:jf_reader/base/base.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './search_page_state.dart';

class SearchPage extends StatelessWidget {
  String initialSearch = "";
  SearchPage(this.initialSearch);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageState>(
        builder: (context) => SearchPageState(initialSearch),
        child: Container(
            color: Global.searchPageBackgroundColor,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SearchTopBar(),
                  Expanded(
                    child: SearchResultListView(),
                  )
                ],
              ),
            )));
  }
}

class SearchTopBar extends StatelessWidget {
  const SearchTopBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchPageState state = Provider.of<SearchPageState>(context);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Global.searchPageTextFieldBGColor,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5, height: 30),
                  Icon(
                    CupertinoIcons.search,
                    color: Global.searchPageTextFieldPlaceholderColor,
                    size: 20,
                  ),
                  Expanded(
                      child: CupertinoTextField(
                    controller: state.textController,
                    autofocus: true,
                    decoration: BoxDecoration(),
                    cursorColor: Color(0xffcccccc),
                    cursorWidth: 2,
                    style: Global.searchPageTextFieldTextStyle,
                    // onChanged: (content) {
                    //   // state.currentContent = content;
                    // },
                    onSubmitted: (content) {
                      state.searchContent = content;
                      state.searchCurrentKeyword();
                    },
                  ))
                ],
              ),
            )),
        SizedBox(width: 10),
        CupertinoButton(
            child: Text(
              '取消',
              style: Global.searchCancelTextStyle,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(context);
            },
            minSize: 0,
            padding: EdgeInsets.all(0)),
      ]),
    );
  }
}

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({Key key}) : super(key: key);

  Widget noCoverWidget() {
    return Container(
        width: 80,
        height: 100,
        alignment: Alignment.center,
        child: Text('暂无封面'));
  }

  @override
  Widget build(BuildContext context) {
    SearchPageState state = Provider.of<SearchPageState>(context);
    List<SearchResultModel> models = List();
    state.resultModelsMap.forEach((key, value) {
      models.addAll(value);
    });
    return Container(
      child: ListView.builder(
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          SearchResultModel model = models[index];
          return Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: CupertinoColors.white,
              ),
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Container(width: 15),
                  (model.coverUrl.length > 0)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(2.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: model.coverUrl,
                            width: 80,
                            height: 100,
                            placeholder: (context, url) => noCoverWidget(),
                            errorWidget: (context, url, error) =>
                                noCoverWidget(),
                          ),
                        )
                      : noCoverWidget(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(model.name),
                          Text(model.author,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Global.subtitleGrayColor),
                              overflow: TextOverflow.ellipsis),
                          Text(
                            model.latest,
                            style: TextStyle(
                                fontSize: 14, color: Global.subtitleGrayColor),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                  model.isLoading
                      ? CupertinoActivityIndicator(radius: 20)
                      : (BookShelfManager().hasBook(model.bookID)
                          ? Text('已加入')
                          : CupertinoButton(
                              child: Icon(CupertinoIcons.add_circled),
                              onPressed: () {
                                state.addBook(model);
                              },
                              minSize: 0,
                              padding: EdgeInsets.all(0))),
                  Container(width: 15)
                ],
              ));
        },
      ),
    );
  }
}
