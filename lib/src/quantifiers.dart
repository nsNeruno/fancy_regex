import 'package:fancy_regex/src/base.dart';

/// Matcher that repeats and counts the provided [expression] and returns a match
/// if the calculation/lookup result satisfy the condition(s).
///
/// May return earlier with shorter match result by setting [isLazy] to `true`
abstract class Quantifier implements RegExpComponent, BaseExpression {

  const Quantifier(this.expression, [this.isLazy = false,]);

  final RegExpComponent expression;

  /// If `true`, returns a match right away without looking for more possible,
  /// longer matches
  final bool isLazy;

  String get _lazySymbol => isLazy ? "?" : "";
}

/// Matcher that looks for existence of [expression] and returns a match if
/// exists and includes any number of consecutive repetitions.
///
/// Example:
/// ```dart
/// // Matches any character
/// MatchZeroOrMore(
///   CharacterClass.any(),
/// );
/// // results in .*
/// ```
class MatchZeroOrMore extends Quantifier {

  /// Attach `*` to the end [expression], optionally adding `?` if [isLazy] is
  /// `true`
  const MatchZeroOrMore(RegExpComponent expression, [bool isLazy = false,]) : super(expression, isLazy,);

  @override
  String toString() => "$expression*$_lazySymbol";
}

/// Matcher that looks for existence of [expression] and returns a match it has
/// at least one match, and includes any number of consecutive repetitions.
///
/// Example:
/// ```dart
/// // Matches any character, at least one character
/// MatchOneOrMore(
///   CharacterClass.any(),
/// );
/// // results in .+
/// ```
class MatchOneOrMore extends Quantifier {

  /// Attach `+` to the end [expression], optionally adding `?` if [isLazy] is
  /// `true`
  const MatchOneOrMore(RegExpComponent expression, [bool isLazy = false,]) : super(expression, isLazy,);

  @override
  String toString() => "$expression+$_lazySymbol";
}

/// Matcher that looks for existence of [expression] and returns a match if
/// exists and doesn't include any consecutive repetitions.
///
/// Example:
/// ```dart
/// // Matches any character, only maximum of 1 repetition
/// MatchZeroOrOne(
///   CharacterClass.any(),
/// );
/// // results in .?
/// ```
class MatchZeroOrOne extends Quantifier {

  /// Attach `?` to the end [expression], optionally adding `?` if [isLazy] is
  /// `true`
  const MatchZeroOrOne(RegExpComponent expression, [bool isLazy = false,]) : super(expression, isLazy,);

  @override
  String toString() => "$expression?$_lazySymbol";
}

/// Matcher that checks if the [expression] has a match at least n times as
/// specified by [count] parameter. Consecutive matches beyond are ignored.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// RegExp exp = FancyRegex(
///   expression: MatchExactCount(
///     RawExpression("p",),
///   ),
/// );
/// print(exp.pattern,); // p{2}
///
/// exp.firstMatch("Bad Apple",); // match "pp" on index 5
/// ```
class MatchExactCount extends Quantifier {

  /// Attach {n} to the right of [expression] where `n` is [count] argument, a
  /// positive integer.
  ///
  /// While setting [count] to 0 works, it has no meaning whatsoever
  const MatchExactCount(RegExpComponent expression, this.count, [bool isLazy = false,]) : super(expression, isLazy,);

  /// A positive integer value indicates exact repetition count of
  /// [expression] to match
  final int count;

  @override
  String toString() => "$expression{$count}$_lazySymbol";
}

/// Matcher that checks if the [expression] has a match at least x times as
/// specified by [start] argument, count into as many repetition ahead as
/// possible, or until the repetition count reaches the y times as specified by
/// [end] argument, or returns earlier if [isLazy] set to `true`.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// RegExp exp = FancyRegex(
///   expression: MatchRangedCount(
///     CharacterClass.digits(),
///     8,
///     end: 13,
///   ),
/// );
/// print(exp.pattern,); // \d{8,13}
///
/// exp.firstMatch("012345678901234567890",); // match "0123456789012" from index 0
/// ```
class MatchRangedCount extends Quantifier {

  /// Attach {x,} or {x,y} to the right of [expression] where `x` is [start]
  /// argument, a positive integer; and `y`, is [end] if specified, a positive
  /// integer, greater than or equal to [start]
  const MatchRangedCount(RegExpComponent expression, this.start, {this.end, bool isLazy = false,}) : super(expression, isLazy,);

  /// A positive integer value indicates exact least repetition count of
  /// [expression] to match
  final int start;

  /// An optional positive integer with greater value than [start], specifying
  /// a maximum limit of repetition count to match
  final int? end;

  @override
  String toString() => "$expression{$start,${end?.toString() ?? ""}}$_lazySymbol";
}