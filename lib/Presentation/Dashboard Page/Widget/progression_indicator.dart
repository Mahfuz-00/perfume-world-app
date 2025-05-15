import 'package:flutter/material.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class InteractiveProgressBar extends StatefulWidget {
  final double initialProgress; // Initial progress (default: 0.0)
  final ValueChanged<double> onProgressChanged; // Callback to notify progress change

  // Constructor to accept initial progress and callback
  const InteractiveProgressBar({
    Key? key,
    this.initialProgress = 0.0,
    required this.onProgressChanged,
  }) : super(key: key);

  @override
  _InteractiveProgressBarState createState() =>
      _InteractiveProgressBarState();
}

class _InteractiveProgressBarState extends State<InteractiveProgressBar> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress; // Initialize with the provided initial progress
  }

  // Function to update progress based on gesture
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final newProgress = (details.localPosition.dx / screenWidth).clamp(0.0, 1.0);
      _progress = newProgress;
    });
    widget.onProgressChanged(_progress); // Notify the parent about the progress change
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate, // Track touch movement
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress bar background
          Container(
            width: double.infinity,
            height: 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), // Round corners
              color: Colors.grey[300], // Background color for the remaining progress
            ),
            child: Stack(
              children: [
                // Foreground (Filled portion of the progress bar)
                Container(
                  width: _progress * MediaQuery.of(context).size.width,
                  height: 8.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0), // Round corners
                    color: AppColors.primary, // Color for the filled portion
                  ),

                ),
              ],
            ),
          ),
          /*const SizedBox(height: 10),

          // Display the percentage (Optional)
          Text(
            '${(_progress * 100).toStringAsFixed(0)}%', // Show progress percentage
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
              fontFamily: 'Roboto'
            ),
          ),*/
        ],
      ),
    );
  }
}
