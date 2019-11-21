import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'book.dart';
import 'package:jf_reader/tools/file_parser.dart';
import 'package:jf_reader/base/chapter/chapter.dart';

const BOOK_SHELF_KEY = "bookList";

class BookShelfManager with ChangeNotifier {
  // 工厂模式
  factory BookShelfManager() => _getInstance();
  static BookShelfManager get instance => _getInstance();
  static BookShelfManager _instance;

  BookShelfManager._internal() {
    // 初始化
    loadData();
  }
  static BookShelfManager _getInstance() {
    if (_instance == null) {
      _instance = new BookShelfManager._internal();
    }
    return _instance;
  }

  List<Book> bookList = [];
  SharedPreferences _prefs;
  // 深拷贝
  getBook(String bookID) {
    int idx = bookList.indexWhere((Book book) => book.bookID == bookID);
    Book localBook;
    if (idx >= 0) {
      localBook = bookList[idx];
      return Book.fromJson(jsonDecode(jsonEncode(localBook)));
    }
    return null;
  }

  updateBook(String bookID, Book book) {
    int idx = bookList.indexWhere((Book book) => book.bookID == bookID);
    if (idx >= 0 && book != null) {
      bookList[idx] = book;
    }
  }

  addBook(Book book) {
    bookList.add(book);
    notifyListeners();
    saveData();
  }

  loadData() async {
    _prefs = await SharedPreferences.getInstance();
    var bookListStr = _prefs.getString(BOOK_SHELF_KEY);
    if (bookListStr != null && bookListStr.length > 0) {
      List<dynamic> decoded = jsonDecode(bookListStr);
      bookList = decoded.map((bookJson) => Book.fromJson(bookJson)).toList();
    } else {
      // generateTestData();
      readTestData();
    }
    notifyListeners();
  }

  saveData() {
    var bookListStr = jsonEncode(bookList);
    _prefs.setString(BOOK_SHELF_KEY, bookListStr);
  }
  // generateTestData(){
  //   List<Book> testData = [];
  //   for (var i = 0; i < 100; i++) {
  //     Book book = Book()
  //       ..bookID = Uuid().v4()
  //       ..bookName = '测试书名$i'
  //       ..cover = 'https://bookcover.yuewen.com/qdbimg/349573/1015648531/180'
  //       ..latestChapterID = "$i"
  //       ..latestChapterName = '测试章节$i'
  //       ..currentChapterID = "0"
  //       ..currentChapterName = '测试章节$i';
  //     testData.add(book);
  //   }
  //   bookList = testData;
  //   notifyListeners();
  //   saveData();

  // }
  readTestData() async {
    String name = '金瓶梅';
    String path = 'res/$name.txt';
    // String name = 'res/test.txt';
    List<Map<String, String>> chapters =
        await FileParser.parseWithLocalFile(path);

    Book book = Book()
      ..bookID = Uuid().v4()
      ..bookName = name
      ..latestChapterID = "${chapters.length - 1}"
      ..latestChapterName = chapters.last["name"]
      ..currentChapterID = "0"
      ..currentChapterName = chapters.first["name"];
    List<ChapterModel> chapterList = chapters
        .asMap()
        .map((index, chapterMap) {
          ChapterModel chapter = ChapterModel()
            ..name = chapterMap["name"]
            ..chapterID = "$index"
            ..bookID = book.bookID;
          chapter.saveContent(chapterMap["content"]);
          return MapEntry(index, chapter);
        })
        .values
        .toList();
    book.chapters = chapterList;
    addBook(book);
  }
}
