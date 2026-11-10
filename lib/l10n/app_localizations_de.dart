// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'Neue Notiz (Strg+N)';

  @override
  String get deleteNote => 'Notiz löschen (Strg+D)';

  @override
  String get settings => 'Papier und Text';

  @override
  String get backToNote => 'Zurück zur Notiz';

  @override
  String get foldNote => 'Notiz ein- oder ausklappen';

  @override
  String get noteText => 'Text der Notiz';

  @override
  String get writeHere => 'Schreib etwas…';

  @override
  String get emptyNote => 'Leere Notiz';

  @override
  String get paper => 'Papier';

  @override
  String get colorYellow => 'Gelb';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorPurple => 'Lila';

  @override
  String get colorWhite => 'Weiß';

  @override
  String get font => 'Schrift';

  @override
  String get fontHand => 'Handschrift';

  @override
  String get fontPlain => 'Schlicht';

  @override
  String get textSize => 'Textgröße';

  @override
  String get sizeSmall => 'Klein';

  @override
  String get sizeMedium => 'Mittel';

  @override
  String get sizeLarge => 'Groß';

  @override
  String get sizeHuge => 'Riesig';

  @override
  String get window => 'Fenster';

  @override
  String get onTop => 'Über anderen Fenstern halten';

  @override
  String get translucent => 'Durchscheinend';

  @override
  String get format => 'Format';

  @override
  String get bold => 'Fett (Strg+B)';

  @override
  String get italic => 'Kursiv (Strg+I)';

  @override
  String get underline => 'Unterstrichen (Strg+U)';

  @override
  String get strike => 'Durchgestrichen (Strg+T)';

  @override
  String get bullets => 'Liste (Strg+Umschalt+L)';

  @override
  String get biggerText => 'Größerer Text (Strg+Umschalt+>)';

  @override
  String get smallerText => 'Kleinerer Text (Strg+Umschalt+<)';

  @override
  String get deleteQuestion => 'Diese Notiz löschen?';

  @override
  String get dontAskAgain => 'Nicht mehr fragen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get resize => 'Größe ändern';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. Ohne Werbung, ohne Telemetrie und ohne Konto.';
  }

  @override
  String get aboutLegal =>
      'Code unter der Apache-2.0-Lizenz. Schriften unter der SIL Open Font License.';

  @override
  String get tips =>
      'Doppelklicke auf den Streifen, um die Notiz einzuklappen. Strg+Z macht rückgängig und Strg+Y wiederholt.';
}
