import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Form VelVet Salon UI', (WidgetTester tester) async {
    // Monta el widget en el árbol de widgets

    // Encuentra un AppBar y verifica que el título es correcto
    expect(
        find.widgetWithText(AppBar, 'Velvet Salon'), findsOneWidget);

    // Verifica que el texto 'Movimientos Incubadora' está en el centro del body
    expect(
        find.widgetWithText(Center, 'Velvet Salon'), findsOneWidget);
  });
}
