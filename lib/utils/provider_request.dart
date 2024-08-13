import 'package:flutter/widgets.dart';
import 'package:tugela/models/api_response.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/feedback/dialog.dart';
import 'package:tugela/widgets/indicators/loading_screen.dart';

class ProviderRequest {
  ProviderRequest._();

  static Future<void> api<T>({
    required BuildContext context,
    required Future<ApiResponse<T>?> request,

    /// Runs after a successful request
    Future<dynamic> Function(BuildContext context)? postRequest,
    required void Function(BuildContext context, ApiResponse<T> result)
        onSuccess,
    void Function(BuildContext context)? onError,
    void Function(BuildContext context, ApiError? error)? onApiError,
    bool loadingScreen = true,
    String loadingMessage = "Loading",
    bool useRootNavigator = true,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    bool loading = false;
    try {
      if (loadingScreen) {
        loading = true;
        navigator.push(LoadingScreen(message: loadingMessage));
      }
      final res = await request;
      if (postRequest != null) {
        if (res?.error == null && (res != null && res.data != null)) {
          if (context.mounted) await postRequest.call(context);
        }
      }
      if (loadingScreen && context.mounted) {
        loading = false;
        navigator.pop(context);
      }
      if ((res?.error != null)) {
        if (onApiError == null) {
          final details = res?.error?.details?.values.map((e) {
            if (e is List) return e.join('\n');
            return e;
          }).join('\n');
          final message = details ?? "An error occurred";
          handleError(message, stackTrace: StackTrace.current);
          if (!context.mounted) return;
          await showAppDialog(
            context,
            title: "Error",
            message: message,
          );
        } else {
          if (!context.mounted) return;
          return onApiError(context, res?.error);
        }
      } else if (res == null || res.data == null) {
        if (!context.mounted) return;
        if (onError == null) {
          await showAppDialog(
            context,
            title: "Error",
            message: "An error occurred while making the request",
          );
        } else {
          return onError.call(context);
        }
      } else {
        if (!context.mounted) return;
        return onSuccess(context, res);
      }
    } catch (e, s) {
      if (loading && context.mounted) navigator.pop(context);
      handleError(e, stackTrace: s);
      if (!context.mounted) return;
      if (onError == null || e is UnimplementedError) {
        await showAppDialog(
          context,
          title: "Error",
          message: "An error occurred while making the request",
        );
      } else {
        return onError.call(context);
      }
    }
  }
}
