import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/purchases/purchases_cubit.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';
import 'package:oumel/screens/edit_profile_screen.dart';

import '../../blocs/user/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserBloc userBloc;
  late User? user;

  @override
  void didChangeDependencies() {
    userBloc = context.watch<UserBloc>();
    user = userBloc.state.user;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PurchasesCubit purchasesCubit = context.watch<PurchasesCubit>();
    final int totalPurchases = purchasesCubit.getPurchasesCount();
    final RequestsCubit requestsCubit = context.watch<RequestsCubit>();
    final int totalSales = requestsCubit.getSalesCount();

    return user == null
        ? const SizedBox()
        : userBloc.state.user!.isAnonymous
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RESTRICTED!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "You will need to login using an Email and Password in order to access this Page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
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
                        user!.photoURL == null
                            ? CircleAvatar(
                                radius: 164.r,
                                child: userBloc.state.user!.photoURL != null
                                    ? CachedNetworkImage(
                                        imageUrl: '${userBloc.state.user!.photoURL}',
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Icon(Icons.person, size: 164.r),
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                radius: 172.r,
                                child: CircleAvatar(
                                  radius: 164.r,
                                  // If the photo url of the user in not null ? show the email pfp
                                  backgroundImage: Image.network(user!.photoURL!).image,
                                ),
                              ),

                        /* Spacing */
                        SizedBox(height: 32.h),

                        /* User name */
                        Text(
                          user!.displayName == null || user!.displayName!.isEmpty
                              ? "Anonymous"
                              : user!.displayName!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        /* Spacing */
                        SizedBox(height: 64.h),

                        /* Edit Profile Button */
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ));
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primary,
                            ),
                            foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: const Text("Edit Profile"),
                        ),
                        /* User Details About Purchases and Sales */
                        //~ TODONE: Wrap each of following with their respective Bloc and listen for changes

                        SizedBox(height: 164.h),

                        /* Details */
                        // Purchases
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Purchases'),
                            Text("$totalPurchases"),
                          ],
                        ),

                        SizedBox(height: 64.h),

                        // Sales
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sales'),
                            Text("$totalSales"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
