import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psito_notes/src/notes/note.dart';
import 'package:psito_notes/src/notes/note_store.dart';
import 'package:psito_notes/src/notes/styled_text.dart';

void main() {
  late Directory dir;
  late NoteStore store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('psito-notes-test');
    store = NoteStore(dir);
  });
  tearDown(() => dir.delete(recursive: true));

  Note note(String text, {int created = 1}) => Note.fresh(
    now: created,
    random: Random(created),
  ).copyWith(body: StyledText(text).toggle(0, text.length, Mark.bold));

  test('a note survives saving, with all it carries', () async {
    final saved = note('hello').copyWith(
      color: NoteColor.pink,
      font: NoteFont.plain,
      textSize: 3,
      bounds: const NoteBounds(10, 20, 300, 250),
      folded: true,
      onTop: true,
      translucent: true,
    );
    await store.save(saved);
    final loaded = (await store.load(saved.id))!;
    expect(loaded.body, saved.body);
    expect(loaded.color, NoteColor.pink);
    expect(loaded.font, NoteFont.plain);
    expect(loaded.textSize, 3);
    expect(loaded.bounds, const NoteBounds(10, 20, 300, 250));
    expect(loaded.folded && loaded.onTop && loaded.translucent, isTrue);
  });

  test('all the notes come back, the oldest first', () async {
    await store.save(note('second', created: 20));
    await store.save(note('first', created: 10));
    final all = await store.loadAll();
    expect(all.map((n) => n.body.text), ['first', 'second']);
  });

  test('a damaged note is skipped and the others open', () async {
    await store.save(note('good'));
    await File('${dir.path}/broken.json').writeAsString('{not json');
    await File('${dir.path}/odd.json').writeAsString('{"id": "odd", "color": 7}');
    final all = await store.loadAll();
    expect(all.map((n) => n.body.text), containsAll(['good', '']));
    expect(all.firstWhere((n) => n.id == 'odd').color, NoteColor.yellow);
  });

  test('a strange name never reaches the disk', () async {
    expect(await store.load('../etc/passwd'), isNull);
  });

  test('deleting removes the note', () async {
    final gone = note('bye');
    await store.save(gone);
    await store.delete(gone.id);
    expect(await store.loadAll(), isEmpty);
  });

  test('a note can be held, and let go', () async {
    final lock = await store.tryLock('abc');
    expect(lock, isNotNull);
    await lock!.release();
  });

  test('the question before deleting can be turned off', () async {
    expect(await store.asksBeforeDelete(), isTrue);
    await store.setAsksBeforeDelete(false);
    expect(await store.asksBeforeDelete(), isFalse);
  });
}
