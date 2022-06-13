import 'package:fancy_regex/src/base.dart';

/// Symbols that represent a group of character variants in Regular Expressions.
/// Certain character class allows a [negated] form.
///
/// See more at [regular-expressions.info website](https://www.regular-expressions.info/refcharacters.html)
///
/// Disclaimer: Available constructor list might not be completed yet
class CharacterClass implements RegExpComponent, BaseExpression {

  const CharacterClass._raw(this.symbol,): negated = false;

  /// Matches any character. Represented as dot (`.`) character.
  const CharacterClass.any(): symbol = ".", negated = false;

  /// Matches numeric characters `0-9`. Represented as `\d` (negated: `\D`).
  const CharacterClass.digits({this.negated = false,}): symbol = "\\d";

  /// Matches alphanumeric characters:
  /// - Letter `A` to `Z`, both upper-cased and lower-cased form.
  /// - Number `0-9`
  /// - The underscore (_) character
  ///
  /// Represented as `\w` (negated: `\W`).
  const CharacterClass.alphanumeric({this.negated = false,}): symbol = "\\w";

  /// Matches whitespace characters, such as space character, new line breaks,
  /// tabs, etc. Represented as `\s` (negated: `\S`).
  const CharacterClass.whitespace({this.negated = false,}): symbol = "\\s";

  /// Matches tab character (`\t`)
  const CharacterClass.horizontalTab(): symbol = "\\t", negated = false;

  /// Matches carriage return character (`\r`)
  const CharacterClass.carriageReturn(): symbol = "\\r", negated = false;

  /// Matches new line character (`\n`)
  const CharacterClass.linefeed(): symbol = "\\n", negated = false;

  /// Matches vertical tab character (`\v`)
  const CharacterClass.verticalTab(): symbol = "\\v", negated = false;

  /// Matches form feed character (`\f`)
  const CharacterClass.formFeed(): symbol = "\\f", negated = false;

  /// Matches NUL character (`\0`)
  const CharacterClass.nul(): symbol = "\\0", negated = false;

  /// Matches control characters such as `SOH`, `ETX`, etc. Ranging between
  /// `\cA` until `\cz` (available letters are A to Z, then a to z).
  ///
  /// Example:
  /// ```dart
  /// // Matching \cf
  /// var ackMatcher = CharacterClass.controlCharacter(
  ///   "f".codeUnitAt(0,),
  /// );
  /// ```
  factory CharacterClass.controlCharacter(int caretChar,) {
    if (caretChar >= 0x41 && caretChar <= 0x5A) {
      return CharacterClass._raw("\\c${String.fromCharCode(caretChar)}",);
    }
    throw ArgumentError.value(caretChar, "Caret Notation Character", "Must be between A-Z",);
  }

  /// Matches a character represented with [hex] ASCII value. Using `\x`
  /// notation with value range of `\x00` until `\xFF` (Available standard
  /// ASCII characters).
  ///
  /// Example:
  /// ```dart
  /// // Matching letter 'A'
  /// var matchLetterA = CharacterClass.hex2(0x41,);
  /// ```
  factory CharacterClass.hex2(int hex,) {
    if (hex >= 0 && hex <= 0xFF) {
      return CharacterClass._raw("\\x${hex.toRadixString(16,)}",);
    }
    throw ArgumentError.value(hex, "Hex Value", "Must be between 0x00 and 0xFF inclusive",);
  }

  /// Matches a character represented with [hex] Unicode value. Using `\u`
  /// notation with value range of `\u0000` until `\uFFFF`. This allows
  /// matching of non-Latin characters.
  ///
  /// Example:
  /// ```dart
  /// var jpManjiMatch = CharacterClass.hex4(0x534D,);
  /// ```
  factory CharacterClass.hex4(int hex,) {
    if (hex >= 0 && hex <= 0xFFFF) {
      return CharacterClass._raw("\\u${hex.toRadixString(16,)}",);
    }
    throw ArgumentError.value(hex, "Hex Value", "Must be between 0x0000 and 0xFFFF inclusive",);
  }

  /// Given a [literal] character, matches the same character with attaching a
  /// backslash to escape possibility of conflicts with existing literals used
  /// by other matching operator.
  ///
  /// Example:
  /// ```dart
  /// // Matches a square opening bracket
  /// var cmp = CharacterClass.literal("[",);
  /// ```
  factory CharacterClass.literal(String literal,) {
    literal = literal.trim();
    if (literal.isEmpty) {
      throw ArgumentError.value(literal, "Literal", "Must not be empty",);
    }
    return CharacterClass._raw("\\${literal[0]}",);
  }

  /// Main symbol proportion of the notation
  final String symbol;

  /// Use negated form, if available
  final bool negated;

  @override
  String toString() => negated ? symbol.toUpperCase() : symbol;
}