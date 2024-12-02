import 'package:flutter/material.dart';

Widget headerWidgetAppBar(BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blueGrey.withOpacity(0.3),
          Colors.blue.withOpacity(0.3)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(
                width: 2,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
