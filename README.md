# fancy_regex [![Pub](https://img.shields.io/pub/v/fancy_regex.svg)](https://pub.dartlang.org/packages/fancy_regex)

Utility functionalities to write Regular Expressions with simpler terms.

## Features

If you have trouble writing **_Regular Expressions_** by yourself, or you're not really used to 
built-in [RegExp](https://api.dart.dev/stable/2.16.1/dart-core/RegExp-class.html) class, then you 
can start learning to implement Regular Expressions using this package.

This package offers APIs to write Regular Expressions using a more verbose, but more humanely 
readable classes and methods.

If you're already very proficient with writing Regular Expressions by yourself, you won't really 
need this package.

## Getting started

Adding the dependency
```yaml
dependencies:
  fancy_regex: ^0.1.0
```

Importing
```dart
import 'package:fancy_regex/fancy_regex.dart';

// Base Usage
final RegExp exp = FancyRegex(
  expression: RawExpression("Hello World",), // Any RegExpComponent
);

// Use the RegExp object for your pattern matching needs
```

## Usage

The APIs available on this package, are implementable with two available approaches.

- **Builder Pattern**: Instantiate a single base `RegExpComponent` expression, then it can be 
  extended with provided extension methods.
- **Flutter Widget Tree Style**: Each `RegExpComponent` implementing class here is capable of 
  wrapping another `RegExpComponent` expression in it.

```dart
import 'package:fancy_regex/fancy_regex.dart';

// Example for writing expression: /\+628\d{8,13}/
// In Dart's RegExp, it's declared as RegExp(r"\+628\d{8,13}",)

// Widget Tree Style
RegExp treeExp = FancyRegex(
  expression: SerialExpressions(
    [
      CharacterClass.literal("+",),
      RawExpression("628",),
      MatchRangedCount(
        CharacterClass.digits(),
        8,
        end: 13,
      ),
    ],
  ), // Any RegExpComponent
);

// Builder Pattern
RegExp builderExp = FancyRegex(
  expression: CharacterClass.literal("+",).addRight(
    RawExpression("628",),
  ).addRight(
    CharacterClass.digits().matchBetween(
      start: 8, end: 13,
    ),
  ), 
);

// Use the RegExp object for your pattern matching needs
```

See **_[Example Section](https://pub.dev/packages/fancy_regex/example)_**

## Available APIs

See the documentation [here](https://pub.dev/documentation/fancy_regex/latest/)

## Additional information

- As stated by most Regular Expression info bases out there, some uncommon expressions are not working 
  universally. Please consult on further references if certain expressions fail to work on certain 
  platforms.
- If you find the APIs to be too cumbersome to use, or want to suggest something, or bug reports, 
  feel free to raise an [issue](https://github.com/nsNeruno/fancy_regex/issues).
  
## TO-DOs
- Look for more available RegEx operators not yet implemented out there
- Write more concise, more easily understandable APIs
- Improving documentation