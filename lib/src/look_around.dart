import 'package:fancy_regex/src/base.dart';

/// Matcher that looks around the input without adding the additional matches to
/// the result.
///
/// Given a main [expression] and either [lookBehind] expressions or/and
/// [lookAhead] expressions,
///
/// Returns a match if all provided [lookBehind] and/or [lookAhead] expressions
/// matched has a match.
///
/// [lookAheed] and [lookBehind] is provided as a [Map] of [RegExpComponent] as
/// key, mapping to [bool] values, where the bool value indicates a negated
/// lookaround logic.
///
/// Example:
/// ```dart
/// RegExp exp = FancyRegex(
///   expression: LookAroundExpression(
///     MatchOneOrMore(
///       CharacterClass.any(),
///     ),
///     lookBehind: {
///       RawExpression("nanora",): false,
///     },
///     lookAhead: {
///       RawExpression("desuwa",): false,
///     },
///   ),
///   caseSensitive: false,
/// );
/// // produces /(?<=nanora).+(?=desuwa)/i
/// exp.hasMatch("Nanora!!!Desuwa",); // matches "!!!"
/// ```
class LookAroundExpression implements RegExpComponent {

  /// Wrap [expression] with look around statements, returns a match if all
  /// [lookBehind] and/or [lookAhead] expressions has matches.
  LookAroundExpression(this.expression, {
    this.lookBehind,
    this.lookAhead,
  });

  final RegExpComponent expression;

  /// A series of expressions to check, in order, left to right, with bool value
  /// to determine whether to perform a negated check if `true`.
  ///
  /// Checks are performed on the left side of the main [expression]
  final Map<RegExpComponent, bool>? lookBehind;

  /// A series of expressions to check, in order, left to right, with bool value
  /// to determine whether to perform a negated check if `true`
  ///
  /// Checks are performed on the right side of the main [expression]
  final Map<RegExpComponent, bool>? lookAhead;

  @override
  String toString() => <String>[
    ...lookBehind?.entries.map((e) => "(?<${e.value ? "!" : ""}${e.key.toString()})",) ?? [],
    expression.toString(),
    ...lookAhead?.entries.map((e) => "(?${e.value ? "!" : "="}${e.key.toString()})",) ?? [],
  ].join();
}