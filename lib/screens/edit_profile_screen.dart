import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oumel/blocs/database_user/database_user_cubit.dart';
import 'package:pinput/pinput.dart';

import '../blocs/user/user_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Image Picker
  ImageSource? _imageSource;
  final _imagePicker = ImagePicker();

  // controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  // Scaffold State
  late ScaffoldMessengerState scaffoldState;

  // blocs and cubits
  late UserBloc userBloc;
  late DatabaseUserCubit userCubit;

  @override
  void didChangeDependencies() {
    // updating scaffold context
    scaffoldState = ScaffoldMessenger.of(context);

    // blocs and cubits initialization
    userBloc = context.watch<UserBloc>();
    userCubit = context.watch<DatabaseUserCubit>();

    // intializing the controllers text
    final user = userBloc.state.user!;

    // display name
    nameController.setText(user.displayName == null || user.displayName!.isEmpty
        ? "Anonymous"
        : user.displayName!);

    // about
    if (userCubit.state.user != null) {
      aboutController.setText(userCubit.state.user!.about);
    }

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    // CLearing Scaffold State before popping
    scaffoldState.clearMaterialBanners();
    scaffoldState.clearSnackBars();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            onPressed: () {
              userCubit.state.user == null ? null : _profileUpdate(userBloc, userCubit);
            },
            icon: const Icon(Icons.save),
            label: const Text('save'),
            style: TextButton.styleFrom(
                foregroundColor: userCubit.state.user == null
                    ? Colors.grey
                    : Theme.of(context).primaryColor),
          )
        ],
      ),
      body: userCubit.state.user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : SizedBox(
              height: 1.0.sh,
              width: 1.0.sw,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 0.1.sw,
                    right: 0.1.sw,
                    top: 0.04.sh,
                    bottom: 0.1.sh,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /* User pfp */
                      GestureDetector(
                        // Handler for picking image
                        onTap: () => _pickImage(),

                        // Ternary Operation: image present ? show : show placeholder icon;
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            userBloc.state.user!.photoURL == null
                                ? CircleAvatar(
                                    radius: 164.r,
                                    child: Icon(Icons.person, size: 164.r),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    radius: 204.r,
                                    child: CircleAvatar(
                                      radius: 196.r,
                                      // If the photo url of the user in not null ? show the email pfp
                                      backgroundImage:
                                          Image.network(userBloc.state.user!.photoURL!).image,
                                    ),
                                  ),
                            CircleAvatar(
                              radius: 48.r,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              child: Icon(Icons.edit, size: 48.r),
                            ),
                          ],
                        ),
                      ),
                      /* Spacing */
                      SizedBox(height: 96.h),

                      /* User name */
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Display Name'),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                        textAlign: TextAlign.center,
                        controller: nameController,
                      ),
                      /* Spacing */
                      SizedBox(height: 96.h),

                      /* Description */
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('About Me'),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                        minLines: 8,
                        maxLines: 12,
                        textAlign: TextAlign.center,
                        controller: aboutController,
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
          /* Update the User Profile Picture */
          context.read<UserBloc>().add(UserPfpUpdate(xFile: value));
        } else {
          /* Show the SnackBar telling the user that no image was selected */
          _noImagePickedOrCaptured();
        }
        /* Set the _imageSource to be Null */
        _imageSource = null;
      });
    }
  }

  /* Update handler */
  void _profileUpdate(UserBloc userBloc, DatabaseUserCubit userCubit) async {
    /* Update display Name and about 
       as picture update is already 
       handeled in user bloc  */

    // updating display name
    userBloc.add(UserDisplayNameUpdate(name: nameController.text.trim()));

    // update the about in database user
    userCubit.updateAbout(aboutController.text.trim());
  }
}
