import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psito_notes/src/notes/note.dart';
import 'package:psito_notes/src/notes/note_store.dart';
import 'package:psito_notes/src/notes/startup.dart';
import 'package:psito_notes/src/notes/styled_text.dart';
import 'package:psito_notes/src/platform/note_window.dart';

void main() {
  late Directory dir;
  late NoteStore store;
  late FakeNoteLauncher launcher;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('psito-notes-start');
    store = NoteStore(dir);
    launcher = FakeNoteLauncher();
  });
  tearDown(() => dir.delete(recursive: true));

  test('the command line is read', () {
    final open = Startup.parse(['--note', 'abc']);
    expect(open.noteId, 'abc');
    final made = Startup.parse(['--new', '--from', 'xyz']);
    expect(made.makeNew, isTrue);
    expect(made.from, 'xyz');
    expect(Startup.parse(const []).noteId, isNull);
  });

  test('with no notes, a new yellow one is made', () async {
    final (note, lock) = (await pickNote(
      const Startup(),
      store,
      launcher,
      now: 5,
    ))!;
    expect(note.color, NoteColor.yellow);
    expect(await store.load(note.id), isNotNull);
    await lock.release();
  });

  test('every note opens: one here, the others in their own process', () async {
    for (final at in [1, 2, 3]) {
      await store.save(
        Note.fresh(now: at).copyWith(body: StyledText('note $at')),
      );
    }
    final (note, lock) = (await pickNote(
      const Startup(),
      store,
      launcher,
      now: 9,
    ))!;
    expect(note.body.text, 'note 1');
    expect(launcher.opened.length, 2);
    await lock.release();
  });

  test('a new note takes the paper of the one that made it, and sits by it', () async {
    final parent = Note.fresh(now: 1).copyWith(
      color: NoteColor.purple,
      font: NoteFont.plain,
      bounds: const NoteBounds(100, 50, 300, 200),
    );
    await store.save(parent);
    final (note, lock) = (await pickNote(
      Startup(makeNew: true, from: parent.id),
      store,
      launcher,
      now: 2,
    ))!;
    expect(note.color, NoteColor.purple);
    expect(note.font, NoteFont.plain);
    expect(note.bounds, const NoteBounds(128, 78, 300, 200));
    await lock.release();
  });

  test('a note that is gone opens nothing', () async {
    expect(
      await pickNote(const Startup(noteId: 'gone'), store, launcher, now: 1),
      isNull,
    );
  });
}
