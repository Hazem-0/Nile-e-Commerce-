import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Ratingx extends StatelessWidget {
  final double rating;
  final double size;
  Ratingx({super.key, required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      ignoreGestures: true,
      itemSize: size,
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      // itemPadding: EdgeInsets.symmetric(horizontal: 2),
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        half: const Icon(
          Icons.star_half_sharp,
          color: Colors.amber,
        ),
        empty: const Icon(
          Icons.star,
          color: Colors.grey,
        ),
      ),
      onRatingUpdate: (value) {
        value = rating;
      },
    );
  }
}
