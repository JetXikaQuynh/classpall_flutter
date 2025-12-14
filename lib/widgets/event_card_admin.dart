import 'package:flutter/material.dart';

class EventCardAdmin extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final int registered;
  final int capacity;
  final bool isRequired;
  final VoidCallback onTap;

  const EventCardAdmin({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.registered,
    required this.capacity,
    required this.isRequired,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  if (isRequired)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFE0E0), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Bắt buộc', style: TextStyle(color: Color(0xFFE91E63), fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('$date • $time'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(location),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('Đã đăng ký: $registered'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text('Chứa: $capacity'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}