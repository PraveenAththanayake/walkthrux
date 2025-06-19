import 'package:flutter/material.dart';
import 'package:walkthrux/src/controllers/pro_onboard_controller.dart';
import 'package:walkthrux/src/core/models/showcase_config.dart';

class ShowcaseWidget extends StatelessWidget {
  final ShowcaseConfig config;
  final ProOnboarderController controller;
  final Widget child;
  const ShowcaseWidget({
    super.key,
    required this.config,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(key: config.targetKey, child: child);
  }
}
