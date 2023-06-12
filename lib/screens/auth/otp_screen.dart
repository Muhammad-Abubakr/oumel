import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/phone_verification/phone_verification_cubit.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Pinput(
                length: 6,
                controller: pinController,
              ),
              SizedBox(height: 164.h),
              ElevatedButton(
                onPressed: () {
                  context.read<PhoneVerificationCubit>().otpVerification(pinController.text);
                },
                child: const Text('Verify'),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t receive a Code?'),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('send again'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
