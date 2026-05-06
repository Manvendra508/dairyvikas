class BonusPenaltyStep {
  final double start;
  final double end;
  final double amount;
  final bool isBonus; // true = bonus, false = penalty

  BonusPenaltyStep({
    required this.start,
    required this.end,
    required this.amount,
    required this.isBonus,
  });
}
