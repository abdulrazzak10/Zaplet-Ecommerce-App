class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;
  final Map<String, dynamic> specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isNew = false,
    this.isFeatured = false,
    required this.specifications,
  });

  // Mock data for testing
  static List<Product> getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Apple AirPods Pro',
        description: 'Active noise cancellation for immersive sound. Transparency mode for hearing the world around you. A more comfortable fit.',
        price: 249.99,
        imageUrl: 'assets/images/product.jpg',
        category: 'Audio',
        rating: 4.8,
        reviewCount: 1250,
        isNew: true,
        isFeatured: true,
        specifications: {
          'Battery Life': 'Up to 6 hours',
          'Noise Cancellation': 'Yes',
          'Water Resistant': 'IPX4',
          'Connectivity': 'Bluetooth 5.0',
        },
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S23 Ultra',
        description: 'The most powerful Galaxy smartphone with an advanced camera system and S Pen.',
        price: 1199.99,
        imageUrl: 'assets/images/product2.jpg',
        category: 'Smartphones',
        rating: 4.9,
        reviewCount: 850,
        isNew: true,
        isFeatured: true,
        specifications: {
          'Display': '6.8" Dynamic AMOLED 2X',
          'Processor': 'Snapdragon 8 Gen 2',
          'RAM': '12GB',
          'Storage': '256GB',
          'Camera': '200MP + 12MP + 10MP + 10MP',
        },
      ),
      Product(
        id: '3',
        name: 'MacBook Pro M2',
        description: 'Supercharged by M2 Pro or M2 Max, MacBook Pro takes its power and speed further than ever.',
        price: 1999.99,
        imageUrl: 'assets/images/product3.jpg',
        category: 'Laptops',
        rating: 4.9,
        reviewCount: 620,
        isFeatured: true,
        specifications: {
          'Processor': 'Apple M2 Pro',
          'Memory': '16GB',
          'Storage': '512GB SSD',
          'Display': '14.2" Liquid Retina XDR',
          'Battery': 'Up to 18 hours',
        },
      ),
      Product(
        id: '4',
        name: 'Sony WH-1000XM5',
        description: 'Industry-leading noise canceling headphones with exceptional sound quality.',
        price: 399.99,
        imageUrl: 'assets/images/product4.jpg',
        category: 'Audio',
        rating: 4.8,
        reviewCount: 430,
        specifications: {
          'Battery Life': 'Up to 30 hours',
          'Noise Cancellation': 'Yes',
          'Bluetooth': '5.2',
          'Weight': '250g',
        },
      ),
      Product(
        id: '5',
        name: 'Apple Watch Series 8',
        description: 'Advanced health features, a powerful dual-core processor, and a brighter Always-On display.',
        price: 399.99,
        imageUrl: 'assets/images/product5.jpg',
        category: 'Wearables',
        rating: 4.7,
        reviewCount: 890,
        isNew: true,
        specifications: {
          'Display': 'Always-On Retina',
          'Battery Life': 'Up to 18 hours',
          'Water Resistant': '50m',
          'Health Features': 'ECG, Blood Oxygen',
        },
      ),
    ];
  }
} 