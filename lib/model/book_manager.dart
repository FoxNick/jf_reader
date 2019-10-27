import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'book.dart';
import '../tools/file_parser.dart';
import './chapter_content_manager.dart';

const BOOK_SHELF_KEY = "bookList";
class BookShelfManager with ChangeNotifier {
  List<Book> bookList = [];
  // Map<String,Map<int,ChapterModel>> chapterCacheMap = {};

  SharedPreferences _prefs;
  BookShelfManager(){
    loadData();
  }
  addBook(Book book) {
    bookList.add(book);
    notifyListeners();
    saveData();
  }
  addChapter(ChapterModel chapter) {
    
  }
  loadData() async {
    _prefs = await SharedPreferences.getInstance();
    var bookListStr = _prefs.getString(BOOK_SHELF_KEY);
    if(bookListStr != null && bookListStr.length > 0){
      List<dynamic> decoded = jsonDecode(bookListStr);
      bookList = decoded.map((bookJson)=>Book.fromJson(bookJson)).toList();
    }
    else{
      // generateTestData();
      readTestData();
    }
    notifyListeners();
  }
  saveData(){
    var bookListStr = jsonEncode(bookList);
    _prefs.setString(BOOK_SHELF_KEY, bookListStr);
  }
  generateTestData(){
    List<Book> testData = [];
    for (var i = 0; i < 100; i++) {
      Book book = Book()
        ..bookID = Uuid().v4()
        ..bookName = '测试书名$i'
        ..cover = 'https://bookcover.yuewen.com/qdbimg/349573/1015648531/180'
        ..latestChapterID = "$i"
        ..latestChapterName = '测试章节$i'
        ..currentChapterID = "0"
        ..currentChapterName = '测试章节$i';
      testData.add(book);
    }
    bookList = testData;
    notifyListeners();
    saveData();
    
  }
  readTestData() async {
    String name = '金瓶梅';
    String path = 'res/$name.txt';
    // String name = 'res/test.txt';
    List<Map<String,String>> chapters = await FileParser.parseWithLocalFile(path);

    Book book = Book()
        ..bookID = Uuid().v4()
        ..bookName = name
        ..cover = 'https://bookcover.yuewen.com/qdbimg/349573/1015648531/180'
        ..latestChapterID = "${chapters.length - 1}-${chapters.last["name"]}"
        ..latestChapterName = chapters.last["name"]
        ..currentChapterID = "0-${chapters.last["name"]}"
        ..currentChapterName = chapters.first["name"];
    List<ChapterModel> chapterList = chapters.asMap().map((index,chapterMap){
      ChapterModel chapter = ChapterModel()
                    ..name = chapterMap["name"]
                    ..chapterID = "$index-${chapters.last["name"]}"
                    ..bookID = book.bookID;
      ChapterContentManager.instance.saveChapterContent(bookID: book.bookID,chapterID: chapter.chapterID,content: chapterMap["content"]);
      return MapEntry(index, chapter);
    }).values.toList();
    book.chapters = chapterList;
    addBook(book);
  }
}