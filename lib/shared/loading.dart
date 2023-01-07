import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[600],
        child:
            Center(child: SpinKitFadingCube(color: Colors.amber, size: 50.0)));
  }
}
