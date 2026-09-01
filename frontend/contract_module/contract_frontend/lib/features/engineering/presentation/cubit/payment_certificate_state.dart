import 'package:equatable/equatable.dart';
import '../../data/model/payment_certificate_model.dart';

enum PaymentCertificateStatus { initial, loading, success, failure }

class PaymentCertificateState extends Equatable {
  final PaymentCertificateStatus status;
  final PaymentCertificateModel? certificate;
  final String errorMessage;

  const PaymentCertificateState({
    this.status = PaymentCertificateStatus.initial,
    this.certificate,
    this.errorMessage = '',
  });

  PaymentCertificateState copyWith({
    PaymentCertificateStatus? status,
    PaymentCertificateModel? certificate,
    String? errorMessage,
  }) {
    return PaymentCertificateState(
      status: status ?? this.status,
      certificate: certificate ?? this.certificate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, certificate, errorMessage];
}
