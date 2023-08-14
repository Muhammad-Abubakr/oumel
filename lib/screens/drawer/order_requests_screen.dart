import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/models/purchase.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';
import 'package:oumel/widgets/order_request_widget.dart';

class OrderRequestsScreen extends StatefulWidget {
  const OrderRequestsScreen({super.key});

  @override
  State<OrderRequestsScreen> createState() => _OrderRequestsScreenState();
}

class _OrderRequestsScreenState extends State<OrderRequestsScreen> {
  OrderStatus filterBy = OrderStatus.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Requests"),
        actions: [
          Row(
            children: [
              const Text(
                'Filter by : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: filterBy,
                items: OrderStatus.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            describeEnum(e),
                          ),
                        ))
                    .toList(),
                onChanged: (category) => setState(() {
                  filterBy = category ?? filterBy;
                }),
              )
            ],
          )
        ],
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
        builder: (context, state) {
          /* Filter the Items based on the present filter */
          List<Purchase> filterdItems = List.empty(growable: true);
          if (filterBy != OrderStatus.none) {
            filterdItems = state.requests.where((p) => p.order.status == filterBy).toList();
          } else {
            filterdItems = state.requests;
          }

          return state.requests.isEmpty
              ? const Center(
                  child: Text("Nothing here for now."),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 36.h),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) => OrderRequestWidget(filterdItems[index]),
                  itemCount: filterdItems.length,
                );
        },
      ),
    );
  }
}
