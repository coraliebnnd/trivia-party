import 'package:flutter/material.dart';

class CategoryPreparation extends StatelessWidget {
  final String category; // The name of the selected category
  final Color categoryColor; // The color associated with the category
  final int countdown; // Countdown number

  const CategoryPreparation({
    Key? key,
    required this.category,
    required this.categoryColor,
    this.countdown = 2, // Default countdown value is 2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: categoryColor, // Background color based on category
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Next Question's Category Text
            const Text(
              "Next question’s\ncategory :",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Category Name
            Text(
              category,
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            // Countdown Timer
            Column(
              children: [
                Text(
                  '$countdown',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "⟳", // Representing circular countdown
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50), // Adjust spacing as needed
          ],
        ),
      ),
    );
  }
}
