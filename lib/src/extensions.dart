import 'package:fancy_regex/src/base.dart';
import 'package:fancy_regex/src/boundaries.dart';
import 'package:fancy_regex/src/groups.dart';
import 'package:fancy_regex/src/look_around.dart';
import 'package:fancy_regex/src/quantifiers.dart';
import 'package:fancy_regex/src/raw.dart';

extension RegExpChain on RegExpComponent {

  /// Enclose this with [CaptureGroup], with optional [name].
  /// May be marked as [nonCapturing].
  RegExpComponent toCaptureGroup({
    String? name, bool nonCapturing = false,
  }) {
    return CaptureGroup(
      this, name: name, nonCapturing: nonCapturing,
    );
  }

  /// Enclose this as a non-capturing group
  RegExpComponent toNonCapturingGroup() => CaptureGroup(
    this, nonCapturing: true,
  );

  /// Alternate this with [other] expression
  RegExpComponent alternateWith(RegExpComponent other,) {
    return AlternationGroup(
      [this, other,],
    );
  }

  /// Alternate this with one or more expressions
  RegExpComponent alternateWithMany(List<RegExpComponent> others,) {
    return AlternationGroup(others.isEmpty ? [this,] : others,);
  }

  /// Apply `*` quantifier notation
  RegExpComponent matchZeroOrMore({bool isLazy = false,}) {
    return MatchZeroOrMore(this, isLazy,);
  }

  /// Apply `?` quantifier notation
  RegExpComponent matchZeroOrOne({bool isLazy = false,}) {
    return MatchZeroOrOne(this, isLazy,);
  }

  /// Apply `+` quantifier notation
  RegExpComponent matchOneOrMore({bool isLazy = false,}) {
    return MatchOneOrMore(this, isLazy,);
  }

  /// Apply exact count matching
  RegExpComponent matchExactly(int count,) {
    assert(count >= 0,);
    return MatchExactCount(this, count,);
  }

  /// Match with a minimum repetition count
  RegExpComponent matchAtLeast({required int count, bool isLazy = false,}) {
    return MatchRangedCount(this, count, isLazy: isLazy,);
  }

  /// Match within a minimum and maximum repetition count
  RegExpComponent matchBetween({
    required int start, required int end, bool isLazy = false,
  }) {
    return MatchRangedCount(this, start, end: end, isLazy: isLazy,);
  }

  /// Match if located exactly at the beginning of the input
  RegExpComponent matchInputStart() {
    return InputBoundary(this, start: true,);
  }

  /// Match if the last character aligns with end of input
  RegExpComponent matchInputEnd() {
    return InputBoundary(this, end: true,);
  }

  /// Match both start and the end of the input
  RegExpComponent matchWholeLine() {
    return InputBoundary(this, start: true, end: true,);
  }

  /// Add an [expression] to the left, preceding this
  RegExpComponent addLeft(RegExpComponent expression,) {
    final ref = this;
    if (ref is SerialExpressions) {
      return ref.merge(
        insertLeft: [expression,],
      );
    } else {
      return SerialExpressions(
        [expression, ref,],
      );
    }
  }

  /// Add [expressions] to the left, preceding this
  RegExpComponent addLeftMany(List<RegExpComponent> expressions, {
    bool reversed = false,
  }) {
    final ref = this;
    if (reversed) {
      expressions = expressions.reversed.toList();
    }
    if (ref is SerialExpressions) {
      return ref.merge(
        insertLeft: expressions,
      );
    } else {
      return SerialExpressions(
        [...expressions, ref,],
      );
    }
  }

  /// Add an [expression] to the right, following this
  RegExpComponent addRight(RegExpComponent expression,) {
    final ref = this;
    if (ref is SerialExpressions) {
      return ref.merge(
        insertRight: [expression,],
      );
    } else {
      return SerialExpressions(
        [ref, expression,],
      );
    }
  }

  /// Add [expressions] to the right, following this
  RegExpComponent addRightMany(List<RegExpComponent> expressions,) {
    final ref = this;
    if (ref is SerialExpressions) {
      return ref.merge(
        insertRight: expressions,
      );
    } else {
      return SerialExpressions(
        [ref, ...expressions,],
      );
    }
  }

  /// Apply word boundaries to the start and/or end of this
  RegExpComponent applyWordBoundary({
    bool start = false, bool end = false, bool negated = false,
  }) {
    if (start || end) {
      return WordBound(this, start: start, end: end, negated: negated,);
    }
    return this;
  }

  /// Match if this is preceded by [expression]
  RegExpComponent precededBy(RegExpComponent expression,) {
    return LookAroundExpression(
      this,
      lookBehind: {
        expression: false,
      },
    );
  }

  /// Match if this is preceded by the provided [expressions]
  RegExpComponent precededByMany(List<RegExpComponent> expressions,) {
    return LookAroundExpression(
      this,
      lookBehind: Map.fromEntries(
        expressions.map((e) => MapEntry(e, false,),),
      ),
    );
  }

  /// Match if this is not preceded by [expression]
  RegExpComponent notPrecededBy(RegExpComponent expression,) {
    return LookAroundExpression(
      this,
      lookBehind: {
        expression: true,
      },
    );
  }

  /// Match if this is not preceded by the provided [expressions]
  RegExpComponent notPrecededByMany(List<RegExpComponent> expressions,) {
    return LookAroundExpression(
      this,
      lookBehind: Map.fromEntries(
        expressions.map((e) => MapEntry(e, true,),),
      ),
    );
  }

  /// Match if this is followed by [expression]
  RegExpComponent followedBy(RegExpComponent expression,) {
    return LookAroundExpression(
      this,
      lookAhead: {
        expression: false,
      },
    );
  }

  /// Match if this is followed by the provided [expressions]
  RegExpComponent followedByMany(List<RegExpComponent> expressions,) {
    return LookAroundExpression(
      this,
      lookAhead: Map.fromEntries(
        expressions.map((e) => MapEntry(e, false,),),
      ),
    );
  }

  /// Match if this is not followed by [expression]
  RegExpComponent notFollowedBy(RegExpComponent expression,) {
    return LookAroundExpression(
      this,
      lookAhead: {
        expression: true,
      },
    );
  }

  /// Match if this is not followed by the provided [expressions]
  RegExpComponent notFollowedByMany(List<RegExpComponent> expressions,) {
    return LookAroundExpression(
      this,
      lookAhead: Map.fromEntries(
        expressions.map((e) => MapEntry(e, true,),),
      ),
    );
  }
}