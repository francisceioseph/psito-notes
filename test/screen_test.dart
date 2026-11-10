import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_notes/l10n/app_localizations.dart';
import 'package:psito_notes/src/notes/note.dart';
import 'package:psito_notes/src/notes/note_controller.dart';
import 'package:psito_notes/src/notes/note_store.dart';
import 'package:psito_notes/src/notes/styled_text.dart';
import 'package:psito_notes/src/platform/note_window.dart';
import 'package:psito_notes/src/ui/organisms/note_strip.dart';
import 'package:psito_notes/src/ui/pages/note_page.dart';

/// The notes in memory, so that the tests run on the fake clock.
class MemoryNoteStore extends NoteStore {
  MemoryNoteStore() : super(Directory('/nonexistent'));

  final notes = <String, Note>{};
  bool ask = true;

  @override
  Future<void> save(Note note) async => notes[note.id] = note;

  @override
  Future<Note?> load(String id) async => notes[id];

  @override
  Future<void> delete(String id) async => notes.remove(id);

  @override
  Future<bool> asksBeforeDelete() async => ask;

  @override
  Future<void> setAsksBeforeDelete(bool ask) async => this.ask = ask;
}

class Harness {
  Harness(this.note, this.window, this.launcher, this.store);

  final NoteController note;
  final FakeNoteWindow window;
  final FakeNoteLauncher launcher;
  final MemoryNoteStore store;
}

Future<Harness> pumpNote(
  WidgetTester tester, {
  String text = '',
  Size size = const Size(280, 260),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final store = MemoryNoteStore();
  final window = FakeNoteWindow();
  final launcher = FakeNoteLauncher();
  final note = NoteController(
    note: Note.fresh(now: 1).copyWith(body: StyledText(text)),
    store: store,
    window: window,
    launcher: launcher,
    saveDelay: Duration.zero,
  );
  addTearDown(note.dispose);
  await note.open();
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NotePage(note: note),
    ),
  );
  await tester.pump();
  return Harness(note, window, launcher, store);
}

Future<void> ctrl(WidgetTester tester, LogicalKeyboardKey key, {bool shift = false}) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(key);
  if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump();
}

void main() {
  testWidgets('typing fills the note and names the window', (tester) async {
    final h = await pumpNote(tester);
    expect(find.text('Escreva alguma coisa…'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Comprar pão\nleite');
    await tester.pump();
    expect(h.note.note.body.text, 'Comprar pão\nleite');
    expect(h.window.title, 'Comprar pão');
    await tester.pump(const Duration(seconds: 1));
    expect(h.store.notes[h.note.note.id]!.body.text, 'Comprar pão\nleite');
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Ctrl+B makes the selection bold, and Ctrl+Z takes it back', (
    tester,
  ) async {
    final h = await pumpNote(tester, text: 'hello');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    h.note.text.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    await ctrl(tester, LogicalKeyboardKey.keyB);
    expect(h.note.note.body.hasMark(0, 5, Mark.bold), isTrue);
    await ctrl(tester, LogicalKeyboardKey.keyZ);
    expect(h.note.note.body.hasMark(0, 5, Mark.bold), isFalse);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Ctrl+Shift+L turns the line into a list', (tester) async {
    final h = await pumpNote(tester, text: 'milk');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await ctrl(tester, LogicalKeyboardKey.keyL, shift: true);
    expect(h.note.note.body.text, '${bullet}milk');
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the plus makes a new note beside this one', (tester) async {
    final h = await pumpNote(tester);
    await tester.tap(find.byTooltip('Nova nota (Ctrl+N)'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(h.launcher.made, [h.note.note.id]);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('an empty note is deleted without a question', (tester) async {
    final h = await pumpNote(tester);
    await tester.tap(find.byTooltip('Apagar nota (Ctrl+D)'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    expect(h.window.closed, isTrue);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a note with text asks first, and can stop asking', (tester) async {
    final h = await pumpNote(tester, text: 'keep me');
    await tester.tap(find.byTooltip('Apagar nota (Ctrl+D)'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(find.text('Apagar esta nota?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(h.window.closed, isFalse);

    await tester.tap(find.byTooltip('Apagar nota (Ctrl+D)'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não perguntar de novo'));
    await tester.tap(find.text('Apagar'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(h.window.closed, isTrue);
    expect(h.store.ask, isFalse);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the settings change the paper, the font and the window', (
    tester,
  ) async {
    final h = await pumpNote(tester, size: const Size(280, 600));
    await tester.tap(find.byTooltip('Papel e texto'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Rosa'));
    await tester.pump();
    expect(h.note.note.color, NoteColor.pink);
    await tester.tap(find.text('Simples'));
    await tester.pump();
    expect(h.note.note.font, NoteFont.plain);
    await tester.tap(find.text('Manter acima das outras janelas'));
    await tester.pump();
    expect(h.window.onTop, isTrue);
    await tester.tap(find.byTooltip('Voltar à nota'));
    await tester.pump();
    expect(find.byType(TextField), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a double click on the strip folds the note to its title', (
    tester,
  ) async {
    final h = await pumpNote(tester, text: 'Ligar para Ana\nàs 5');
    // The middle of the strip is the handle.
    final strip = tester.getCenter(find.byType(NoteStrip));
    await tester.tapAt(strip);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(strip);
    await tester.pump(const Duration(milliseconds: 400));
    expect(h.note.note.folded, isTrue);
    expect(h.window.folded, isTrue);
    expect(find.text('Ligar para Ana'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('fits the smallest note and a folded one', (tester) async {
    await pumpNote(tester, text: 'x', size: minimumNoteSize);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Papel e texto'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 1));
  });
}
