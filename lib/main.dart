import 'package:flutter/material.dart';
import 'implementations/vanilla/vanilla_app.dart';
export 'implementations/vanilla/vanilla_app.dart' show VanillaApp;

// Plan item 1: only Flutter SDK state management (setState + InheritedWidget).
void main() => runApp(const VanillaApp());
