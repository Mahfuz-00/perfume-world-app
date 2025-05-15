import 'package:flutter/material.dart';

class OverlayLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return /*Align(
      alignment: Alignment.center,
        child: SizedBox(
            height: 200,
            width: 200,
            child:
                LoadingIndicator()));*/
        Stack(
      children: [
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30, // Adjust to center
          top: MediaQuery.of(context).size.height / 2 - 30, // Adjust to center
          child: Center(
            // This will center the loading indicator
            child: Center(
                child: SizedBox(
                    height: 200, width: 200, child: LoadingIndicator())),
          ),
        ),
      ],
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  final GlobalKey _key = GlobalKey(); // GlobalKey to track the widget

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Check the position after the layout is rendered using the GlobalKey
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _key.currentContext?.findRenderObject() as RenderBox;
      final position =
          renderBox.localToGlobal(Offset.zero); // Get position on the screen
      final screenSize = MediaQuery.of(context).size;
      print("Position: ${position.dx}, ${position.dy}");
      print("Screen size: ${screenSize.width}, ${screenSize.height}");
    });

    return Center(
      child: Center(
        child: Container(
          height: 200,
          width: 200,
          child: CustomPaint(
            key: _key, // Attach the key to this widget
            painter: LogoPainter(animation: _opacityAnimation),
            size: Size(200, 200), // Adjust size as needed
          ),
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  final Animation<double> animation;

  LogoPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final double dotSize = size.width / 12; // Adjust dot size
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Define colors
    final green = const Color(0xFF4CA634);
    final blue = const Color(0xFF133452);

    // Initial grid setup (without animation, this is the base state)
    final List<List<int>> initialGrid = [
      [1, 1, 1, 1, 1],
      [1, 3, 3, 3, 1],
      [1, 0, 3, 3, 1],
      [1, 3, 0, 3, 1],
      [3, 1, 1, 1, 1]
    ];

    // Calculate the offset to center the grid inside the canvas
    final offsetX = (size.width - dotSize * 5) / 2;
    final offsetY = (size.height - dotSize * 5) / 2;

    // Draw the initial grid
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        if (initialGrid[row][col] == 1) {
          paint.color = blue; // Blue
        } else if (initialGrid[row][col] == 3) {
          paint.color = green; // Green
        } else {
          paint.color = Colors.transparent; // No color
        }
        canvas.drawCircle(
            Offset(col * dotSize, row * dotSize), dotSize / 2, paint);
      }
    }

    // Animation sequence grid, progressively revealed
    final List<List<List<int>>> animationSequence = [
      [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [2, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 2, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 2, 0, 0, 0],
        [0, 0, 2, 0, 0],
        [0, 0, 0, 2, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 0, 2, 0, 0],
        [0, 0, 0, 2, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 2, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 0, 2],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 0, 2, 0],
        [0, 0, 0, 0, 2],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 0, 2, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 2],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      [
        [0, 2, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 2],
        [0, 0, 0, 0, 0],
      ],
      [
        [2, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 2],
      ],
      [
        [0, 0, 0, 0, 0],
        [2, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 2, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [2, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 2, 0, 0],
      ],
      [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [2, 0, 0, 0, 0],
        [0, 2, 0, 0, 0],
      ],
    ];

    // Draw animated grid based on animation step
    int step = (animation.value * (animationSequence.length - 1)).round();
    final grid = animationSequence[step];

    // Draw each circle based on the current grid state
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        if (grid[row][col] == 1) {
          paint.color = blue; // Blue
        } else if (grid[row][col] == 3) {
          paint.color = green; // Green
        } else if (grid[row][col] == 2) {
          paint.color = Colors.grey; // Opacity changing
        } else {
          paint.color = Colors.transparent; // No color
        }
        canvas.drawCircle(
            Offset(col * dotSize, row * dotSize), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
