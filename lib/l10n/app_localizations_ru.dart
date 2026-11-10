// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'Новая заметка (Ctrl+N)';

  @override
  String get deleteNote => 'Удалить заметку (Ctrl+D)';

  @override
  String get settings => 'Бумага и текст';

  @override
  String get backToNote => 'Вернуться к заметке';

  @override
  String get foldNote => 'Свернуть или развернуть заметку';

  @override
  String get noteText => 'Текст заметки';

  @override
  String get writeHere => 'Напишите что-нибудь…';

  @override
  String get emptyNote => 'Пустая заметка';

  @override
  String get paper => 'Бумага';

  @override
  String get colorYellow => 'Жёлтая';

  @override
  String get colorBlue => 'Голубая';

  @override
  String get colorGreen => 'Зелёная';

  @override
  String get colorPink => 'Розовая';

  @override
  String get colorPurple => 'Фиолетовая';

  @override
  String get colorWhite => 'Белая';

  @override
  String get font => 'Шрифт';

  @override
  String get fontHand => 'Рукописный';

  @override
  String get fontPlain => 'Простой';

  @override
  String get textSize => 'Размер текста';

  @override
  String get sizeSmall => 'Маленький';

  @override
  String get sizeMedium => 'Средний';

  @override
  String get sizeLarge => 'Большой';

  @override
  String get sizeHuge => 'Огромный';

  @override
  String get window => 'Окно';

  @override
  String get onTop => 'Поверх других окон';

  @override
  String get translucent => 'Полупрозрачная';

  @override
  String get format => 'Формат';

  @override
  String get bold => 'Жирный (Ctrl+B)';

  @override
  String get italic => 'Курсив (Ctrl+I)';

  @override
  String get underline => 'Подчёркнутый (Ctrl+U)';

  @override
  String get strike => 'Зачёркнутый (Ctrl+T)';

  @override
  String get bullets => 'Список (Ctrl+Shift+L)';

  @override
  String get biggerText => 'Крупнее (Ctrl+Shift+>)';

  @override
  String get smallerText => 'Мельче (Ctrl+Shift+<)';

  @override
  String get deleteQuestion => 'Удалить эту заметку?';

  @override
  String get dontAskAgain => 'Больше не спрашивать';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get resize => 'Изменить размер';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. Без рекламы, без телеметрии и без учётной записи.';
  }

  @override
  String get aboutLegal =>
      'Код под лицензией Apache 2.0. Шрифты под SIL Open Font License.';

  @override
  String get tips =>
      'Дважды щёлкните по полоске, чтобы свернуть заметку. Ctrl+Z отменяет, Ctrl+Y возвращает.';
}
