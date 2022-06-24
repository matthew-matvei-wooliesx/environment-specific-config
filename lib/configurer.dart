import 'dart:io';

import 'package:args/args.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

void main(Iterable<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      "multiplier",
      abbr: "m",
      defaultsTo: "1",
    );

  final results = parser.parse(arguments);

  final args = _ParsedArgs(
    multiplier: int.tryParse(
          results["multiplier"]?.toString() ?? "",
          radix: 10,
        ) ??
        0,
  );

  await _createConfigFile(_generateConfig(args));
}

String _generateConfig(_ParsedArgs arguments) {
  final config = Class(
    (c) => c
      ..name = "Configuration"
      ..fields.addAll(
        [
          Field(
            (f) => f
              ..name = "multiplier"
              ..type = const Reference("int")
              ..assignment = Code("${arguments.multiplier}")
              ..static = true
              ..modifier = FieldModifier.constant,
          )
        ],
      ),
  );

  return DartFormatter().format("${config.accept(DartEmitter())}");
}

Future<void> _createConfigFile(String classDefinition) async {
  File configFile = File("lib/config.dart");

  await configFile.writeAsString(classDefinition, mode: FileMode.write);
}

class _ParsedArgs {
  final int multiplier;

  const _ParsedArgs({required this.multiplier});
}
