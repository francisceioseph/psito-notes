import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/app_localizations.dart';
import 'src/notes/note_controller.dart';
import 'src/notes/note_store.dart';
import 'src/notes/startup.dart';
import 'src/platform/note_window.dart';
import 'src/ui/pages/note_page.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final support = await getApplicationSupportDirectory();
  final store = NoteStore(Directory('${support.path}/notes'));
  final launcher = ProcessNoteLauncher();
  final picked = await pickNote(
    Startup.parse(args),
    store,
    launcher,
    now: DateTime.now().millisecondsSinceEpoch,
  );
  if (picked == null) exit(0);
  final (note, lock) = picked;
  final controller = NoteController(
    note: note,
    store: store,
    window: PluginNoteWindow(),
    launcher: launcher,
    lock: lock,
  );
  runApp(PsitoNotesApp(note: controller));
  await controller.open();
}

class PsitoNotesApp extends StatelessWidget {
  const PsitoNotesApp({super.key, required this.note});

  final NoteController note;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF7DF7A)),
      fontFamily: 'NoteSans',
    ),
    home: NotePage(note: note),
  );
}
