import 'dart:async';

import 'package:flutter/foundation.dart';

import '../platform/note_window.dart';
import 'note.dart';
import 'note_store.dart';
import 'rich_controller.dart';

/// One open note: its text, its look, its window, and the saving, which
/// happens by itself a moment after each change.
class NoteController extends ChangeNotifier {
  NoteController({
    required Note note,
    required this.store,
    required this.window,
    required this.launcher,
    this.lock,
    this.saveDelay = const Duration(milliseconds: 500),
  }) : _note = note,
       text = RichTextController(text: note.body) {
    text.addListener(_textChanged);
  }

  final NoteStore store;
  final NoteWindow window;
  final NoteLauncher launcher;
  final Duration saveDelay;
  final RichTextController text;

  /// Holds the note for this process. Kept here, where it stays alive for as
  /// long as the window: a lock nobody refers to is collected, and its file
  /// closed, and with it the lock.
  final NoteLock? lock;

  Note _note;
  Note get note => _note;

  Timer? _saveTimer;
  bool _deleted = false;
  String _title = '';

  /// Whether the settings cover the text.
  bool showingSettings = false;

  Future<void> open() async {
    await window.open(_note, onBounds: _moved, onClose: close);
    _updateTitle();
  }

  void _textChanged() {
    if (text.styled == _note.body) {
      // Only the caret moved, or a mark waits for the next letter.
      notifyListeners();
      return;
    }
    _change(_note.copyWith(body: text.styled));
    _updateTitle();
  }

  void _updateTitle() {
    final title = _note.body.firstLine;
    if (title == _title) return;
    _title = title;
    window.setTitle(title.isEmpty ? 'Psito Notes' : title);
  }

  void _change(Note next) {
    _note = next;
    _saveTimer?.cancel();
    _saveTimer = Timer(saveDelay, save);
    notifyListeners();
  }

  Future<void> save() async {
    _saveTimer?.cancel();
    if (_deleted) return;
    try {
      await store.save(_note);
    } on Object catch (error) {
      debugPrint('note ${_note.id} could not be saved: $error');
    }
  }

  void _moved(NoteBounds bounds) {
    final old = _note.bounds;
    // A folded window keeps the height it had open, to go back to it.
    final height = _note.folded ? (old?.height ?? defaultNoteSize.height) : bounds.height;
    _change(_note.copyWith(
      bounds: NoteBounds(bounds.x, bounds.y, bounds.width, height),
    ));
  }

  void setColor(NoteColor color) => _change(_note.copyWith(color: color));

  void setFont(NoteFont font) => _change(_note.copyWith(font: font));

  void setTextSize(int size) {
    if (size < 0 || size >= textSizes.length) return;
    _change(_note.copyWith(textSize: size));
  }

  void biggerText() => setTextSize(_note.textSize + 1);
  void smallerText() => setTextSize(_note.textSize - 1);

  void toggleFold() {
    final folded = !_note.folded;
    if (folded) showingSettings = false;
    _change(_note.copyWith(folded: folded));
    window.fold(folded, _note.bounds?.height ?? defaultNoteSize.height);
  }

  void setOnTop(bool onTop) {
    _change(_note.copyWith(onTop: onTop));
    window.setOnTop(onTop);
  }

  void setTranslucent(bool translucent) {
    _change(_note.copyWith(translucent: translucent));
    window.setTranslucent(translucent);
  }

  void toggleSettings() {
    showingSettings = !showingSettings;
    notifyListeners();
  }

  /// A new note beside this one, with the same paper and font.
  Future<void> newNote() async {
    await save();
    await launcher.newNote(from: _note.id);
  }

  /// Saves and closes the window. The note stays, for the next time.
  Future<void> close() async {
    await save();
    await lock?.release();
    await window.close();
  }

  /// Throws the note away and closes its window.
  Future<void> delete() async {
    _deleted = true;
    _saveTimer?.cancel();
    await lock?.release();
    await store.delete(_note.id);
    await window.close();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    text.removeListener(_textChanged);
    text.dispose();
    super.dispose();
  }
}
