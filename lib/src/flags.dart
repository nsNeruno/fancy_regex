enum RegExpFlag {
  global,
  caseInsensitive,
  multiline,
  singleLine,
  unicode,
  sticky,
}

extension RegExpFlagSymbols on RegExpFlag {

  String get symbol {
    switch (this) {
      case RegExpFlag.global:
        return "g";
      case RegExpFlag.caseInsensitive:
        return "i";
      case RegExpFlag.multiline:
        return "m";
      case RegExpFlag.singleLine:
        return "s";
      case RegExpFlag.unicode:
        return "u";
      case RegExpFlag.sticky:
        return "y";
    }
  }
}

// class FlaggedExpression implements RegExpComponent {
//
//   FlaggedExpression(this.expression, [this.flags,]);
//
//   final RegExpComponent expression;
//   final Set<RegExpFlag>? flags;
//
//   @override
//   String toString() {
//     final flags = this.flags;
//     if (flags != null) {
//       final sortedFlags = flags.toList()
//         ..sort(
//           (a, b,) => a.index.compareTo(b.index,),
//         );
//       return "$expression${}"
//     }
//     return expression.toString();
//   }
// }