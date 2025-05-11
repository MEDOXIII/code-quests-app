import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:roshetta/core/widgets/offline_widget.dart';

class InternetConnectionChecker extends StatelessWidget {
  final Widget body;
  const InternetConnectionChecker({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        List<ConnectivityResult> connectivity,
        Widget child,
      ) {
        final bool connected = !connectivity.contains(ConnectivityResult.none);

        if (connected) {
          return body;
        } else {
          return const OfflineWidget();
        }
      },
      child: const MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
