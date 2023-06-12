import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oumel/blocs/phone_verification/phone_verification_cubit.dart';
import 'package:oumel/screens/auth/otp_screen.dart';

import '../../blocs/user/user_bloc.dart';

class RegisterScreen extends StatefulWidget {
  // route name
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /* Image Picker */
  XFile? _xFile;
  ImageSource? _imageSource;
  final _imagePicker = ImagePicker();

  // Scaffold State
  late ScaffoldMessengerState scaffoldState;

  /* Date time */
  DateTime? dob;

  // Text Field Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    scaffoldState = ScaffoldMessenger.of(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    /* Clearing Scaffold State */
    scaffoldState.clearMaterialBanners();
    scaffoldState.clearSnackBars();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    /* Used for padding for fields */
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return MultiBlocListener(
      listeners: [
        BlocListener<PhoneVerificationCubit, PhoneVerificationState>(
            listener: (context, state) {
          switch (state.status) {
            case VerificationStatus.error:
              // pop the loading indicator
              Navigator.of(context).pop();

              // show snackbar with the error
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.exception!.message!,
                  textAlign: TextAlign.center,
                ),
              ));
              break;

            case VerificationStatus.verified:
              // pop the loading indicator
              Navigator.of(context).pop();

              // pop the otp screen
              Navigator.of(context).pop();

              // // TODO: start process to login with email and password
              registerUser(userBloc);
              break;
            case VerificationStatus.otpSent:
              // pop the loading indicator
              Navigator.of(context).pop();

              // push otp screen
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const OtpScreen()));
              break;
            case VerificationStatus.processing:

              // push the loading indicator
              Navigator.of(context).push(DialogRoute(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.background,
                      ),
                    );
                  }));
              break;

            default:
          }
        }),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: !isLandscape ? 0.08.sw : 0.3.sw,
              vertical: 64.h,
            ),
            child: Column(
              children: [
                /* Disclaimer */
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 72.0.sp),
                    child: Text(
                      'Note: All fields are mandatory *',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                /* Text fields */
                /// First Name
                TextField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    label: Text('First Name'),
                  ),
                ),

                SizedBox(height: 48.h),

                /// last Name
                TextField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    label: Text('Last Name'),
                  ),
                ),

                /// Email
                SizedBox(height: 48.h),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    hintText: 'johnDoe@gmail.com',
                  ),
                ),

                /// Password
                SizedBox(height: 48.h),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                ),

                /// Confirm Password
                SizedBox(height: 48.h),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Confirm Password'),
                  ),
                ),

                /// Phone Number
                SizedBox(height: 48.h),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    label: Text('Phone Number'),
                    helperText:
                        'An SMS will be sent to this number. Standard rates may apply*',
                    helperMaxLines: 2,
                    hintText: '+447975777666',
                  ),
                ),

                SizedBox(height: 64.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select your Date of Birth',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      )),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => DatePickerDialog(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.utc(1940, 1, 1),
                          lastDate: DateTime.now(),
                        ),
                      ).then((value) {
                        // add one day
                        final wrong = value as DateTime;

                        final corrected = DateTime(wrong.year, wrong.month, wrong.day + 1);

                        setState(() {
                          dob = corrected;
                        });
                      }),
                      child: Text(
                          dob == null ? 'Select' : '${dob?.toUtc().toString().split(' ')[0]}'),
                    ),
                  ],
                ),

                SizedBox(height: 164.h),

                /* Profile Picture */
                /* Image Container */
                GestureDetector(
                  /* image_picker */
                  onTap: () => _pickImage(),
                  /* Container */
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24.r)),
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      image: _xFile != null
                          ? DecorationImage(
                              image: Image(
                                image: FileImage(File(_xFile!.path)),
                                fit: BoxFit.cover,
                              ).image,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(1),
                    width: 128.spMax,
                    height: 128.spMax,
                    /* if Picture not Updated/Present */
                    child: _xFile == null
                        ? Text(
                            'Tap here to add a Profile picture',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : null,
                  ),
                ),
                /* Hint for Changing image after Selection */
                if (_xFile != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 64.0.sp),
                    child: Text(
                      'Tap on the image again to change',
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ), // Register Button
                SizedBox(height: 164.h),
                ElevatedButton(
                  // onPressed: () => registerHandler(userBloc),
                  onPressed: () {
                    /* Check if we have any phone number */
                    if (validator(userBloc)) {
                      /* Call the Cubit method to verify phone number */
                      context.read<PhoneVerificationCubit>().phoneAutoVerification(
                            _phoneNumberController.text,
                          );
                    } // else show the error
                    else {}
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Displays a Modal Bootm Sheet with Two Options for _imageSource required by ImagePicker in a Row  */
  Future _pickImageSource() async {
    return await showModalBottomSheet(
      constraints: BoxConstraints.tight(Size.fromHeight(256.h)),
      context: context,
      builder: (bottomSheetContext) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _imageSource = ImageSource.camera;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.camera),
              label: const Text("Camera"),
            ),
            const VerticalDivider(),
            TextButton.icon(
              onPressed: () {
                _imageSource = ImageSource.gallery;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.photo_album),
              label: const Text("Gallery"),
            )
          ],
        ),
      ),
    );
  }

