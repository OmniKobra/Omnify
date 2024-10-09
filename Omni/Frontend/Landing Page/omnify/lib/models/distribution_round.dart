import 'package:decimal/decimal.dart';

class DistributionRound {
  final int roundNumber;
  final Decimal feesCollected;
  final Decimal profitPerShare;
  Decimal profitsWithdrawn;
  Decimal profitsRemaining;
  final Decimal yourCut;
  bool hasWithdrawn;
  final bool hasHeldTokensEnough;
  final bool roundOpen;
  final DateTime date;
  DistributionRound(
      {required this.roundNumber,
      required this.feesCollected,
      required this.profitPerShare,
      required this.profitsWithdrawn,
      required this.profitsRemaining,
      required this.yourCut,
      required this.hasWithdrawn,
      required this.hasHeldTokensEnough,
      required this.roundOpen,
      required this.date});
  void withdraw() {
    hasWithdrawn = true;
    profitsWithdrawn += yourCut;
    profitsRemaining -= yourCut;
  }
}
