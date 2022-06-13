/// Base interface for `FancyRegex`'s expression block building.
///
/// Implementations of this interface must override [toString] method.
abstract class RegExpComponent {

  /// Raw representation of the `expression` to use directly on [RegExp]
  @override
  String toString() => "";
}

// TODO: Remove or add usages
abstract class BaseExpression {}