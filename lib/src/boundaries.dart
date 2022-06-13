import 'package:fancy_regex/src/base.dart';
import 'package:fancy_regex/src/raw.dart';

/// Allows matching the beginning and/or end of the [expression] input.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// // Match input that begins with "ID"
/// RegExp exp = FancyRegex(
///   expression: InputBoundary(
///     RawExpression("ID",),
///     start: true,
///   ),
/// );
///
/// print(exp.pattern,); // ^ID
/// exp.hasMatch("ID123",);
/// ```
class InputBoundary implements RegExpComponent {

  /// Attach `^` and/or `$` to [expression]
  const InputBoundary(this.expression, {this.start = false, this.end = false,});

  final RegExpComponent expression;

  /// If `true`, applies a `^` symbol at the beginning of the [expression]
  final bool start;

  /// If `true`, applies a `$` symbol at the end of the [expression]
  final bool end;

  String get _startSymbol => start ? "^" : "";
  String get _endSymbol => end ? "\$": "";

  @override
  String toString() => "$_startSymbol$expression$_endSymbol";
}
/// Insertable [RegExpComponent] to represents Word Boundary matching component
///
/// Typically used together with [SerialExpressions]
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// const RegExpComponent cmp = const SerialExpressions(
///   [
///     WordBoundary(),
///     RawExpression("ice",),
///   ],
/// );
///
/// print(cmp.toString(),); // \bice
///
/// ```
/// See more: [WordBound]
///
class WordBoundary implements RegExpComponent {

  /// Construct a [RegExpComponent] that translates directly as word
  /// boundary symbol. Allows a [negated] form.
  const WordBoundary({this.negated = false,});

  /// If `true`, use an upper-cased `B` instead of lower-cased `b`
  final bool negated;

  @override
  String toString() => "\\${negated ? "B" : "b"}";
}

/// Allows matching [expression] that is not preceded/followed by a
/// alphanumeric. A [negated] variant will match the other way around.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// RegExp exp = FancyRegex(
///   expression: WordBound(
///     RawExpression("ice",),
///     start: true,
///   ),
/// );
///
/// print(exp.pattern,); // \bice
/// exp.hasMatch("justice",); // false
/// exp.hasMatch("ice queen",); // true
/// ```
///
/// See also: [WordBoundary]
class WordBound implements RegExpComponent {

  /// Attach Word Boundary symbol `\b` or `\B` (negated form) to [expression]
  const WordBound(this.expression, {
    this.start = false, this.end = false, this.negated = false,
  });

  final RegExpComponent expression;

  /// If `true`, attach boundary symbol at the start of [expression]
  final bool start;

  /// If `true`, attach boundary symbol at the end of [expression]
  final bool end;

  /// If `true`, attach an upper-cased `B` instead of lower-cased `b`
  final bool negated;

  String get _boundarySymbol => "\\${negated ? "B" : "b"}";

  @override
  String toString() => [
    if (start)
      _boundarySymbol,
    expression.toString(),
    if (end)
      _boundarySymbol,
  ].join();
}