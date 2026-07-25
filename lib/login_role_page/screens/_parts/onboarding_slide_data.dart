// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
class OnboardingSlideData {
  final String title;
  final String body;
  final String illustration;
  final bool showSkip;
  final bool finalSlide;

  const OnboardingSlideData({
    required this.title,
    required this.body,
    required this.illustration,
    this.showSkip = true,
    this.finalSlide = false,
  });
}

