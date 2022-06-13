import 'package:fancy_regex/src/base.dart';
import 'package:fancy_regex/src/characters.dart';

/// Class to represents literal [String] as [RegExpComponent].
///
/// This class is provided as a mean to substitute any custom statement or just
/// literally skipping using any other available classes implementing
/// [RegExpComponent].
///
/// Typically used as a standalone expression or to fill in the gaps while using
/// [SerialExpressions].
///
/// See also: [CharacterClass.literal]
class RawExpression implements RegExpComponent {

  /// Constructs a [RegExpComponent] from [rawExpression] String
  const RawExpression(String rawExpression,): _rawExpression = rawExpression;

  factory RawExpression.fromRegExp(RegExp expression,) => RawExpression(
    expression.pattern,
  );

  final String _rawExpression;

  @override
  String toString() => _rawExpression;
}

/// Container to group together multiple [expressions] in a linear left-to-right
/// order without any separator.
class SerialExpressions implements RegExpComponent {

  /// Group multiple [expressions] together to form a modular, reusable
  /// [RegExpComponent]
  const SerialExpressions(this.expressions);

  final List<RegExpComponent> expressions;

  /// Creates a new [SerialExpressions] by replacing existing [expressions].
  ///
  /// If [merge] is `true`, the new [expressions] will be appended to previous
  /// expressions.
  SerialExpressions copyWith({
    List<RegExpComponent>? expressions,
    bool merge = false,
  }) {
    return SerialExpressions(
      merge ? [
        ...this.expressions,
        ...expressions ?? [],
      ] : expressions ?? [],
    );
  }

  /// Creates a new [SerialExpressions] by inserting expressions to the left
  /// and/or right of existing [expressions]
  SerialExpressions merge({
    List<RegExpComponent>? insertLeft,
    List<RegExpComponent>? insertRight,
  }) {
    return SerialExpressions(
      [
        ...insertLeft ?? [],
        ...expressions,
        ...insertRight ?? [],
      ],
    );
  }

  @override
  String toString() => expressions.map((e) => e.toString(),).join();
}