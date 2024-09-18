import 'package:flutter/material.dart';
import 'package:tugela/constants/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPaymentsTopup extends StatefulWidget {
  const SettingsPaymentsTopup({super.key});

  @override
  State<SettingsPaymentsTopup> createState() => _SettingsPaymentsTopupState();
}

class _SettingsPaymentsTopupState extends State<SettingsPaymentsTopup> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConfig.paymentsService));
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = context.watch<UserProvider>();
    // final services = userProvider.paymentServices?.data ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("XRP Top-up"),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
