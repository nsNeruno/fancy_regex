import 'package:fancy_regex/src/base.dart';
import 'package:fancy_regex/src/constants.dart';

/// Range definition used as filter in [CharacterGroup] class.
///
/// Provides a list of convenience constructors for most commonly used patterns
class CharacterGroupRange {

  const CharacterGroupRange._(this.serial, [this._isRanging = false,]);

  /// Creates a range where each character within this [serial] will be used
  /// individually
  ///
  /// Example:
  /// ```dart
  /// // Match letters a, b, c, x, y, or z
  /// CharacterGroupRange("abcxyz",); // translates to [abcxyz]
  /// ```
  const CharacterGroupRange(this.serial,): _isRanging = false;

  /// Range covers letters from A to Z, both cases, including numeric 0 to 9
  const CharacterGroupRange.alphanumeric(): serial = "a-zA-Z0-9", _isRanging = false;

  /// Range covers the same signature as [CharacterGroupRange.alphanumeric], and
  /// includes additional underscore character (`_`) to match `\w` signature
  const CharacterGroupRange.alphanumericW(): serial = "a-zA-Z0-9_", _isRanging = false;

  /// Range covers numeric 0 to 9
  const CharacterGroupRange.digits(): serial = "09", _isRanging = true;

  /// Range covers letter a to z, lower-cased
  const CharacterGroupRange.lowerCased(): serial = "az", _isRanging = true;

  /// Range covers letter A to Z, upper-cased
  const CharacterGroupRange.upperCased(): serial = "AZ", _isRanging = true;

  /// Constructs a range by converting a [List] of [String] into [serial] of
  /// characters, taking at most first letter of each List's entry
  factory CharacterGroupRange.fromArray(List<String> characters,) {
    return CharacterGroupRange._(
      characters.where((e) => e.isNotEmpty,).map(
        (e) {
          final char = e[0];
          if (regExpSpecialCharacters.contains(char,)) {
            return "\\$char";
          }
          return char;
        },
      ).join(),
    );
  }

  /// Constructs a range by including the [from], [to], and all characters
  /// between, and if the range is invalid, the included hyphen (`-`) will be
  /// treated as a literal hyphen character
  ///
  /// Example:
  /// ```dart
  /// // creates an inclusive range of "k" to "o"
  /// CharacterGroupRange.between("k", "o",); // produces [k-o]
  /// ```
  factory CharacterGroupRange.between(String from, String to,) {
    return CharacterGroupRange._("$from$to", true,);
  }

  final String serial;
  final bool _isRanging;

  @override
  String toString() {
    if (_isRanging) {
      return "${serial[0]}-${serial[1]}";
    }
    return serial;
  }
}

/// Expression that match one of multiple [expressions] provided, separated by
/// a vertical bar (`|`).
///
/// Given an input, it will look for a match from the [expressions], checking
/// one by one, starting from the most left item first, and when a match found,
/// the search ends and the matcher will proceed to look at further unprocessed
/// input tokens.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// RegExp exp = FancyRegex(
///   expression: AlternationGroup(
///     [
///       CharacterGroup(
///         [CharacterGroupRange.lowerCased(),],
///       ),
///       CharacterGroup(
///         [CharacterGroupRange.upperCased(),],
///       ),
///     ],
///   ),
/// );
/// print(exp.pattern,); // [a-z]|[A-Z]
/// exp.allMatches("en_US",); // matches "en" and "US"
/// exp.allMatches("id_ID",); // matches "id" and "ID"
/// ```
class AlternationGroup implements RegExpComponent {

  /// Constructs a group that combine [expressions] into a new expression where
  /// each expression is separated by a vertical bar (`|`), indicating an OR
  /// operator
  const AlternationGroup(this.expressions,);

  final List<RegExpComponent> expressions;

  @override
  String toString() => expressions.map((e) => e.toString(),).join("|",);
}

/// Expression that contains a series of characters, or character ranges, that
/// matches if any character of the input matches element(s) of the group. Can
/// accept a caret (`^`) symbol as first element to apply a [negated] matching
/// where it will instead match everything that is not within the group.
///
/// Example:
/// ```dart
/// RegExp exp = FancyRegex(
///   expression: const CharacterGroup(
///     [
///       CharacterGroupRange.upperCased(),
///       CharacterGroupRange.digits(),
///     ],
///   ),
/// );
/// print(exp.pattern,); // [A-Z0-9]
/// final matches = exp.allMatches("FooBar123",);
/// ```
class CharacterGroup implements RegExpComponent, BaseExpression {

  /// Constructs a group that accepts one or more [CharacterGroupRange]s, and
  /// optionally can use a [negated] matching
  const CharacterGroup(this.ranges, {this.negated = false,});