/* No Image Source was specified. This can happen when the Modal Bottom Sheet was dismissed 
without providing the _imageSource value by tapping on either of the 
two sources: Camera or Gallery */
  bool _validateImageSource() {
    if (_imageSource == null) {
      scaffoldState.removeCurrentMaterialBanner();

      scaffoldState.showMaterialBanner(
        MaterialBanner(
          margin: const EdgeInsets.only(bottom: 16.0),
          content: const Text('Operation Cancelled by the User'),
          actions: [
            ElevatedButton(
              child: const Text('Dismiss'),
              onPressed: () => scaffoldState.clearMaterialBanners(),
            )
          ],
        ),
      );

      return false;
    }
    return true;
  }

/* Shows a SnackBar that displays that No image was picked or Captured by the User */
  void _noImagePickedOrCaptured() {
    scaffoldState.removeCurrentSnackBar();

    scaffoldState.showSnackBar(
      SnackBar(
        content: const Text('No image selected by the user'),
        action: SnackBarAction(
          label: 'Dimiss',
          onPressed: () => scaffoldState.clearSnackBars(),
        ),
      ),
    );
  }

  /* Image Picker Utilizer */
  void _pickImage() async {
    // Pick the Image Source
    await _pickImageSource();

    // Check if Image Source is Null, Cancel the Operation
    if (_validateImageSource()) {
      /* Else Pick the Image File */
      _imagePicker.pickImage(source: _imageSource!).then((value) {
        if (value != null) {
          /* Update the xFile */
          setState(() {
            _xFile = value;
          });
        } else {
          /* Show the SnackBar telling the user that no image was selected */
          _noImagePickedOrCaptured();
        }
        /* Set the _imageSource to be Null */
        _imageSource = null;
      });
    }
  }

  bool validator(UserBloc userBloc) {
    /* If any of the fields are empty */
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _xFile == null ||
        dob == null) {
      /* else show the snackbar saying passwords dont match */
      scaffoldState.showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the fields, also select an image and Date of Birth',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return false;
    }
    /* If this fields contain identical passwords Register */
    else if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      /* else show the snackbar saying passwords dont match */
      scaffoldState.showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords don\'t match',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return false;
    } else if (_passwordController.text.isEmpty) {
      scaffoldState.showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a phone number',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return false;
    }

    return true;
  }

  // registerUser
  // // TODONE: Add user birth date and phone number (also need to edit our own User Model)
  void registerUser(UserBloc userBloc) {
    userBloc.add(
      RegisterUserWithEmailAndPassword(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneAuthCredential: context.read<PhoneVerificationCubit>().state.phoneAuthCredential!,
        phoneNumber: _phoneNumberController.text,
        password: _passwordController.text.trim(),
        dob: dob!,
        xFile: _xFile!,
      ),
    );
  }
}
