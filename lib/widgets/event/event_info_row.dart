import 'package:flutter/material.dart';

class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const EventInfoRow({super.key, required this.icon, required this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}