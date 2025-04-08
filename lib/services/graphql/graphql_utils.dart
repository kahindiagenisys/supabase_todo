import 'dart:async';
import 'package:ferry/ferry.dart';

enum ServerErrorCodes {
  noData,
  graphResponseError,
  linkExceptionError,
  apolloException,
  cacheException,
  networkError,
  internetError,
  cancellationException,
  illegalArgumentException,
  illegalStateException,
  genericException,
  errorInSavingData,
  errorInBuildingRequest,
}

extension ServerErrorCodesExtension on ServerErrorCodes {
  String get value {
    switch (this) {
      case ServerErrorCodes.noData:
        return "no_data";
      case ServerErrorCodes.graphResponseError:
        return "graph_response_error";
      case ServerErrorCodes.linkExceptionError:
        return "graph_link_exception_error";
      case ServerErrorCodes.apolloException:
        return "apollo_exception";
      case ServerErrorCodes.cacheException:
        return "cache_exception";
      case ServerErrorCodes.networkError:
        return "network_error";
      case ServerErrorCodes.internetError:
        return "internet_error";
      case ServerErrorCodes.cancellationException:
        return "cancellation_exception";
      case ServerErrorCodes.illegalArgumentException:
        return "illegal_argument_exception";
      case ServerErrorCodes.illegalStateException:
        return "illegal_state_exception";
      case ServerErrorCodes.errorInSavingData:
        return "error_in_saving_data";
      case ServerErrorCodes.errorInBuildingRequest:
        return "error_in_building_request";
      default:
        return "generic_exception";
    }
  }
}

Future<DataState<TData, TVars>> getGraphRequestResult<TData, TVars>(
    Future<OperationResponse<TData, TVars>> call) async {
  try {
    var response = await call;

    if (response.hasErrors) {
      if (response.linkException != null) {
        return Error<TData, TVars>(DataSourceException.unExpected(
            response.linkException!.toString(),
            ServerErrorCodes.linkExceptionError));
      }

      return Error<TData, TVars>(DataSourceException.unExpected(
          response.graphqlErrors?.first.message ?? 'undefined graph error',
          ServerErrorCodes.graphResponseError));
    }
    if (response.data != null) {
      return Success<TData, TVars>(response.data as TData);
    }
    return Error<TData, TVars>(
        DataSourceException.unExpected("No data", ServerErrorCodes.noData));
  } catch (e) {
    return Error<TData, TVars>(DataSourceException.unExpected(
        e.toString(), ServerErrorCodes.genericException));
  }
}

DataState<TData, TVars> error<TData, TVars>(
    String message, ServerErrorCodes errorCode) {
  return Error<TData, TVars>(
      DataSourceException.unExpected(message, errorCode));
}

Future<bool> hasStableInternetConnectivity(
    {required bool checkNetworkStability}) async {
  return await Future.value(checkNetworkStability);
}

Future<DataState<TData, TVars>> processNetworkRequestAndSave<TData, TVars>(
    Future<OperationResponse<TData, TVars>> Function() networkCall,
    Future<void> Function(TData) saveCallResult,
    {bool checkNetworkStability = true}) async {
  bool hasInternetConnection = await hasStableInternetConnectivity(
      checkNetworkStability: checkNetworkStability);
  if (!hasInternetConnection) {
    return Error<TData, TVars>(
      DataSourceException.unExpected(
          "LocaleKeys.no_internet_connection", ServerErrorCodes.internetError),
    );
  }

  final responseStatus = await getGraphRequestResult(networkCall());
  if (responseStatus is Success<TData, TVars>) {
    try {
      await saveCallResult(responseStatus.data);
      return Success<TData, TVars>(responseStatus.data);
    } catch (e) {
      return Error<TData, TVars>(
        DataSourceException.unExpected(
          e.toString(),
          ServerErrorCodes.errorInSavingData,
        ),
      );
    }
  } else if (responseStatus is Error<TData, TVars>) {
    return Error<TData, TVars>(responseStatus.exception);
  } else {
    return Error<TData, TVars>(DataSourceException.unExpected(
        "unknown error", ServerErrorCodes.genericException));
  }
}

Stream<DataState<TData, TVars>> processSubscriptionAndSave<TData, TVars>(
  Stream<OperationResponse<TData, TVars>> Function() networkCallStream,
  Future<void> Function(TData) saveCallResult,
) async* {
  var controller = StreamController<DataState<TData, TVars>>();

  yield Loading<TData, TVars>();

  // Start listening to the network call stream
  networkCallStream().listen((response) async {
    if (response.hasErrors) {
      if (response.linkException != null) {
        controller.add(Error<TData, TVars>(DataSourceException.unExpected(
            response.linkException!.toString(),
            ServerErrorCodes.linkExceptionError)));
      } else {
        controller.add(Error<TData, TVars>(DataSourceException.unExpected(
            response.graphqlErrors?.first.message ?? 'undefined graph error',
            ServerErrorCodes.graphResponseError)));
      }
    } else if (response.data != null) {
      try {
        // Save the data received
        await saveCallResult(response.data as TData);
        controller.add(Success<TData, TVars>(response.data as TData));
      } catch (e) {
        controller.add(Error<TData, TVars>(DataSourceException.unExpected(
            e.toString(), ServerErrorCodes.errorInSavingData)));
      }
    } else {
      controller.add(Error<TData, TVars>(
          DataSourceException.unExpected("No data", ServerErrorCodes.noData)));
    }
  }, onError: (error) {
    controller.add(Error<TData, TVars>(DataSourceException.unExpected(
        error.toString(), ServerErrorCodes.genericException)));
  }, onDone: () {
    controller.close();
  });

  // Yield each event from the controller's stream
  yield* controller.stream;
}

abstract class DataState<TData, TVars> {}

class Success<TData, TVars> extends DataState<TData, TVars> {
  final TData data;

  Success(this.data);
}

class Error<TData, TVars> extends DataState<TData, TVars> {
  final DataSourceException exception;

  Error(this.exception);
}

class Loading<TData, TVars> extends DataState<TData, TVars> {}

class DataSourceException implements Exception {
  final String message;
  final ServerErrorCodes errorCode;

  DataSourceException.unExpected(this.message, this.errorCode);

  @override
  String toString() {
    return "DataSourceException: ("
        "message: $message,"
        "errorCode: $errorCode"
        ")";
  }
}

extension DataStateX<TData, TVars> on DataState<TData, TVars> {
  DataState<TData, TVars> onSuccess(void Function(TData) action) {
    if (this is Success<TData, TVars>) {
      action((this as Success<TData, TVars>).data);
    }
    return this;
  }

  DataState<TData, TVars> onError(void Function(DataSourceException) action) {
    if (this is Error<TData, TVars>) {
      action((this as Error<TData, TVars>).exception);
    }
    return this;
  }

  DataState<TData, TVars> onLoading(void Function() action) {
    if (this is Loading<TData, TVars>) action();
    return this;
  }
}
