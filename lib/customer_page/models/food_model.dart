// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
class FoodModel {
  final String image;
  final String name;
  final String store;
  final String description;
  final double rating;
  final int price;

  FoodModel({
    required this.image,
    required this.name,
    required this.store,
    required this.description,
    required this.rating,
    required this.price,
  });
}
