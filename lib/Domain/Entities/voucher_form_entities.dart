class VoucherFormEntity {
  final dynamic date;
  final dynamic costCenterId;
  final dynamic description;
  final dynamic paidStatus;
  final List<String> accountIds;
  final List<double> amounts;
  final dynamic attachment;

  VoucherFormEntity({
    required this.date,
    required this.costCenterId,
    required this.description,
    required this.paidStatus,
    required this.accountIds,
    required this.amounts,
    this.attachment,
  });
}
