import 'package:decimal/decimal.dart';

import 'installment_payments.dart';

class InstallmentPlan {
  final String paymentID;
  final String vendorAddress;
  final String payerAddress;
  final Decimal amountTotal;
  final Decimal downpayment;
  Decimal amountPaid;
  final Decimal plan;
  bool isComplete;
  bool isDue;
  bool isOngoing;
  final int installmentsQuantity;
  int installmentsComplete;
  final List<InstallmentPayment> installments;
  final DateTime upcomingPaymentDate;
  final DateTime startingDate;
  Decimal calculateFinalInstallment() {
    if (installmentsQuantity > 1) {
      Decimal totalPaidInstallments =
          plan * Decimal.parse("${installmentsQuantity - 1}");
      var buffer = totalPaidInstallments + downpayment;
      Decimal remains = amountTotal - buffer;
      return remains;
    } else {
      return plan;
    }
  }

  void payInstallment() {
    installmentsComplete++;
    var remains = installmentsQuantity - installmentsComplete;
    if (remains == 0) {
      // amountPaid += calculateFinalInstallment();
      isComplete = true;
      isDue = false;
      isOngoing = false;
    } else {
      // amountPaid += plan;
      if (!installments
          .any((i) => i.dateDue.isBefore(DateTime.now()) && !i.isPaid)) {
        isDue = false;
      }
    }
  }

  InstallmentPlan(
      {required this.paymentID,
      required this.vendorAddress,
      required this.payerAddress,
      required this.amountTotal,
      required this.amountPaid,
      required this.plan,
      required this.isComplete,
      required this.isDue,
      required this.isOngoing,
      required this.installmentsQuantity,
      required this.installmentsComplete,
      required this.installments,
      required this.downpayment,
      required this.startingDate,
      required this.upcomingPaymentDate});
}
