import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  Color getColorFromPercentage(double percentage) {
    percentage = percentage.clamp(0, 100);
    double ratio = percentage / 100;
    Color redColor = Colors.red;
    Color greenColor = Colors.green;
    int red =
        (redColor.red + ((greenColor.red - redColor.red) * ratio)).toInt();
    int green = (redColor.green + ((greenColor.green - redColor.green) * ratio))
        .toInt();
    int blue =
        (redColor.blue + ((greenColor.blue - redColor.blue) * ratio)).toInt();

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (score * 100) / total;
    Color percentageColor = getColorFromPercentage(percentage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Votre score est de:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$score / $total',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              '${percentage.toStringAsFixed(1)} %',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: percentageColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
