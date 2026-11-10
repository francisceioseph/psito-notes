import '../../l10n/app_localizations.dart';
import '../notes/note.dart';

String colorName(AppLocalizations l10n, NoteColor color) => switch (color) {
  NoteColor.yellow => l10n.colorYellow,
  NoteColor.blue => l10n.colorBlue,
  NoteColor.green => l10n.colorGreen,
  NoteColor.pink => l10n.colorPink,
  NoteColor.purple => l10n.colorPurple,
  NoteColor.white => l10n.colorWhite,
};

String fontName(AppLocalizations l10n, NoteFont font) => switch (font) {
  NoteFont.hand => l10n.fontHand,
  NoteFont.plain => l10n.fontPlain,
};

/// The name of each of the [textSizes].
List<String> sizeNames(AppLocalizations l10n) => [
  l10n.sizeSmall,
  l10n.sizeMedium,
  l10n.sizeLarge,
  l10n.sizeHuge,
];
