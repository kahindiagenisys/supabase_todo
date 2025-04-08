import 'package:flutter/material.dart';

extension FormStateExtensions on FormState? {
  bool get isNotValid => this == null || !this!.validate();
}
