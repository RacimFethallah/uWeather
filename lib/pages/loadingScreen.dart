import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  
  get backgroundColor => null;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: theme.primaryColor,
        ),
      ),
    );
  }
}
