import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show joinAll, basename, join;
import 'package:recase/recase.dart';

void main(List<String> args) async {
  await generateModels();

  await exportModels();

  await generateAssets();

  // format
  stdout.writeln('[INFO] Formatting files...\n');
  final formatFile =
      await Process.run('dart', ['format', '.'], runInShell: true);
  stdout.writeln(formatFile.stdout.toString().trim());
  stderr.writeln(formatFile.stderr);
}

generateModels() async {
  // build_runner
  stdout.writeln('[INFO] Running build runner...\n');
  final buildRunner = await Process.run(
    'flutter',
    ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    runInShell: true,
  );
  stdout.writeln(buildRunner.stdout.toString().trim());
  stderr.writeln(buildRunner.stderr);
}

exportModels() async {
  // models
  const package = 'package:tugela';

  final modelsDir = Directory(
    joinAll([Directory.current.path, 'lib', 'models']),
  );
  final modelsList = modelsDir.listSync(recursive: true);
  modelsList.removeWhere((file) => file.path.endsWith('.g.dart'));
  modelsList.removeWhere((file) => !file.path.endsWith('.dart'));
  List<String> modelImports = [];
  modelImports.add('library models;\n\n');
  for (final modelFile in modelsList) {
    final filename = basename(modelFile.path);
    modelImports.add("export '${join(package, 'models', filename)}';");
  }
  final modelExport = joinAll([Directory.current.path, 'lib', 'models.dart']);
  final modelsResult = modelImports.join('\n');
  await File(modelExport).writeAsString(modelsResult).then((_) async {
    stdout.writeln('[INFO] Successfully updated models.dart');
    final formatter = await Process.run('dart', ['format', modelExport]);
    stdout.writeln('[INFO] ${formatter.stdout}');
    return stderr.writeln(formatter.stderr);
  }).catchError(
    (_) => stderr.writeln('[ERROR] Failed to update models.dart'),
  );
}

generateAssets() async {
  // assets
  final aasetsDir = Directory(
    joinAll([Directory.current.path, 'assets']),
  );
  final assetsFolders = aasetsDir.listSync();
  assetsFolders.removeWhere((a) => a.path.toLowerCase().contains('ds_store'));
  assetsFolders.removeWhere((a) => a.path.toLowerCase().contains('fonts'));
  List<String> assetFoldersCode = [];
  for (final folder in assetsFolders) {
    final files = Directory(folder.path).listSync(recursive: true);
    files.removeWhere((a) => a.path.toLowerCase().contains('ds_store'));
    files.removeWhere((a) => a.path.toLowerCase().contains('fonts'));
    final className = "AppAssets${ReCase(basename(folder.path)).sentenceCase}";
    assetFoldersCode.add(
      """
class _$className {
  const _$className();
  ${files.map((file) => '/// `File: assets${file.path.split('assets').last}`\n final ${file.path.replaceAll(folder.path, '').replaceAll('@', '').camelCase} = "assets${file.path.split('assets').last}";').join('\n')} 
  }""",
    );
  }
  final assetsCode =
      "class AppAssets { const AppAssets._(); ${assetsFolders.map((folder) => '/// `Folder: assets/${basename(folder.path).split('assets').last}` \n static const ${basename(folder.path).camelCase} = _AppAssets${ReCase(basename(folder.path)).sentenceCase}();').join(('\n'))} }  ${assetFoldersCode.join('\n')}";
  final assetsFile =
      joinAll([Directory.current.path, 'lib', 'constants', 'app_assets.dart']);
  await File(assetsFile).writeAsString(assetsCode).then((_) async {
    stdout.writeln('[INFO] Successfully updated app_assets.dart');
    final formatter = await Process.run('dart', ['format', assetsFile]);
    stdout.writeln('[INFO] ${formatter.stdout}');
    return stderr.writeln(formatter.stderr);
  }).catchError(
    (_) => stderr.writeln('[ERROR] Failed to update app_assets.dart'),
  );
}
