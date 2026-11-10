// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'Nota nueva (Ctrl+N)';

  @override
  String get deleteNote => 'Borrar nota (Ctrl+D)';

  @override
  String get settings => 'Papel y texto';

  @override
  String get backToNote => 'Volver a la nota';

  @override
  String get foldNote => 'Plegar o abrir la nota';

  @override
  String get noteText => 'Texto de la nota';

  @override
  String get writeHere => 'Escribe algo…';

  @override
  String get emptyNote => 'Nota vacía';

  @override
  String get paper => 'Papel';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorPurple => 'Morado';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get font => 'Letra';

  @override
  String get fontHand => 'Manuscrita';

  @override
  String get fontPlain => 'Sencilla';

  @override
  String get textSize => 'Tamaño del texto';

  @override
  String get sizeSmall => 'Pequeño';

  @override
  String get sizeMedium => 'Mediano';

  @override
  String get sizeLarge => 'Grande';

  @override
  String get sizeHuge => 'Enorme';

  @override
  String get window => 'Ventana';

  @override
  String get onTop => 'Mantener sobre las demás ventanas';

  @override
  String get translucent => 'Translúcida';

  @override
  String get format => 'Formato';

  @override
  String get bold => 'Negrita (Ctrl+B)';

  @override
  String get italic => 'Cursiva (Ctrl+I)';

  @override
  String get underline => 'Subrayado (Ctrl+U)';

  @override
  String get strike => 'Tachado (Ctrl+T)';

  @override
  String get bullets => 'Lista (Ctrl+Shift+L)';

  @override
  String get biggerText => 'Texto más grande (Ctrl+Shift+>)';

  @override
  String get smallerText => 'Texto más pequeño (Ctrl+Shift+<)';

  @override
  String get deleteQuestion => '¿Borrar esta nota?';

  @override
  String get dontAskAgain => 'No volver a preguntar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Borrar';

  @override
  String get resize => 'Cambiar el tamaño';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. Sin anuncios, sin telemetría y sin cuenta.';
  }

  @override
  String get aboutLegal =>
      'Código bajo la licencia Apache 2.0. Fuentes bajo la SIL Open Font License.';

  @override
  String get tips =>
      'Haz doble clic en la franja para plegar la nota. Ctrl+Z deshace y Ctrl+Y rehace.';
}
