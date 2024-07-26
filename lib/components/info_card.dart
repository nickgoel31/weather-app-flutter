import 'package:flutter/material.dart';

class CustomInfoCard extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temperature;
  const CustomInfoCard({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      //NEW COMPONENT CLIPS THE CARD (OVERFLOW HIDDEN)
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          child: Center(
            child: SizedBox(
              width: 95,
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Icon(
                    icon,
                    size: 35,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    temperature,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(198, 195, 195, 195),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
