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
    final int notRegistered = capacity - registered;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
              // ===== TITLE =====
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isRequired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Bắt buộc',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(color: Colors.grey[700])),

              const SizedBox(height: 12),

              // ===== DATE + TIME =====
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(date),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 6),
                  Text(time),
                ],
              ),

              const SizedBox(height: 8),

              // ===== LOCATION =====
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(location),
                ],
              ),

              const SizedBox(height: 12),

              // ===== REGISTER INFO (ĐIỂM CHỐT) =====
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Đã đăng ký: $registered',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Chưa đăng ký: $notRegistered',
                    style: TextStyle(color: Colors.grey[600]),
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
