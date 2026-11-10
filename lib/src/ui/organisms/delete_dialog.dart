import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

/// The answer to the question before deleting.
typedef DeleteAnswer = ({bool delete, bool askAgain});

/// Asks before a note with text goes away, with a box to stop asking.
Future<DeleteAnswer> askToDelete(BuildContext context) async {
  final answer = await showDialog<DeleteAnswer>(
    context: context,
    builder: (_) => const _DeleteDialog(),
  );
  return answer ?? (delete: false, askAgain: true);
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog();

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  bool _dontAsk = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteQuestion, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.dontAskAgain),
              value: _dontAsk,
              onChanged: (value) => setState(() => _dontAsk = value ?? false),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, (delete: false, askAgain: true)),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          autofocus: true,
          onPressed: () =>
              Navigator.pop(context, (delete: true, askAgain: !_dontAsk)),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
