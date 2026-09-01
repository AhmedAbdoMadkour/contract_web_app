import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/payment_certificate_model.dart';
import 'payment_certificate_state.dart';

class PaymentCertificateCubit extends Cubit<PaymentCertificateState> {
  PaymentCertificateCubit() : super(const PaymentCertificateState());

  void loadDummyData() {
    emit(state.copyWith(status: PaymentCertificateStatus.loading));
    try {
      // Simulate API call
      final dummyItems = [
        const PaymentCertificateItemModel(
          id: '1',
          description: 'Excavation Work',
          unitPrice: 150.0,
          quantityPrevious: 100,
          quantityCurrent: 50,
          quantityTotal: 150,
        ),
        const PaymentCertificateItemModel(
          id: '2',
          description: 'Concrete Foundation',
          unitPrice: 300.0,
          quantityPrevious: 200,
          quantityCurrent: 100,
          quantityTotal: 300,
        ),
      ];

      final totalPrevious = dummyItems.fold<double>(
          0, (sum, item) => sum + item.totalPrevious);
      final currentTotal = dummyItems.fold<double>(
          0, (sum, item) => sum + item.totalCurrent);
      final netPayable = currentTotal; // Assuming net payable is current total

      final certificate = PaymentCertificateModel(
        id: 'cert_001',
        contractId: 'contract_123',
        vendorName: 'Acme Corp',
        projectName: 'City Center Mall',
        date: DateTime.now(),
        certificateNumber: 'PC-2023-01',
        items: dummyItems,
        totalPrevious: totalPrevious,
        currentTotal: currentTotal,
        netPayable: netPayable,
        approval: const PaymentCertificateApprovalModel(
          isApprovedByEngineering: false,
          isApprovedByFinance: false,
          comments: '',
        ),
      );

      emit(state.copyWith(
        status: PaymentCertificateStatus.success,
        certificate: certificate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentCertificateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateItemQuantity(String itemId, double currentQuantity) {
    if (state.certificate == null) return;

    final updatedItems = state.certificate!.items.map((item) {
      if (item.id == itemId) {
        final newTotalQty = item.quantityPrevious + currentQuantity;
        return item.copyWith(
          quantityCurrent: currentQuantity,
          quantityTotal: newTotalQty,
        );
      }
      return item;
    }).toList();

    _recalculateTotals(updatedItems);
  }

  void _recalculateTotals(List<PaymentCertificateItemModel> items) {
    if (state.certificate == null) return;

    final totalPrevious =
        items.fold<double>(0, (sum, item) => sum + item.totalPrevious);
    final currentTotal =
        items.fold<double>(0, (sum, item) => sum + item.totalCurrent);
    final netPayable = currentTotal;

    final updatedCertificate = state.certificate!.copyWith(
      items: items,
      totalPrevious: totalPrevious,
      currentTotal: currentTotal,
      netPayable: netPayable,
    );

    emit(state.copyWith(
      certificate: updatedCertificate,
      status: PaymentCertificateStatus.success, // Ensure state registers change
    ));
  }

  void approveByEngineering(String comments) {
    if (state.certificate == null) return;

    final updatedApproval =
        (state.certificate!.approval ?? const PaymentCertificateApprovalModel(
      isApprovedByEngineering: false,
      isApprovedByFinance: false,
      comments: '',
    ))
            .copyWith(
      isApprovedByEngineering: true,
      comments: comments,
    );

    emit(state.copyWith(
      certificate: state.certificate!.copyWith(approval: updatedApproval),
    ));
  }

  void approveByFinance(String comments) {
    if (state.certificate == null) return;

    final updatedApproval =
        (state.certificate!.approval ?? const PaymentCertificateApprovalModel(
      isApprovedByEngineering: false,
      isApprovedByFinance: false,
      comments: '',
    ))
            .copyWith(
      isApprovedByFinance: true,
      comments: comments,
    );

    emit(state.copyWith(
      certificate: state.certificate!.copyWith(approval: updatedApproval),
    ));
  }
}
