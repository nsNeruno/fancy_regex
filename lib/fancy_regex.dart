///
/// Provides a different approach to write Regular Expressions.
///
/// This module exposes a single main class [FancyRegex] and a some classes
/// implementing the interface [RegExpComponent].
///
/// [FancyRegex] implements [RegExp] to enable the instances to interoperate
/// with functions and methods that require [Pattern] or [RegExp] such as
/// [String.replaceAll].
///
/// The one small advantage of using [FancyRegex] is lowering the risk of typos
/// when writing [RegExp]s manually.
///
/// This module was created with the initial intention of introducing how
/// [RegExp] works to beginners without having to work out directly reading
/// symbols and patterns.
///
/// This module tries to adapt most known Regular Expression Operations, and
/// most used ones as well. Rare usages, or insufficient validation strength
/// while using the APIs here, will be addressed in future updates.
///
/// Bug Reports, Suggestions, and Issues, feel free to raise it directly at
/// the package's [Github Issues](https://github.com/nsNeruno/fancy_regex)
///
library fancy_regex;

import 'package:fancy_regex/src/base.dart';

export 'src/base.dart';
export 'src/boundaries.dart';
export 'src/characters.dart';
export 'src/constants.dart';
export 'src/extensions.dart';
export 'src/groups.dart';
export 'src/look_around.dart';
export 'src/quantifiers.dart';
export 'src/raw.dart';
export 'src/unicode.dart';

/// Utility functionalities to write Regular Expressions with simpler terms.
///
/// Enables a different way to write Regular Expressions which is implemented
/// as [RegExp] class on Dart core language.
///
/// Instance of this class is a straight implementation of [RegExp] and it
/// holds an internal [RegExp] object.
/// Thus, the implemented methods are using the exact same behavior of the
/// original.
///
/// There are two approaches provided to use this class:
/// - **Builder Pattern Style**: Declare one expression, then chain it with
/// various extension methods available.
/// - **Flutter Widget Tree Style**: Declare a tree-like structure where each
/// [RegExpComponent] can nest another [RegExpComponent] just like Flutter
/// Widgets.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// // Adapting example from RegExp class documentation
/// // First, this is the Builder Pattern
/// RegExp regex = FancyRegex(
///   expression: CharacterClass.alphanumeric().matchOneOrMore().toCaptureGroup(),
/// );
/// const String str = "Parse my string";
/// Iterable<RegExpMatch> matches = exp.allMatches(str,);
///
/// // And this is the Widget Tree Style
/// exp = FancyRegex(
///   expression: const CaptureGroup(
///     MatchOneOrMore(
///       CharacterClass.alphanumeric(),
///     ),
///   ),
/// );
/// matches = exp.allMatches(str,);
/// ```
///
class FancyRegex implements RegExp {

  /// Construct a new [FancyRegex] instance.
  ///
  /// Throws a [FormatException] on runtime if the compiled [expression] fails
  /// on building the internal [RegExp] reference.
  FancyRegex({
    required this.expression,
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
  });

  late final RegExp _regExp = RegExp(
    expression.toString(),
    multiLine: multiLine,
    caseSensitive: caseSensitive,
    unicode: unicode,
    dotAll: dotAll,
  );

  /// A single instance or compilation of multiple `RegExpComponent`s that will
  /// be fed to internal [RegExp] instance to process.
  final RegExpComponent expression;

  /// See [RegExp.isMultiLine]
  final bool multiLine;

  /// See [RegExp.isCaseSensitive]
  final bool caseSensitive;

  /// See [RegExp.isUnicode]
  final bool unicode;

  /// See [RegExp.isDotAll]
  final bool dotAll;

  /// See [RegExp.allMatches]
  @override
  Iterable<RegExpMatch> allMatches(String string, [int start = 0]) => _regExp.allMatches(string, start,);

  /// See [Pattern.matchAsPrefix]
  @override
  Match? matchAsPrefix(String string, [int start = 0]) => _regExp.matchAsPrefix(string, start,);

  /// See [RegExp.firstMatch]
  @override
  RegExpMatch? firstMatch(String input) => _regExp.firstMatch(input,);

  /// See [RegExp.hasMatch]
  @override
  bool hasMatch(String input) => _regExp.hasMatch(input,);

  /// See [RegExp.isCaseSensitive]
  @override
  bool get isCaseSensitive => caseSensitive;

  /// See [RegExp.isDotAll]
  @override
  bool get isDotAll => dotAll;

  /// See [RegExp.isMultiLine]
  @override
  bool get isMultiLine => multiLine;

  /// See [RegExp.isUnicode]
  @override
  bool get isUnicode => unicode;

  /// See [RegExp.pattern]
  @override
  String get pattern => _regExp.pattern;

  /// See [RegExp.stringMatch]
  @override
  String? stringMatch(String input) => _regExp.stringMatch(input,);
}