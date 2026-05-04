import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  RatingChangeCallback? onRatingChanged;
  final Color color;

  StarRating({super.key, this.starCount = 5, this.rating = .0, this.onRatingChanged, required this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(Icons.star_border, color: Color(0xFF27914F));
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(Icons.star_half, color: color);
    } else {
      icon = Icon(Icons.star, color: color);
    }
    return InkResponse(onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0), child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}
