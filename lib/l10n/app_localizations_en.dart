// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'New note (Ctrl+N)';

  @override
  String get deleteNote => 'Delete note (Ctrl+D)';

  @override
  String get settings => 'Paper and text';

  @override
  String get backToNote => 'Back to the note';

  @override
  String get foldNote => 'Fold or unfold the note';

  @override
  String get noteText => 'Note text';

  @override
  String get writeHere => 'Write something…';

  @override
  String get emptyNote => 'Empty note';

  @override
  String get paper => 'Paper';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorWhite => 'White';

  @override
  String get font => 'Font';

  @override
  String get fontHand => 'Handwritten';

  @override
  String get fontPlain => 'Plain';

  @override
  String get textSize => 'Text size';

  @override
  String get sizeSmall => 'Small';

  @override
  String get sizeMedium => 'Medium';

  @override
  String get sizeLarge => 'Large';

  @override
  String get sizeHuge => 'Huge';

  @override
  String get window => 'Window';

  @override
  String get onTop => 'Keep above other windows';

  @override
  String get translucent => 'Translucent';

  @override
  String get format => 'Format';

  @override
  String get bold => 'Bold (Ctrl+B)';

  @override
  String get italic => 'Italic (Ctrl+I)';

  @override
  String get underline => 'Underline (Ctrl+U)';

  @override
  String get strike => 'Strikethrough (Ctrl+T)';

  @override
  String get bullets => 'List (Ctrl+Shift+L)';

  @override
  String get biggerText => 'Bigger text (Ctrl+Shift+>)';

  @override
  String get smallerText => 'Smaller text (Ctrl+Shift+<)';

  @override
  String get deleteQuestion => 'Delete this note?';

  @override
  String get dontAskAgain => 'Don\'t ask again';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get resize => 'Resize';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. No ads, no telemetry and no account.';
  }

  @override
  String get aboutLegal =>
      'Code under the Apache 2.0 license. Fonts under the SIL Open Font License.';

  @override
  String get tips =>
      'Double-click the strip to fold the note. Ctrl+Z undoes and Ctrl+Y redoes.';
}
