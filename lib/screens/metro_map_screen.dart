import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_card.dart';

class MetroMapScreen extends StatefulWidget {
  const MetroMapScreen({super.key});

  @override
  State<MetroMapScreen> createState() => _MetroMapScreenState();
}

class _MetroMapScreenState extends State<MetroMapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGradient
            : AppTheme.lightGradient,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Metro Map',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Current Lines'),
                      Tab(text: 'Upcoming'),
                    ],
                  ),
                ),
              ),

              // Tab View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildOperationalLines(), _buildUpcomingLines()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperationalLines() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Zoom Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildZoomButton(Icons.add_rounded, () {
                      setState(() {
                        _scale = (_scale + 0.2).clamp(1.0, 3.0);
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildZoomButton(Icons.remove_rounded, () {
                      setState(() {
                        _scale = (_scale - 0.2).clamp(1.0, 3.0);
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // Metro Map Display
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Metro Lines (Simplified representation)
                      Center(
                        child: Transform.scale(
                          scale: _scale,
                          child: CustomPaint(
                            size: const Size(300, 400),
                            painter: MetroMapPainter(),
                          ),
                        ),
                      ),

                      // Placeholder text
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_rounded,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.6),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Interactive Metro Map',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Zoom in/out to explore',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildUpcomingLines() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildUpcomingProject(
            'Phase 4 Extension',
            'Expected completion: 2027',
            ['Orange Line Extension', 'Magenta Line Extension'],
            [Colors.orange, Colors.pink],
          ),
          const SizedBox(height: 16),
          _buildUpcomingProject(
            'Silver Line',
            'Expected completion: 2028',
            ['New Corridor'],
            [Colors.grey],
          ),
          const SizedBox(height: 16),
          _buildUpcomingProject(
            'Airport Express Extension',
            'Expected completion: 2026',
            ['Airport Line'],
            [Colors.orange],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _buildUpcomingProject(
    String title,
    String completion,
    List<String> lines,
    List<Color> colors,
  ) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(completion, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(lines.length, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lines[index],
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colors[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Custom painter for simplified metro map
class MetroMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Red Line (Horizontal)
    paint.color = const Color(0xFFEF4444);
    canvas.drawLine(
      Offset(20, size.height * 0.3),
      Offset(size.width - 20, size.height * 0.3),
      paint,
    );

    // Blue Line (Vertical)
    paint.color = const Color(0xFF3B82F6);
    canvas.drawLine(
      Offset(size.width * 0.5, 20),
      Offset(size.width * 0.5, size.height - 20),
      paint,
    );

    // Yellow Line (Diagonal)
    paint.color = const Color(0xFFEAB308);
    canvas.drawLine(
      Offset(20, size.height - 20),
      Offset(size.width - 20, 20),
      paint,
    );

    // Green Line (Curved)
    paint.color = const Color(0xFF22C55E);
    final path = Path()
      ..moveTo(20, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width - 20,
        size.height * 0.7,
      );
    canvas.drawPath(path, paint);

    // Draw station nodes
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;

    // Add some station dots
    final stations = [
      Offset(size.width * 0.5, size.height * 0.3), // Interchange
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.7),
    ];

    for (final station in stations) {
      canvas.drawCircle(station, 8, paint);
      paint.color = const Color(0xFF1F2937);
      canvas.drawCircle(station, 5, paint);
      paint.color = Colors.white;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
