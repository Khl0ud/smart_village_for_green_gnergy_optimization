import 'package:flutter/material.dart';
import 'main_shell.dart';

/// Camera module widget — part of the larger app.
/// This file no longer creates a standalone `MaterialApp` or `main()`.
class CameraMain extends StatelessWidget {
  const CameraMain({super.key});

  @override
  Widget build(BuildContext context) {
    // The hosting app should provide the top-level MaterialApp and theme.
    return const MainShell();
  }
}
