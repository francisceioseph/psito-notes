import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_notes/src/notes/rich_controller.dart';
import 'package:psito_notes/src/notes/styled_text.dart';

void main() {
  group('styled text', () {
    test('typing takes the marks of the character before', () {
      final text = StyledText('ab', [Mark.bold, Mark.bold]).edit('abc');
      expect(text.marks, [Mark.bold, Mark.bold, Mark.bold]);
    });

    test('a replacement keeps the marks around it', () {
      final text = StyledText('hello', [0, 0, Mark.italic, 0, 0]).edit('heLLo');
      expect(text.marks, [0, 0, 0, 0, 0]);
      final kept = StyledText('hello', [1, 1, 0, 2, 2]).edit('hey lo');
      expect(kept.text, 'hey lo');
      expect(kept.marks.first, 1);
      expect(kept.marks.last, 2);
    });

    test('toggling marks everything, or clears it when all have it', () {
      var text = StyledText('abcd');
      text = text.toggle(1, 3, Mark.underline);
      expect(text.marks, [0, Mark.underline, Mark.underline, 0]);
      text = text.toggle(0, 4, Mark.underline);
      expect(text.marks.every((m) => m == Mark.underline), isTrue);
      text = text.toggle(0, 4, Mark.underline);
      expect(text.marks.every((m) => m == 0), isTrue);
    });

    test('marks combine', () {
      final text = StyledText('ab').toggle(0, 2, Mark.bold).toggle(0, 1, Mark.strike);
      expect(text.marks, [Mark.bold | Mark.strike, Mark.bold]);
    });

    test('runs go out and come back the same', () {
      final text = StyledText('one two', [0, 0, 0, 0, 3, 3, 3]);
      expect(text.toRuns(), [
        [4, 7, 3],
      ]);
      expect(StyledText.fromRuns(text.text, text.toRuns()), text);
    });

    test('runs that do not fit are dropped, not fatal', () {
      final text = StyledText.fromRuns('abc', [
        [1, 99, Mark.bold],
        [5],
      ]);
      expect(text.marks, [0, Mark.bold, Mark.bold]);
    });

    test('bullets go on every line of the selection, and come off', () {
      final (on, move) = StyledText('milk\neggs\nbread').toggleBullets(0, 9);
      expect(on.text, '${bullet}milk\n${bullet}eggs\nbread');
      expect(move(0), bullet.length);
      expect(move(9), 9 + bullet.length * 2);
      final (off, back) = on.toggleBullets(0, on.length - 6);
      expect(off.text, 'milk\neggs\nbread');
      expect(back(1), 0);
    });

    test('the first line names the note, without its bullet', () {
      expect(StyledText('\n  Buy milk  \nand eggs').firstLine, 'Buy milk');
      expect(StyledText('${bullet}Call Ana').firstLine, 'Call Ana');
    });
  });

  group('controller', () {
    late DateTime now;
    RichTextController make([String text = '']) {
      now = DateTime(2026);
      return RichTextController(text: StyledText(text), clock: () => now);
    }

    void type(RichTextController c, String text) {
      final at = c.selection.isValid ? c.selection.start : c.text.length;
      c.value = TextEditingValue(
        text: c.text.replaceRange(at, at, text),
        selection: TextSelection.collapsed(offset: at + text.length),
      );
    }

    test('a mark turned on at the caret applies to what comes next', () {
      final c = make('ab');
      c.selection = const TextSelection.collapsed(offset: 2);
      c.toggle(Mark.bold);
      expect(c.isActive(Mark.bold), isTrue);
      type(c, 'cd');
      expect(c.styled.marks, [0, 0, Mark.bold, Mark.bold]);
    });

    test('a mark on a selection changes it', () {
      final c = make('abc');
      c.selection = const TextSelection(baseOffset: 0, extentOffset: 2);
      c.toggle(Mark.italic);
      expect(c.styled.marks, [Mark.italic, Mark.italic, 0]);
      expect(c.isActive(Mark.italic), isTrue);
    });

    test('Enter goes on with the list, and an empty item ends it', () {
      final c = make('${bullet}milk');
      c.selection = TextSelection.collapsed(offset: c.text.length);
      type(c, '\n');
      expect(c.text, '${bullet}milk\n$bullet');
      expect(c.selection.baseOffset, c.text.length);
      type(c, '\n');
      expect(c.text, '${bullet}milk\n');
    });

    test('undo brings back the text and its marks, typing in one step', () {
      final c = make('ab');
      c.selection = const TextSelection(baseOffset: 0, extentOffset: 2);
      c.toggle(Mark.bold);
      c.selection = const TextSelection.collapsed(offset: 2);
      type(c, 'c');
      type(c, 'd');
      expect(c.text, 'abcd');
      c.undo();
      expect(c.text, 'ab');
      expect(c.styled.marks, [Mark.bold, Mark.bold]);
      c.undo();
      expect(c.styled.marks, [0, 0]);
      expect(c.canUndo, isFalse);
      c.redo();
      expect(c.styled.marks, [Mark.bold, Mark.bold]);
    });

    test('a pause starts a new step of the undo', () {
      final c = make();
      type(c, 'a');
      now = now.add(const Duration(seconds: 2));
      type(c, 'b');
      c.undo();
      expect(c.text, 'a');
    });

    test('opening a note cannot be undone', () {
      final c = make();
      c.load(StyledText('saved'));
      expect(c.text, 'saved');
      expect(c.canUndo, isFalse);
    });
  });
}
