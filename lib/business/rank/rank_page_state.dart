import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jf_reader/tools/file_parser.dart';
import 'package:jf_reader/base/base.dart';
import 'dart:developer';
import './rank_page_fetcher.dart';
import './model/rank_page_model.dart';

class RankPageState with ChangeNotifier {
  RankPageState() {
    onRefresh();
  }
  RankPageModel rankPageModel = RankPageModel();
  int selectedCategoryIndex = 0;
  int get categoryCount {
    return rankPageModel.rankCategoryModels != null
        ? rankPageModel.rankCategoryModels.length
        : 0;
  }

  RankCategoryModel get currentCategoryModel {
    if (rankPageModel.rankCategoryModels == null) {
      return null;
    }
    if (selectedCategoryIndex >= rankPageModel.rankCategoryModels.length) {
      return null;
    }
    return rankPageModel.rankCategoryModels[selectedCategoryIndex];
  }

  int get currentCategoryBookCount {
    var model = currentCategoryModel;
    if (model != null) {
      return model.books.length;
    }
    return 0;
  }

  onRefresh() async {
    log('rank page on refresh');
    rankPageModel = await fetchRankPage();
    notifyListeners();
    return;
  }

  setSelectedIdx(int newIndex) {
    selectedCategoryIndex = newIndex;
    notifyListeners();
  }
}
