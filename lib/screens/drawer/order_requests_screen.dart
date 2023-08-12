import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';
import 'package:oumel/widgets/order_request_widget.dart';

class OrderRequestsScreen extends StatelessWidget {
  const OrderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Requests"),
      ),
      body: BlocConsumer<RequestsCubit, RequestsState>(
        listener: (context, state) {
          switch (state.status) {
            case RequestStatus.processing:
              Navigator.of(context).push(DialogRoute(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.background,
                      ),
                    );
                  }));

              break;
            case RequestStatus.accepted:
              // first clear the progress indicator
              Navigator.of(context).pop();

              // and Clear the State for snackbars
              ScaffoldMessenger.of(context).clearSnackBars();

              // Then show New
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  "Request Accepted",
                  textAlign: TextAlign.center,
                )),
              );
              break;
            case RequestStatus.denied:
              // first clear the progress indicator
              Navigator.of(context).pop();

              // and Clear the State for snackbars
              ScaffoldMessenger.of(context).clearSnackBars();

              // Then show New
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  "Request Denied",
                  textAlign: TextAlign.center,
                )),
              );
              break;
            case RequestStatus.error:
              // first clear the progress indicator
              Navigator.of(context).pop();

              // and Clear the State for snackbars
              ScaffoldMessenger.of(context).clearSnackBars();

              // Then show New
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  "${state.error}",
                  textAlign: TextAlign.center,
                )),
              );
              break;
            default:
              break;
          }
        },

        //* Builder
        builder: (context, state) => state.requests.isEmpty
            ? const Center(
                child: Text("Nothing here for now."),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 36.h),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) => OrderRequestWidget(state.requests[index]),
                itemCount: state.requests.length,
              ),
      ),
    );
  }
}