  /// Character ranges used as filter
  final List<CharacterGroupRange> ranges;

  /// If `true`, performs a negated matching
  final bool negated;

  String get _negateSymbol => negated ? "^" : "";

  @override
  String toString() => "[$_negateSymbol${ranges.map((e) => e.toString(),).join()}]";
}

/// Capture a single, or a series of [expression]s and group them up as a
/// single expression.
///
/// This allows a method of treating the [expression] like a reusable variable,
/// by allowing a back-referencing, either by index or by [name].
///
/// Example:
/// ```dart
/// CaptureGroup(
///   AlternationGroup(
///     [
///       RawExpression("gmail\\.com",),
///       RawExpression("yahoo\\.com",),
///     ],
///   ),
/// );
/// // results in (gmail\.com|yahoo\.com)
/// ```
class CaptureGroup implements RegExpComponent {

  /// Constructs a new expression that captures another [expression] and wrap it
  /// under an enclosed rounded bracket context.
  ///
  /// Enables back-referencing if [nonCapturing] is `false`, and optionally, a
  /// [name] based referencing is possible as well.
  ///
  /// ```
  /// expression => (expression)
  /// ```
  const CaptureGroup(this.expression, {this.name, this.nonCapturing = false,});

  final RegExpComponent expression;

  /// An optional `name` to be used for name based back-referencing
  final String? name;

  /// If `true`, disables back-referencing for this group
  final bool nonCapturing;

  String get _nameComponent {
    if (!nonCapturing) {
      final name = this.name;
      if (name != null) {
        return "?<$name>";
      }
    }
    return "";
  }

  String get _nonCapturingFlag => nonCapturing ? "?:" : "";

  @override
  String toString() => "($_nameComponent$_nonCapturingFlag$expression)";
}

/// A reference to an existing Captured Group.
///
/// Given an expression that already includes a Captured Group somewhere within
/// the expression, and it's not using a name, and not flagged as non-capturing,
/// it is possible to "remember" it, and "echo" it once again elsewhere in the
/// expression body, just like a variable.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// // Simple HTML-like tag matcher
/// RegExp exp = FancyRegex(
///   expression: const SerialExpressions(
///     [
///       RawExpression("<",),
///       CaptureGroup(
///         MatchOneOrMore(
///           CharacterGroup(
///             [
///               CharacterGroupRange.lowerCased(),
///             ],
///           ),
///         ),
///       ),
///       RawExpression(">",),
///       MatchZeroOrMore(
///         CharacterClass.any(),
///       ),
///       RawExpression("<",),
///       CharacterClass.literal("/",),
///       BackReference(1,),
///       RawExpression(">",),
///     ],
///   ),
/// );
/// // produces <([a-z]+)>.*<\/\1>
/// exp.hasMatch("<html>Hello Za Warudo</html>",);
/// ```
class BackReference implements RegExpComponent {

  /// Creates an expression that indicates a [groupReference] by index where the
  /// number indicates the index number of created Capturing Group.
  ///
  /// First group created can be referenced as index 1. Group with non-capturing
  /// flag, or is using named reference, doesn't count and cannot be indexed
  /// this way.
  const BackReference(this.groupReference,);

  final int groupReference;

  @override
  String toString() => "\\$groupReference";
}

/// A reference to an existing Captured Group.
///
/// Given an expression that already includes a Captured Group somewhere within
/// the expression, and it's using a name, and not flagged as non-capturing,
/// it is possible to "remember" it, and "echo" it once again elsewhere in the
/// expression body, just like a variable.
///
/// Example:
/// ```dart
/// import 'package:fancy_regex/fancy_regex.dart';
///
/// // Simple HTML-like tag matcher
/// RegExp exp = FancyRegex(
///   expression: const SerialExpressions(
///     [
///       RawExpression("<",),
///       CaptureGroup(
///         MatchOneOrMore(
///           CharacterGroup(
///             [
///               CharacterGroupRange.lowerCased(),
///             ],
///           ),
///         ),
///         name: "tag_open",
///       ),
///       RawExpression(">",),
///       MatchZeroOrMore(
///         CharacterClass.any(),
///       ),
///       RawExpression("<",),
///       CharacterClass.literal("/",),
///       NamedBackReference("tag_open",),
///       RawExpression(">",),
///     ],
///   ),
/// );
/// // produces <(?<tag_open>[a-z]+)>.*<\/\k<tag_open>>
/// exp.hasMatch("<html>Hello Za Warudo</html>",);
/// ```
class NamedBackReference implements RegExpComponent {

  /// Creates an expression that indicates a reference by [name] should "echo"
  /// the same expression stated by an existing preceding captured group that
  /// declares the same [name]
  const NamedBackReference(this.name,);

  final String name;

  @override
  String toString() => "\\k<$name>";
}