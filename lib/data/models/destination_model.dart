class DestinationModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String ticketPrice;
  final String openHours;
  final List<String> gallery;
  final List<String> facts;
  final String? quizId; // ID kuis yang berkaitan dengan destinasi ini

  DestinationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.ticketPrice,
    required this.openHours,
    required this.gallery,
    required this.facts,
    this.quizId,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      category: json['category'],
      imageUrl: json['image_url'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      ticketPrice: json['ticket_price'],
      openHours: json['open_hours'],
      gallery: List<String>.from(json['gallery'] ?? []),
      facts: List<String>.from(json['facts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'category': category,
      'image_url': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'ticket_price': ticketPrice,
      'open_hours': openHours,
      'gallery': gallery,
      'facts': facts,
    };
  }
}
