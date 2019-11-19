import './model/rank_page_model.dart';
import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

String gbkDecoder(List<int> responseBytes, RequestOptions options,
    ResponseBody responseBody) {
  String result = gbk.decode(responseBytes);
  return result;
}

Future<RankPageModel> fetchRankPage() async {
  var url = 'http://top.baidu.com/category?c=10&fr=topindex';
  Response rs = await Dio(BaseOptions(responseDecoder: gbkDecoder)).get(url,
      options: Options(responseType: ResponseType.plain), //设置接收类型为bytes
      onReceiveProgress: (received, total) {
    print('$received / $total');
  });
  String result = rs.data;
  return decodeRankPageHtml(result);
}

RankPageModel decodeRankPageHtml(String html) {
  var rankPageModel = RankPageModel();
  List<RankCategoryModel> rankCategoryModels = List<RankCategoryModel>();
  var document = parse(html);
  List<Element> categoryList = document.querySelectorAll('#main .box-cont');
  for (var categoryElement in categoryList) {
    RankCategoryModel categoryModel = RankCategoryModel();
    var titleElement = categoryElement.querySelector('.hd h2');
    if (titleElement != null) {
      categoryModel.categoryID = titleElement.attributes['data'];
      categoryModel.categoryName = titleElement.querySelector('a').innerHtml;

      List<RankBookModel> books = List<RankBookModel>();
      var bookElements = categoryElement.querySelectorAll('.bd .item-list li');
      for (var bookElement in bookElements) {
        RankBookModel bookModel = RankBookModel();
        var titleElement = bookElement.querySelector('.item-hd a');
        if (titleElement != null) {
          bookModel.bookName = titleElement.attributes['title'];
        }
        // var imgElement = bookElement.querySelector('.item-bd .item-img img');
        // if (imgElement != null) {
        //   bookModel.coverUrl = imgElement.attributes['src'];
        // }
        // var descElement = bookElement.querySelector('.item-bd .item-text a');
        // if (descElement != null) {
        //   bookModel.desc = descElement.innerHtml;
        // }
        var hotElement = bookElement.querySelector('.icon-rise,.icon-fall,.icon-fair');
        if (hotElement != null) {
          bookModel.hot = hotElement.innerHtml;
        }
        books.add(bookModel);
      }
      categoryModel.books = books;
      rankCategoryModels.add(categoryModel);
    }
  }
  rankPageModel.rankCategoryModels = rankCategoryModels;
  return rankPageModel;
}
