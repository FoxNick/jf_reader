import 'package:flutter/cupertino.dart';
import 'package:jf_reader/base/global.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './search_page_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageState>(
        builder: (context) => SearchPageState(),
        child: Container(
            color: Global.searchPageBackgroundColor,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SearchTopBar(),
                  Expanded(
                    child: Container(),
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
