import 'package:flutter/material.dart';

import 'components/landing_body.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LandingBody());
  }
}
