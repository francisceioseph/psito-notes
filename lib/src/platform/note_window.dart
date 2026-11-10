import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import '../notes/note.dart';

/// The height of the strip at the top, all that is left of a folded note.
const stripHeight = 30.0;

/// The smallest a note can be, unfolded.
const minimumNoteSize = Size(180, 130);

/// The size of a new note.
const defaultNoteSize = Size(280, 260);

/// What a note asks of its window. The real one goes through the window
/// manager plugin; the tests use [FakeNoteWindow].
abstract class NoteWindow {
  /// Takes the place and size of [note], and calls [onBounds] each time the
  /// window moves or changes size, and [onClose] when it is closed.
  Future<void> open(
    Note note, {
    required ValueChanged<NoteBounds> onBounds,
    required VoidCallback onClose,
  });

  Future<void> setTitle(String title);
  Future<void> setOnTop(bool onTop);
  Future<void> setTranslucent(bool translucent);

  /// Folds the window up to its strip, or opens it to [height].
  Future<void> fold(bool folded, double height);

  Future<void> startMove();
  Future<void> startResize();

  /// Closes the window, and with it this process.
  Future<void> close();
}

class PluginNoteWindow with WindowListener implements NoteWindow {
  ValueChanged<NoteBounds>? _onBounds;
  VoidCallback? _onClose;

  static const _translucency = .86;

  @override
  Future<void> open(
    Note note, {
    required ValueChanged<NoteBounds> onBounds,
    required VoidCallback onClose,
  }) async {
    _onBounds = onBounds;
    _onClose = onClose;
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);
    await windowManager.setAsFrameless();
    final bounds = note.bounds;
    final size = bounds == null
        ? defaultNoteSize
        : Size(bounds.width, note.folded ? stripHeight : bounds.height);
    await windowManager.setMinimumSize(
      note.folded ? const Size(120, stripHeight) : minimumNoteSize,
    );
    await windowManager.setSize(size);
    if (bounds != null) {
      await windowManager.setPosition(Offset(bounds.x, bounds.y));
    }
    await windowManager.setAlwaysOnTop(note.onTop);
    if (note.translucent) await windowManager.setOpacity(_translucency);
    await windowManager.show();
  }

  Future<void> _report() async {
    final rect = await windowManager.getBounds();
    _onBounds?.call(NoteBounds(rect.left, rect.top, rect.width, rect.height));
  }

  @override
  void onWindowMoved() => _report();

  @override
  void onWindowResized() => _report();

  @override
  void onWindowClose() => _onClose?.call();

  @override
  Future<void> setTitle(String title) => windowManager.setTitle(title);

  @override
  Future<void> setOnTop(bool onTop) => windowManager.setAlwaysOnTop(onTop);

  @override
  Future<void> setTranslucent(bool translucent) =>
      windowManager.setOpacity(translucent ? _translucency : 1);

  @override
  Future<void> fold(bool folded, double height) async {
    final rect = await windowManager.getBounds();
    if (folded) {
      await windowManager.setMinimumSize(Size(120, stripHeight));
      await windowManager.setSize(Size(rect.width, stripHeight));
    } else {
      await windowManager.setSize(
        Size(rect.width, height < minimumNoteSize.height ? defaultNoteSize.height : height),
      );
      await windowManager.setMinimumSize(minimumNoteSize);
    }
  }

  @override
  Future<void> startMove() => windowManager.startDragging();

  @override
  Future<void> startResize() =>
      windowManager.startResizing(ResizeEdge.bottomRight);

  @override
  Future<void> close() async {
    windowManager.removeListener(this);
    await windowManager.destroy();
  }
}

/// For the tests: remembers what was asked and moves nothing.
class FakeNoteWindow implements NoteWindow {
  String title = '';
  bool onTop = false;
  bool translucent = false;
  bool? folded;
  bool closed = false;
  int moves = 0;
  ValueChanged<NoteBounds>? onBounds;
  VoidCallback? onClose;

  @override
  Future<void> open(
    Note note, {
    required ValueChanged<NoteBounds> onBounds,
    required VoidCallback onClose,
  }) async {
    this.onBounds = onBounds;
    this.onClose = onClose;
    onTop = note.onTop;
    translucent = note.translucent;
  }

  @override
  Future<void> setTitle(String title) async => this.title = title;
  @override
  Future<void> setOnTop(bool onTop) async => this.onTop = onTop;
  @override
  Future<void> setTranslucent(bool translucent) async =>
      this.translucent = translucent;
  @override
  Future<void> fold(bool folded, double height) async => this.folded = folded;
  @override
  Future<void> startMove() async => moves++;
  @override
  Future<void> startResize() async {}
  @override
  Future<void> close() async => closed = true;
}

/// Opens other notes, each in a process of its own, so that every note is a
/// window of its own on the desktop.
abstract class NoteLauncher {
  Future<void> openNote(String id);

  /// A new note, made by the note [from] and placed near it.
  Future<void> newNote({String? from});
}

class ProcessNoteLauncher implements NoteLauncher {
  Future<void> _start(List<String> args) async {
    try {
      await Process.start(
        Platform.resolvedExecutable,
        args,
        mode: ProcessStartMode.detached,
      );
    } on ProcessException catch (error) {
      debugPrint('another note could not open: $error');
    }
  }

  @override
  Future<void> openNote(String id) => _start(['--note', id]);

  @override
  Future<void> newNote({String? from}) =>
      _start(['--new', if (from != null) ...['--from', from]]);
}

class FakeNoteLauncher implements NoteLauncher {
  final opened = <String>[];
  final made = <String?>[];

  @override
  Future<void> openNote(String id) async => opened.add(id);

  @override
  Future<void> newNote({String? from}) async => made.add(from);
}
