import '../platform/note_window.dart';
import 'note.dart';
import 'note_store.dart';

/// What this process was asked on the command line.
class Startup {
  const Startup({this.noteId, this.makeNew = false, this.from});

  /// `--note <id>` opens that note, `--new [--from <id>]` makes one beside
  /// another, and nothing at all opens every note that is not open yet.
  factory Startup.parse(List<String> args) {
    String? after(String flag) {
      final at = args.indexOf(flag);
      return at >= 0 && at + 1 < args.length ? args[at + 1] : null;
    }

    return Startup(
      noteId: after('--note'),
      makeNew: args.contains('--new'),
      from: after('--from'),
    );
  }

  final String? noteId;
  final bool makeNew;
  final String? from;
}

/// How far a new note sits from the one that made it.
const newNoteStep = 28.0;

/// Finds the note this process will show, and holds it. The other notes
/// that nobody has open go to processes of their own. Null when there is
/// nothing for this process to do.
Future<(Note, NoteLock)?> pickNote(
  Startup startup,
  NoteStore store,
  NoteLauncher launcher, {
  required int now,
}) async {
  if (startup.noteId case final id?) {
    final lock = await store.tryLock(id);
    if (lock == null) return null;
    final note = await store.load(id);
    if (note == null) {
      await lock.release();
      return null;
    }
    return (note, lock);
  }
  if (startup.makeNew) return _newNote(store, now, from: startup.from);

  (Note, NoteLock)? mine;
  for (final note in await store.loadAll()) {
    final lock = await store.tryLock(note.id);
    if (lock == null) continue;
    if (mine == null) {
      mine = (note, lock);
    } else {
      await lock.release();
      await launcher.openNote(note.id);
    }
  }
  // Every note is open already, or there are none: a new one, as a click on
  // the plus would give.
  return mine ?? await _newNote(store, now);
}

Future<(Note, NoteLock)?> _newNote(
  NoteStore store,
  int now, {
  String? from,
}) async {
  final parent = from == null ? null : await store.load(from);
  final place = parent?.bounds;
  var note = Note.fresh(
    now: now,
    color: parent?.color ?? NoteColor.yellow,
    font: parent?.font ?? NoteFont.hand,
  );
  if (place != null) {
    note = note.copyWith(
      bounds: NoteBounds(
        place.x + newNoteStep,
        place.y + newNoteStep,
        place.width,
        place.height,
      ),
    );
  }
  await store.save(note);
  final lock = await store.tryLock(note.id);
  return lock == null ? null : (note, lock);
}
