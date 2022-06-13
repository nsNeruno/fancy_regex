import 'package:fancy_regex/fancy_regex.dart';
import 'package:flutter/foundation.dart';

void main() {
  _basicExample();
  _phoneNumberExample();
  _phoneNumberExample2();
  _emailExample();
}

void _basicExample() {
  RegExp exp = FancyRegex(
    expression: const CharacterClass.alphanumeric()
        .matchOneOrMore()
        .toCaptureGroup(),
  );
  const String str = "Parse my string";
  Iterable<RegExpMatch> matches = exp.allMatches(str);
  if (kDebugMode) {
    print(exp.pattern,);
    print(matches.map((e) => e.group(0,),),);
    print(matches.isNotEmpty,);
  }

  exp = FancyRegex(
    expression: const CaptureGroup(
      MatchOneOrMore(
        CharacterClass.alphanumeric(),
      ),
    ),
  );
  matches = exp.allMatches(str);
  if (kDebugMode) {
    print(exp.pattern,);
    print(matches.map((e) => e.group(0,),),);
    print(matches.isNotEmpty,);
  }
}

void _phoneNumberExample() {
  final RegExp regex = FancyRegex(
    expression: InputBoundary(
      SerialExpressions(
        [
          CharacterClass.literal("+",),
          const RawExpression("628",),
          const MatchRangedCount(
            CharacterClass.digits(),
            8, end: 13,
          ),
        ],
      ),
      start: true,
      end: true,
    ),
  );
  final testResult = regex.hasMatch("+6285932564660",);
  if (kDebugMode) {
    print(regex.pattern,);
    print(testResult,);
  }
}

void _phoneNumberExample2() {
  final RegExp regex = FancyRegex(
    expression: SerialExpressions(
      [
        CharacterClass.literal("+",),
        const RawExpression("628",),
      ],
    ).addRight(
      const CharacterClass.digits().matchBetween(start: 8, end: 13,),
    ).matchWholeLine(),
  );
  final testResult = regex.hasMatch("+6285932564660",);
  if (kDebugMode) {
    print(regex.pattern,);
    print(testResult,);
  }
}

void _emailExample() {
  // [a-z0-9!#$%&'*+/=?^_`{|}~-]+
  // (?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*
  // @
  // (?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+
  // [a-z0-9]
  // (?:[a-z0-9-]*[a-z0-9])?
  const emailAllowedSymbols = [
    "!", "#", "\$", "%", "&", "'", "*", "+", "/", "=", "?", "^", "_", "`", "{", "|", "}", "~", '"',
  ];
  final emailAllowedSymbolExp = MatchOneOrMore(
    CharacterGroup(
      [
        const CharacterGroupRange.lowerCased(),
        const CharacterGroupRange.digits(),
        CharacterGroupRange.fromArray(
          emailAllowedSymbols,
        ),
      ],
    ),
  );
  const allowedEmailNonSymbolsExp = CharacterGroup(
    [
      CharacterGroupRange.lowerCased(),
      CharacterGroupRange.digits(),
    ],
  );
  final allowedEmailNonSymbolsHyphen = CharacterGroup(
    [
      const CharacterGroupRange.lowerCased(),
      const CharacterGroupRange.digits(),
      CharacterGroupRange.fromArray(["-"],),
    ],
  );

  final RegExp regex = FancyRegex(
    expression: SerialExpressions(
      [
        emailAllowedSymbolExp,
        MatchZeroOrMore(
          CaptureGroup(
            SerialExpressions(
              [
                CharacterClass.literal(".",),
                emailAllowedSymbolExp,
              ],
            ),
            nonCapturing: true,
          ),
        ),
        const RawExpression("@",),
        MatchOneOrMore(
          CaptureGroup(
            SerialExpressions(
              [
                allowedEmailNonSymbolsExp,
                MatchZeroOrOne(
                  CaptureGroup(
                    SerialExpressions(
                      [
                        MatchZeroOrMore(
                          allowedEmailNonSymbolsHyphen,
                        ),
                        allowedEmailNonSymbolsExp,
                      ],
                    ),
                    nonCapturing: true,
                  ),
                ),
                CharacterClass.literal(".",),
              ],
            ),
            nonCapturing: true,
          ),
        ),
        allowedEmailNonSymbolsExp,
        CaptureGroup(
          MatchZeroOrOne(
            SerialExpressions(
              [
                allowedEmailNonSymbolsHyphen,
                allowedEmailNonSymbolsExp,
              ],
            ),
          ),
          nonCapturing: true,
        ),
      ],
    ),
    caseSensitive: true,
  );
  final testResult = regex.hasMatch("infinia249@gmail.com",);
  if (kDebugMode) {
    print(regex.pattern,);
    print(testResult,);
  }
}