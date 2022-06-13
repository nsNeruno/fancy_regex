import 'package:fancy_regex/src/base.dart';

/// Matcher that matches characters based on their Unicode properties.
///
/// Supported syntaxes:
///
/// `\p{UnicodePropertyValue}`
///
/// `\p{UnicodePropertyName=UnicodePropertyValue}`
///
/// Negated form is available by replacing `p` with `P`.
///
/// Reference: [Mozilla Unicode Property Escapes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions/Unicode_Property_Escapes)
class UnicodeEscape implements RegExpComponent, BaseExpression {

  /// Creates a [RegExpComponent] that matches based on either raw Unicode property
  /// [value] or a pair of Unicode property name and property value.
  const UnicodeEscape(this.value, {this.negated = false,});

  /// Creates a [RegExpComponent] based on pair of Unicode property [name] and
  /// property [value]
  factory UnicodeEscape.byNameAndValue({
    required String name,
    required String value,
    bool negated = false,
  }) {
    return UnicodeEscape(
      "$name=$value", negated: negated,
    );
  }

  /// Stands for either `UnicodePropertyValue` or
  /// `UnicodePropertyName=UnicodePropertyValue` format
  final String value;

  /// If `true`, `p` will be replaced with `P` instead
  final bool negated;

  @override
  String toString() => "\\${negated ? "P" : "p"}{$value}";
}