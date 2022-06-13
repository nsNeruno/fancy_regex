import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fancy_regex/fancy_regex.dart';

void main() {
  group(
    "Fancy Regex Test",
    () {
      test(
        'Basic RegExp Example',
        () {
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
          }
          expect(matches.isNotEmpty, true,);

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
          }
          expect(matches.isNotEmpty, true,);
        },
      );

      test(
        'Indonesian Phone Number',
        () {
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
          }
          expect(testResult, true,);
        },
      );

      test(
        'Indonesian Phone Number (Ext)',
        () {
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
          }
          expect(testResult, true,);
        },
      );

      test(
        'RFC2822 Email Validation',
        () {
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
          }
          expect(testResult, true,);
        },
      );
    },
  );
}
