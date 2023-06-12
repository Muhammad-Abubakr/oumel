import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phone_verification_state.dart';

class PhoneVerificationCubit extends Cubit<PhoneVerificationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PhoneVerificationCubit() : super(PhoneVerificationInitial());

  /* Phone Number Auto Verification */
  void phoneAutoVerification(String phoneNumber) async {
    emit(PhoneVerificationUpdate(
      status: VerificationStatus.processing,
    ));

    /* Try to verify the phone Number */
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: VerificationDuration.timeout,
        verificationCompleted: _handleVerificationCompleted,
        verificationFailed: _handleVerificationFailed,
        codeSent: (verificationId, forceResendingToken) => emit(
          PhoneVerificationUpdate(
            status: VerificationStatus.otpSent,
            verificationId: verificationId,
          ),
        ),
        codeAutoRetrievalTimeout: _handleCodeAutoRetrievalTimeout,
      );

      /* Handle Errors */
    } on FirebaseAuthException catch (e) {
      _handleVerificationFailed(e);
    }
  }

  /* OTP Verification */
  void otpVerification(String otp) async {
    emit(PhoneVerificationUpdate(
      status: VerificationStatus.processing,
      verificationId: state.verificationId,
    ));

    try {
      /* Get the login creds */
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: otp,
      );

      /* Verification Successful */
      emit(PhoneVerificationUpdate(
        verificationId: cred.verificationId,
        phoneAuthCredential: cred,
        status: VerificationStatus.verified,
      ));
    } on FirebaseAuthException catch (e) {
      _handleVerificationFailed(e);
    }
  }

  /* Handlers */
  void _handleVerificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    emit(PhoneVerificationUpdate(
      status: VerificationStatus.verified,
      verificationId: phoneAuthCredential.verificationId,
    ));
  }

  void _handleVerificationFailed(FirebaseAuthException error) {
    emit(PhoneVerificationUpdate(
      exception: error,
      status: VerificationStatus.error,
    ));
  }

  void _handleCodeAutoRetrievalTimeout(String verificationId) {
    emit(PhoneVerificationUpdate(
      exception: FirebaseAuthException(
        code: 'auth/sms-retreival-timeout',
        message: 'Sms didn\'t received in the valid time period.',
      ),
      status: VerificationStatus.error,
    ));
  }
}
