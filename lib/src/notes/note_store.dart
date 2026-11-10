import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'note.dart';

/// A note held open by this process. While it is held, no other process
/// opens the same note.
class NoteLock {
  NoteLock._(this._file);

  final RandomAccessFile _file;

  Future<void> release() async {
    try {
      await _file.unlock();
      await _file.close();
    } on FileSystemException {
      // Already gone with the note.
    }
  }
}

/// The notes on this computer, one JSON file each in [directory], so that
/// every window saves only its own. Nothing leaves this folder.
class NoteStore {
  NoteStore(this.directory);

  final Directory directory;

  File _file(String id) => File('${directory.path}/$id.json');
  File _lockFile(String id) => File('${directory.path}/$id.lock');
  File get _settings => File('${directory.path}/settings.json');

  static bool _validId(String id) => RegExp(r'^[a-z0-9-]+$').hasMatch(id);

  /// Every note, the oldest first. Files that cannot be read are skipped.
  Future<List<Note>> loadAll() async {
    if (!await directory.exists()) return const [];
    final notes = <Note>[];
    await for (final entry in directory.list()) {
      final name = entry.uri.pathSegments.last;
      if (entry is! File || !name.endsWith('.json') || name == 'settings.json') {
        continue;
      }
      final note = await load(name.substring(0, name.length - 5));
      if (note != null) notes.add(note);
    }
    notes.sort((a, b) {
      final byAge = a.created.compareTo(b.created);
      return byAge != 0 ? byAge : a.id.compareTo(b.id);
    });
    return notes;
  }

  Future<Note?> load(String id) async {
    if (!_validId(id)) return null;
    try {
      final json = jsonDecode(await _file(id).readAsString());
      if (json is! Map<String, dynamic> || json['id'] != id) return null;
      return Note.fromJson(json);
    } on Object catch (error) {
      debugPrint('note $id could not be read: $error');
      return null;
    }
  }

  /// Writes beside the note and then moves it over, so that a crash never
  /// leaves half a note.
  Future<void> save(Note note) async {
    await directory.create(recursive: true);
    final target = _file(note.id);
    final temp = File('${target.path}.tmp');
    await temp.writeAsString(jsonEncode(note.toJson()), flush: true);
    await temp.rename(target.path);
  }

  Future<void> delete(String id) async {
    for (final file in [_file(id), _lockFile(id)]) {
      try {
        await file.delete();
      } on FileSystemException {
        // Never saved, or already gone.
      }
    }
  }

  /// Holds the note for this process, or null when another one has it.
  Future<NoteLock?> tryLock(String id) async {
    await directory.create(recursive: true);
    final file = await _lockFile(id).open(mode: FileMode.append);
    try {
      await file.lock(FileLock.exclusive);
      return NoteLock._(file);
    } on FileSystemException {
      await file.close();
      return null;
    }
  }

  /// Whether to ask before a note with text is deleted.
  Future<bool> asksBeforeDelete() async {
    try {
      final json = jsonDecode(await _settings.readAsString());
      return json is! Map || json['askBeforeDelete'] != false;
    } on Object {
      return true;
    }
  }

  Future<void> setAsksBeforeDelete(bool ask) async {
    await directory.create(recursive: true);
    await _settings.writeAsString(jsonEncode({'askBeforeDelete': ask}));
  }
}
