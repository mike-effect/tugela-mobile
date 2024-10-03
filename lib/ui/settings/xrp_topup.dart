import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XRPTopup extends StatefulWidget {
  const XRPTopup({super.key});

  @override
  State<XRPTopup> createState() => _XRPTopupState();
}

class _XRPTopupState extends State<XRPTopup> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProvider>();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            if (kDebugMode) debugPrint(url);
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            handleError(error.url);
            handleError(error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(AppConfig.transakUrl(
          action: "topup",
          walletAddress: provider.user?.xrpAddress ?? "",
          email: provider.user?.company?.email ?? "",
          userData: {
            "mobileNumber": provider.user?.company?.phoneNumber ?? "",
          },
        )),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XRP Top-up"),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
