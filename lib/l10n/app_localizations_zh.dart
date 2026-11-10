// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => '新便笺 (Ctrl+N)';

  @override
  String get deleteNote => '删除便笺 (Ctrl+D)';

  @override
  String get settings => '纸张和文字';

  @override
  String get backToNote => '返回便笺';

  @override
  String get foldNote => '收起或展开便笺';

  @override
  String get noteText => '便笺内容';

  @override
  String get writeHere => '写点什么…';

  @override
  String get emptyNote => '空白便笺';

  @override
  String get paper => '纸张';

  @override
  String get colorYellow => '黄色';

  @override
  String get colorBlue => '蓝色';

  @override
  String get colorGreen => '绿色';

  @override
  String get colorPink => '粉色';

  @override
  String get colorPurple => '紫色';

  @override
  String get colorWhite => '白色';

  @override
  String get font => '字体';

  @override
  String get fontHand => '手写';

  @override
  String get fontPlain => '普通';

  @override
  String get textSize => '文字大小';

  @override
  String get sizeSmall => '小';

  @override
  String get sizeMedium => '中';

  @override
  String get sizeLarge => '大';

  @override
  String get sizeHuge => '特大';

  @override
  String get window => '窗口';

  @override
  String get onTop => '保持在其他窗口上方';

  @override
  String get translucent => '半透明';

  @override
  String get format => '格式';

  @override
  String get bold => '粗体 (Ctrl+B)';

  @override
  String get italic => '斜体 (Ctrl+I)';

  @override
  String get underline => '下划线 (Ctrl+U)';

  @override
  String get strike => '删除线 (Ctrl+T)';

  @override
  String get bullets => '列表 (Ctrl+Shift+L)';

  @override
  String get biggerText => '放大文字 (Ctrl+Shift+>)';

  @override
  String get smallerText => '缩小文字 (Ctrl+Shift+<)';

  @override
  String get deleteQuestion => '删除这张便笺？';

  @override
  String get dontAskAgain => '不再询问';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get resize => '调整大小';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version。没有广告，没有遥测，也不需要账号。';
  }

  @override
  String get aboutLegal => '代码采用 Apache 2.0 许可证。字体采用 SIL Open Font License。';

  @override
  String get tips => '双击顶部的条可以收起便笺。Ctrl+Z 撤销，Ctrl+Y 重做。';
}
