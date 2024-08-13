// ignore_for_file: avoid_print

import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show joinAll, basename;

import 'build.dart';

void main(List<String> args) async {
  await Process.run('clear', []);
  stdout.writeln('[MODELS] Watching models...\n');
  Process.run(
    'flutter',
    ['pub', 'run', 'build_runner', 'watch', '--delete-conflicting-outputs'],
    runInShell: true,
  ).then((buildRunner) {
    stdout.writeln(buildRunner.stdout.toString().trim());
    stderr.writeln(buildRunner.stderr);
  });

  await exportModels();

  final modelsDir = Directory(
    joinAll([Directory.current.path, 'lib', 'models']),
  );
  stdout.writeln(
    "[MODELS EXPORT] Watching models files to export",
  );
  modelsDir.watch(recursive: true).listen((event) async {
    if (!event.path.contains('.g.dart')) {
      stdout.writeln("[CHANGE] Running changes for [${basename(event.path)}]");
      await exportModels();
    }
  });

  await generateAssets();
  final assetsDir = Directory(joinAll([Directory.current.path, 'assets']));
  stdout.writeln("[ASSETS EXPORT] Watching assets to export");
  assetsDir.watch(recursive: true).listen((event) async {
    // if (!event.path.contains('.g.dart')) {
    stdout.writeln("[CHANGE] Running changes for [${basename(event.path)}]");
    await generateAssets();
    // }
  });
  return;
}
