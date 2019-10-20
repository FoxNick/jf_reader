import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'book.dart';
import '../tools/file_parser.dart';

const BOOK_SHELF_KEY = "bookList";
class BookShelfManager with ChangeNotifier {
  List<Book> bookList = [];
  // Map<String,Map<int,ChapterModel>> chapterCacheMap = {};

  SharedPreferences _prefs;
  var isLoading = false;
  BookShelfManager(){
    isLoading = true;
    loadData();
  }
  addBook(Book book) {
    bookList.add(book);
    notifyListeners();
    saveData();
  }
  addChapter(ChapterModel chapter) {
    saveChapter(chapter);
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
    isLoading = false;
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
        ..latestChapter = i
        ..latestChapterName = '测试章节$i'
        ..currentChapter = 0
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
    List<ChapterModel> chapters = await FileParser.parseWithLocalFile(path);
    Book book = Book()
        ..bookID = Uuid().v4()
        ..bookName = name
        ..cover = 'https://bookcover.yuewen.com/qdbimg/349573/1015648531/180'
        ..latestChapter = chapters.last.index
        ..latestChapterName = chapters.last.name
        ..currentChapter = chapters.first.index
        ..currentChapterName = chapters[0].name;
    addBook(book);
    chapters = chapters.map((chapter){
      chapter.bookID = book.bookID;
      return chapter;
    }).toList();
    for (var chapter in chapters) {
      saveChapter(chapter);
    }
  }
  checkBookDir(String bookID) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String bookDir = '$dir/$bookID';
    Directory directory = Directory(bookDir);
    bool isExist = await directory.exists();
    if (!isExist) {
      await directory.create();
    }
  }
  saveChapter(ChapterModel model) async {
    await checkBookDir(model.bookID);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File chapterFile = new File('$dir/${model.bookID}/${model.index}');
    await chapterFile.writeAsString(model.content);
  }
  readChapter(String bookID,int chapterID) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    try {
      File chapterFile = new File('$dir/$bookID/$chapterID');
      String contents = await chapterFile.readAsString();
      return contents;
    } catch (e) {
      return '';
    }

  }
}