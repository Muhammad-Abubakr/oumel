part of 'requests_cubit.dart';

enum RequestStatus { accepted, processing, denied, error }

sealed class RequestsState {
  final List<Purchase> requests;
  final RequestStatus? status;
  final String? error;

  const RequestsState({required this.requests, this.status, this.error});
}

final class RequestsInitial extends RequestsState {
  const RequestsInitial({required super.requests, super.status, super.error});
}

final class RequestsUpdate extends RequestsState {
  const RequestsUpdate({required super.requests, super.status, super.error});
}
