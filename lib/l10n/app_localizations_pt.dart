// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Psito Notes';

  @override
  String get newNote => 'Nova nota (Ctrl+N)';

  @override
  String get deleteNote => 'Apagar nota (Ctrl+D)';

  @override
  String get settings => 'Papel e texto';

  @override
  String get backToNote => 'Voltar à nota';

  @override
  String get foldNote => 'Recolher ou abrir a nota';

  @override
  String get noteText => 'Texto da nota';

  @override
  String get writeHere => 'Escreva alguma coisa…';

  @override
  String get emptyNote => 'Nota vazia';

  @override
  String get paper => 'Papel';

  @override
  String get colorYellow => 'Amarelo';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorPurple => 'Roxo';

  @override
  String get colorWhite => 'Branco';

  @override
  String get font => 'Letra';

  @override
  String get fontHand => 'Manuscrita';

  @override
  String get fontPlain => 'Simples';

  @override
  String get textSize => 'Tamanho do texto';

  @override
  String get sizeSmall => 'Pequeno';

  @override
  String get sizeMedium => 'Médio';

  @override
  String get sizeLarge => 'Grande';

  @override
  String get sizeHuge => 'Enorme';

  @override
  String get window => 'Janela';

  @override
  String get onTop => 'Manter acima das outras janelas';

  @override
  String get translucent => 'Translúcida';

  @override
  String get format => 'Formatação';

  @override
  String get bold => 'Negrito (Ctrl+B)';

  @override
  String get italic => 'Itálico (Ctrl+I)';

  @override
  String get underline => 'Sublinhado (Ctrl+U)';

  @override
  String get strike => 'Riscado (Ctrl+T)';

  @override
  String get bullets => 'Lista (Ctrl+Shift+L)';

  @override
  String get biggerText => 'Texto maior (Ctrl+Shift+>)';

  @override
  String get smallerText => 'Texto menor (Ctrl+Shift+<)';

  @override
  String get deleteQuestion => 'Apagar esta nota?';

  @override
  String get dontAskAgain => 'Não perguntar de novo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Apagar';

  @override
  String get resize => 'Redimensionar';

  @override
  String aboutLine(String version) {
    return 'Psito Notes $version. Sem anúncios, sem telemetria e sem conta.';
  }

  @override
  String get aboutLegal =>
      'Código sob a licença Apache 2.0. Fontes sob a SIL Open Font License.';

  @override
  String get tips =>
      'Clique duas vezes na faixa para recolher a nota. Ctrl+Z desfaz e Ctrl+Y refaz.';
}
