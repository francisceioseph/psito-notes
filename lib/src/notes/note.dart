import 'dart:math';

import 'package:flutter/foundation.dart';

import 'styled_text.dart';

/// The six papers, as on the classic desktops.
enum NoteColor { yellow, blue, green, pink, purple, white }

/// The handwriting, or a plain font that reads well in long notes.
enum NoteFont { hand, plain }

/// The sizes of the text, from small to large.
const textSizes = [14.0, 17.0, 21.0, 26.0];

/// Where the window was and how big.
@immutable
class NoteBounds {
  const NoteBounds(this.x, this.y, this.width, this.height);

  final double x;
  final double y;
  final double width;
  final double height;

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'w': width, 'h': height};

  static NoteBounds? fromJson(Object? json) {
    if (json is! Map) return null;
    final values = [json['x'], json['y'], json['w'], json['h']];
    if (values.any((value) => value is! num)) return null;
    return NoteBounds(
      (values[0] as num).toDouble(),
      (values[1] as num).toDouble(),
      (values[2] as num).toDouble(),
      (values[3] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is NoteBounds &&
      other.x == x &&
      other.y == y &&
      other.width == width &&
      other.height == height;

  @override
  int get hashCode => Object.hash(x, y, width, height);
}

/// One sticky note. It never changes: an edit gives a new one.
@immutable
class Note {
  const Note({
    required this.id,
    required this.body,
    this.color = NoteColor.yellow,
    this.font = NoteFont.hand,
    this.textSize = 1,
    this.bounds,
    this.folded = false,
    this.onTop = false,
    this.translucent = false,
    this.created = 0,
  });

  /// A new empty note, with a name no other note has.
  factory Note.fresh({
    NoteColor color = NoteColor.yellow,
    NoteFont font = NoteFont.hand,
    required int now,
    Random? random,
  }) {
    final tail = (random ?? Random()).nextInt(1 << 32).toRadixString(36);
    return Note(
      id: '${now.toRadixString(36)}-$tail',
      body: StyledText.empty,
      color: color,
      font: font,
      created: now,
    );
  }

  /// Reads a saved note. Anything missing or strange takes the default, so
  /// that a damaged file still opens.
  factory Note.fromJson(Map<String, dynamic> json) {
    T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.firstWhere((value) => value.name == name, orElse: () => fallback);
    final text = json['text'] is String ? json['text'] as String : '';
    final runs = [
      if (json['marks'] case final List marks)
        for (final run in marks)
          if (run is List && run.every((v) => v is int)) run.cast<int>(),
    ];
    final size = json['size'];
    return Note(
      id: json['id'] as String,
      body: StyledText.fromRuns(text, runs),
      color: pick(NoteColor.values, json['color'], NoteColor.yellow),
      font: pick(NoteFont.values, json['font'], NoteFont.hand),
      textSize: size is int && size >= 0 && size < textSizes.length ? size : 1,
      bounds: NoteBounds.fromJson(json['bounds']),
      folded: json['folded'] == true,
      onTop: json['onTop'] == true,
      translucent: json['translucent'] == true,
      created: json['created'] is int ? json['created'] as int : 0,
    );
  }

  final String id;
  final StyledText body;
  final NoteColor color;
  final NoteFont font;

  /// An index of [textSizes].
  final int textSize;

  /// Null until the window is first placed.
  final NoteBounds? bounds;

  /// Folded up to its strip, like a window shade.
  final bool folded;

  /// Kept above the other windows.
  final bool onTop;

  /// Lets a little of the desktop show through.
  final bool translucent;

  /// When it was made, in milliseconds, to open the notes in that order.
  final int created;

  bool get isEmpty => body.text.trim().isEmpty;

  Note copyWith({
    StyledText? body,
    NoteColor? color,
    NoteFont? font,
    int? textSize,
    NoteBounds? bounds,
    bool? folded,
    bool? onTop,
    bool? translucent,
  }) => Note(
    id: id,
    body: body ?? this.body,
    color: color ?? this.color,
    font: font ?? this.font,
    textSize: textSize ?? this.textSize,
    bounds: bounds ?? this.bounds,
    folded: folded ?? this.folded,
    onTop: onTop ?? this.onTop,
    translucent: translucent ?? this.translucent,
    created: created,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': body.text,
    'marks': body.toRuns(),
    'color': color.name,
    'font': font.name,
    'size': textSize,
    if (bounds case final bounds?) 'bounds': bounds.toJson(),
    'folded': folded,
    'onTop': onTop,
    'translucent': translucent,
    'created': created,
  };
}
