import 'package:dio/dio.dart';
import 'package:jf_reader/tools/archive/archive.dart';
import 'package:jf_reader/tools/archive/archive_io.dart';
import 'dart:io';
import 'package:jf_reader/tools/file_parser.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:jf_reader/base/base.dart';
import 'dart:developer';

class DownloadManager {
  factory DownloadManager() => _getInstance();
  static DownloadManager get instance => _getInstance();
  static DownloadManager _instance;
  DownloadManager._internal() {
    // 初始化
  }
  static DownloadManager _getInstance() {
    if (_instance == null) {
      _instance = new DownloadManager._internal();
    }
    return _instance;
  }

  loadFromUrl(String url) async {
    if (!url.endsWith('zip') && !url.endsWith('txt')) {
      log('url bad:$url');
    }
    Response<List<int>> rs = await Dio().get<List<int>>(url,
        options: Options(responseType: ResponseType.bytes), //设置接收类型为bytes
        onReceiveProgress: (received, total) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
    );
    String realUrl = rs.realUri.toString();
    var urlHash = realUrl.hashCode;
    var urlFileName = realUrl.split('/').last;
    var cacheDir = (await getTemporaryDirectory()).path;
    if (realUrl.endsWith("zip")) {
      var fileDir = '$cacheDir/$urlHash';
      Directory(fileDir)..create(recursive: true);
      Archive archive = ZipDecoder().decodeBytes(rs.data);
      for (ArchiveFile file in archive) {
        String filename = file.name;
        if (file.isFile) {
          if (filename.endsWith("txt")) {
            List<int> data = file.content;
            if(data is Uint8List) {
              ByteBuffer buffer = data.buffer;
              ByteData byteData = ByteData.view(buffer);
              addBook(byteData, filename, '$urlHash\_${filename.hashCode}');
            }
            else if (data is List<int>) {
              Int32List list = Int32List.fromList(data);
              ByteBuffer buffer = list.buffer;
              ByteData byteData = ByteData.view(buffer);
              addBook(byteData, filename, '$urlHash\_${filename.hashCode}');
            }
          } else {
            log('not handle:$filename');
          }
        } else {
          Directory('$fileDir/' + filename)..create(recursive: true);
        }
      }
    } else if (realUrl.endsWith("txt")) {
      Int32List list = Int32List.fromList(rs.data);
      ByteBuffer buffer = list.buffer;
      ByteData byteData = ByteData.view(buffer);
      addBook(byteData, urlFileName, '$urlHash');
    }
    else{
      log("bad url:$realUrl");
    }
  }

  addBook(ByteData data, String name, String hash) async {

    List<Map<String, String>> chapters = await FileParser.parseWithData(data);
    Book book = Book()
      ..bookID = hash
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
    BookShelfManager.instance.addBook(book);
  }
}
