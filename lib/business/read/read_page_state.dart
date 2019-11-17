import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jf_reader/base/base.dart';
import 'package:jf_reader/tools/screen.dart';
import 'package:flutter/animation.dart';
import 'dart:developer';

const double topOffset = 20;
const double bottomOffset = 20;

class ReadPageState with ChangeNotifier {
  double fontSize = 20.0;
  double topSafeHeight = 0;
  double bottomSafeHeight = 0;
  Color infoColor = Color(0xFF000000);
  Color paperColor = Color(0xFFF5F5F5);

  bool isLoading = true;
  bool showMenu = false;
  bool showChapters = false;
  PageController pageController = PageController(keepPage: false);

  String bookID;
  String chapterID;
  String currentContent;
  Book get currentBook {
    Book book = BookShelfManager().getBook(bookID);
    return book;
  }

  ChapterModel currentChapter;
  List<ContentOffset> currentPageOffsets;

  //动画
  AnimationController animationController;
  Animation animation;

  ReadPageState(String bookID, String chapterID, BuildContext context) {
    this.bookID = bookID;
    this.chapterID = chapterID;
    setup(context);
  }
  setup(BuildContext context) async {
    topSafeHeight = Screen.topSafeHeight;
    bottomSafeHeight = Screen.bottomSafeHeight;
    await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    await gotoChapter(chapterID);
    var state = Navigator.of(context);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: state);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      notifyListeners();
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        showMenu = false;
        notifyListeners();
      }
    });
    pageController.addListener(onScroll);
  }

  // 章节内容加载
  loadCurrentChapter() async {
    isLoading = true;
    Book book = BookShelfManager().getBook(bookID);
    currentChapter = book.getChapter(chapterID);
    currentContent = await currentChapter.getContent();
    var contentHeight = Screen.height -
        topSafeHeight -
        topOffset -
        bottomSafeHeight -
        bottomOffset -
        20;
    var contentWidth = Screen.width - 15 - 10;
    currentPageOffsets = currentChapter.getPageOffsets(
        currentContent, contentHeight, contentWidth, 20.0);

    isLoading = false;
    notifyListeners();
    if (book.currentChapterID != chapterID) {
      book.currentChapterID = chapterID;
      book.currentChapterName = currentChapter.name;
      BookShelfManager().updateBook(bookID, book);
    }
  }

  ChapterModel get nextChapter {
    Book book = BookShelfManager().getBook(bookID);
    return book.nextChapter(chapterID);
  }

  ChapterModel get previousChapter {
    Book book = BookShelfManager().getBook(bookID);
    return book.previousChapter(chapterID);
  }

  // 页面点击
  onTap(TapUpDetails details) {
    Offset position = details.globalPosition;
    double xRate = position.dx / Screen.width;
    if (showMenu == true) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      animationController.reverse();
      // showMenu = false;
      notifyListeners();
    } else if (xRate > 0.3 && xRate < 0.7) {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      animationController.forward();
      showMenu = true;
      notifyListeners();
    } else if (xRate >= 0.7) {
      pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      pageController.previousPage(
          duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  setChapterListShow(bool isShow) {
    showChapters = isShow;
    notifyListeners();
  }

  onScroll() {
    // TODO: cache pre/next/pages, or throttle it
    double page = pageController.page;
    ChapterModel pre = this.previousChapter;
    ChapterModel next = this.nextChapter;
    int pages = currentPageOffsets.length;
    if (pre != null) {
      pages += 1;
    }
    if (next != null) {
      pages += 1;
    }
    if (pre != null && page <= 0) {
      log('上一章');
      gotoChapter(pre.chapterID, istail: true);
    } else if (page >= pages - 1 && next != null) {
      log('下一章');
      gotoChapter(next.chapterID, istail: false);
    }
  }

  gotoChapter(String chapterID, {istail: false}) async {
    this.chapterID = chapterID;
    await loadCurrentChapter();
    notifyListeners();
    int page = 0;
    if (istail) {
      page = this.currentPageOffsets.length - 1;
    }
    if (this.previousChapter != null) {
      page += 1;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        this.pageController.jumpToPage(page);
        notifyListeners();
      }
    });
  }
}
