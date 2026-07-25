// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';

class PageFadeRoute<T> extends PageRouteBuilder<T> {
  PageFadeRoute({required WidgetBuilder builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            final slide = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(fade);
            return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
          },
        );
}

