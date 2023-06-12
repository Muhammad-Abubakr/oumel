part of 'phone_verification_cubit.dart';

abstract class VerificationDuration {
  static const Duration timeout = Duration(seconds: 120);
}

enum VerificationStatus {
  processing,
  verified,
  otpSent,
  error,
}

abstract class PhoneVerificationState {
  final VerificationStatus? status;
  final FirebaseAuthException? exception;
  final String? verificationId;
  final PhoneAuthCredential? phoneAuthCredential;

  const PhoneVerificationState({
    this.verificationId,
    this.exception,
    this.status,
    this.phoneAuthCredential,
  });
}

class PhoneVerificationInitial extends PhoneVerificationState {
  PhoneVerificationInitial({
    super.verificationId,
    super.exception,
    super.status,
    super.phoneAuthCredential,
  });
}

class PhoneVerificationUpdate extends PhoneVerificationState {
  PhoneVerificationUpdate({
    super.verificationId,
    super.exception,
    super.status,
    super.phoneAuthCredential,
  });
}
