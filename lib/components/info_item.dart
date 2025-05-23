import 'package:flutter/material.dart';
import '../theme/colors.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const InfoItem({
    Key? key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGreyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGreyBlue, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
