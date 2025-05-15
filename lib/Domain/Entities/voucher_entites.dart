class VoucherEntity {
  final int id;
  final int userId;
  final dynamic date;
  final dynamic ProjectId;
  final dynamic ProjectName;
  final dynamic payeeType;
  final dynamic payeeOthersName;
  final dynamic customerId;
  final dynamic customerName;
  final dynamic supplierId;
  final dynamic supplierName;
  final dynamic paidById;
  final dynamic paidByName;
  final dynamic description;
  final dynamic totalAmount;
  final dynamic purchaseId;
  final dynamic attachment;
  final dynamic saleId;
  final dynamic approverId;
  final dynamic approverName;
  final dynamic status;
  final dynamic createdAt;
  final dynamic updatedAt;

  VoucherEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.ProjectId,
    required this.ProjectName,
    required this.payeeType,
    required this.payeeOthersName,
    this.customerId,
    this.supplierId,
    required this.paidById,
    required this.description,
    required this.totalAmount,
    this.purchaseId,
    this.attachment,
    this.saleId,
    this.approverId,
    required this.approverName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.customerName,
    required this.supplierName,
    required this.paidByName,
  });

  @override
  String toString() {
    return 'VoucherEntity(id: $id, userId: $userId, date: $date, costCenterId: $ProjectId, payeeType: $payeeType, payeeOthersName: $payeeOthersName, customerId: $customerId, supplierId: $supplierId, paidById: $paidById, description: $description, totalAmount: $totalAmount, purchaseId: $purchaseId, attachment: $attachment, saleId: $saleId, approverId: $approverId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
