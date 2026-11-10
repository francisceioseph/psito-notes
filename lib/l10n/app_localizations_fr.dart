// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'Nouvelle note (Ctrl+N)';

  @override
  String get deleteNote => 'Supprimer la note (Ctrl+D)';

  @override
  String get settings => 'Papier et texte';

  @override
  String get backToNote => 'Revenir à la note';

  @override
  String get foldNote => 'Replier ou déplier la note';

  @override
  String get noteText => 'Texte de la note';

  @override
  String get writeHere => 'Écrivez quelque chose…';

  @override
  String get emptyNote => 'Note vide';

  @override
  String get paper => 'Papier';

  @override
  String get colorYellow => 'Jaune';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorPink => 'Rose';

  @override
  String get colorPurple => 'Violet';

  @override
  String get colorWhite => 'Blanc';

  @override
  String get font => 'Écriture';

  @override
  String get fontHand => 'Manuscrite';

  @override
  String get fontPlain => 'Simple';

  @override
  String get textSize => 'Taille du texte';

  @override
  String get sizeSmall => 'Petite';

  @override
  String get sizeMedium => 'Moyenne';

  @override
  String get sizeLarge => 'Grande';

  @override
  String get sizeHuge => 'Énorme';

  @override
  String get window => 'Fenêtre';

  @override
  String get onTop => 'Garder au-dessus des autres fenêtres';

  @override
  String get translucent => 'Translucide';

  @override
  String get format => 'Mise en forme';

  @override
  String get bold => 'Gras (Ctrl+B)';

  @override
  String get italic => 'Italique (Ctrl+I)';

  @override
  String get underline => 'Souligné (Ctrl+U)';

  @override
  String get strike => 'Barré (Ctrl+T)';

  @override
  String get bullets => 'Liste (Ctrl+Maj+L)';

  @override
  String get biggerText => 'Texte plus grand (Ctrl+Maj+>)';

  @override
  String get smallerText => 'Texte plus petit (Ctrl+Maj+<)';

  @override
  String get deleteQuestion => 'Supprimer cette note ?';

  @override
  String get dontAskAgain => 'Ne plus demander';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get resize => 'Redimensionner';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. Sans publicité, sans télémétrie et sans compte.';
  }

  @override
  String get aboutLegal =>
      'Code sous licence Apache 2.0. Polices sous SIL Open Font License.';

  @override
  String get tips =>
      'Double-cliquez sur la bande pour replier la note. Ctrl+Z annule et Ctrl+Y rétablit.';
}
