import 'package:flutter/material.dart';

class ShimmerCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ShimmerCard(
      {required this.title, required this.subtitle, this.onTap});

  @override
  State<ShimmerCard> createState() => ShimmerCardState();
}

class ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Card(
            elevation: 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white
                        .withOpacity(0.8 - 0.3 * _shimmerAnimation.value),
                    Colors.white
                        .withOpacity(0.5 + 0.3 * _shimmerAnimation.value)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: widget.onTap, 
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ),
          ),
        );
      },
    );
  }
}
