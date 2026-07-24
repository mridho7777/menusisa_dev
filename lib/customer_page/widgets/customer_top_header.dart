import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerTopHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final bool showNotification;
  final String subtitle;

  const CustomerTopHeader({
    super.key,
    this.onNotificationTap,
    this.showNotification = true,
    this.subtitle = 'Beranda',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/svg/logonotext.svg', width: 72, height: 72),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MenuSisa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
        if (showNotification)
          IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(Icons.notifications_none_outlined),
          ),
      ],
    );
  }
}
