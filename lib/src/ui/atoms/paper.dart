import 'package:flutter/material.dart';

import '../../notes/note.dart';

/// The colours of one paper: the sheet, a deeper tone for its foot, the
/// strip at the top and the ink.
@immutable
class Paper {
  const Paper({
    required this.sheet,
    required this.deep,
    required this.strip,
    this.ink = const Color(0xFF3B3842),
  });

  final Color sheet;
  final Color deep;
  final Color strip;
  final Color ink;

  /// The pale ink of hints and quiet buttons.
  Color get faint => ink.withValues(alpha: .55);

  /// The thin line around the note.
  Color get edge => Color.lerp(strip, ink, .25)!;

  static Paper of(NoteColor color) => switch (color) {
    NoteColor.yellow => const Paper(
      sheet: Color(0xFFFFF6C4),
      deep: Color(0xFFFDEC9A),
      strip: Color(0xFFF7DF7A),
    ),
    NoteColor.blue => const Paper(
      sheet: Color(0xFFDDEFFF),
      deep: Color(0xFFC5E2FA),
      strip: Color(0xFFA9D1F2),
    ),
    NoteColor.green => const Paper(
      sheet: Color(0xFFE0F6D5),
      deep: Color(0xFFC6EDB6),
      strip: Color(0xFFA8DD93),
    ),
    NoteColor.pink => const Paper(
      sheet: Color(0xFFFFE0EC),
      deep: Color(0xFFFBC9DC),
      strip: Color(0xFFF4AACB),
    ),
    NoteColor.purple => const Paper(
      sheet: Color(0xFFEFE3FB),
      deep: Color(0xFFDECBF5),
      strip: Color(0xFFC9AFEE),
    ),
    NoteColor.white => const Paper(
      sheet: Color(0xFFFFFFFF),
      deep: Color(0xFFF3F3F1),
      strip: Color(0xFFE3E3DF),
    ),
  };
}

/// The font family of each choice.
String fontFamily(NoteFont font) => switch (font) {
  NoteFont.hand => 'NoteHand',
  NoteFont.plain => 'NoteSans',
};

/// The handwriting is drawn larger, since its letters are small.
double fontScale(NoteFont font) => font == NoteFont.hand ? 1.3 : 1;
