class KhatabookUserEntity {
  final int khatabookUserId;
  final String name;
  final String mobile;
  final double totalDebit;
  final double totalCredit;
  final double balance;
  final String latestEntryDate;

  const KhatabookUserEntity({
    required this.khatabookUserId,
    required this.name,
    required this.mobile,
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
    required this.latestEntryDate,
  });
}
