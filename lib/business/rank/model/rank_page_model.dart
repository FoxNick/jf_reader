class RankPageModel {
  List<RankCategoryModel> rankCategoryModels;
}
class RankCategoryModel {
  String categoryID = '';
  String categoryName = '';
  List<RankBookModel> books;
}
class RankBookModel {
  String bookName = '';
  String coverUrl = '';
  String desc = '';
  String hot = '';
}