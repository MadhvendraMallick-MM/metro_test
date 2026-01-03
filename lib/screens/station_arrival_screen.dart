import 'package:flutter/material.dart';
import '../data/metro_data.dart';

class StationArrivalScreen extends StatelessWidget {
  final String stationName;
  final String nextStation;
  final String line;

  const StationArrivalScreen({
    super.key,
    required this.stationName,
    required this.nextStation,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Metro Map Visual
            _buildMetroMapSection(context),

            // Station Info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Now approaching :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stationName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notification_important_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You are approaching $stationName Station. Please switch to Metro 2 to go to your destination.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Next Station Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '››',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Next Station: $nextStation',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '‹‹',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Options Grid
                  _buildOptionsGrid(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetroMapSection(BuildContext context) {
    final lineColor = _getColorFromLine(line);
    
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.grey[100],
      child: CustomPaint(
        painter: MetroLinePainter(lineColor: lineColor),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              stationName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Station Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildOptionCard(
              icon: Icons.currency_rupee_rounded,
              title: 'Fare Info',
              color: const Color(0xFF22C55E),
              onTap: () => _showFareInfo(context),
            ),
            _buildOptionCard(
              icon: Icons.wc_rounded,
              title: 'Washroom',
              color: const Color(0xFF3B82F6),
              onTap: () => _showWashroomInfo(context),
            ),
            _buildOptionCard(
              icon: Icons.local_parking_rounded,
              title: 'Parking',
              color: const Color(0xFFF97316),
              onTap: () => _showParkingInfo(context),
            ),
            _buildOptionCard(
              icon: Icons.star_rounded,
              title: 'Rate App',
              color: const Color(0xFFFBBF24),
              onTap: () => _showRatingDialog(context),
            ),
            _buildOptionCard(
              icon: Icons.restaurant_rounded,
              title: 'Food Court',
              color: const Color(0xFFEC4899),
              onTap: () => _showFoodCourtInfo(context),
            ),
            _buildOptionCard(
              icon: Icons.info_outline_rounded,
              title: 'About',
              color: const Color(0xFF8B5CF6),
              onTap: () => _showAboutInfo(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFareInfo(BuildContext context) {
    final fare = MetroData.getFare(stationName, 'Any Station');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fare Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFareRow('Token Fare', '₹${fare.tokenFare}', Colors.blue),
            _buildFareRow('Smart Card', '₹${fare.smartCardFare}', Colors.green),
            _buildFareRow('Off-Peak', '₹${fare.offPeakFare}', Colors.orange),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showWashroomInfo(BuildContext context) {
    _showInfoSheet(
      context,
      'Washroom Facilities',
      'Clean washrooms are available on Platform 1 and near the main entrance. Facilities include disabled-accessible toilets.',
      Icons.wc_rounded,
      const Color(0xFF3B82F6),
    );
  }

  void _showParkingInfo(BuildContext context) {
    _showInfoSheet(
      context,
      'Parking Information',
      'Multi-level parking available with 200+ slots. ₹20 for first 2 hours, ₹10 per additional hour. Open 24/7.',
      Icons.local_parking_rounded,
      const Color(0xFFF97316),
    );
  }

  void _showFoodCourtInfo(BuildContext context) {
    _showInfoSheet(
      context,
      'Food Court',
      'Food court available on ground floor with 10+ restaurants and fast food options. Open from 8 AM to 10 PM.',
      Icons.restaurant_rounded,
      const Color(0xFFEC4899),
    );
  }

  void _showAboutInfo(BuildContext context) {
    _showInfoSheet(
      context,
      'About Metro Navigator',
      'Metro Navigator v1.0.0\n\nDesigned to help you navigate the metro system with ease. Features include route planning, fare calculation, and real-time updates.\n\n© 2024 Metro Navigator',
      Icons.info_outline_rounded,
      const Color(0xFF8B5CF6),
    );
  }

  void _showInfoSheet(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rate Our App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How would you rate your experience?'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: const Icon(Icons.star_rounded),
                  color: const Color(0xFFFBBF24),
                  iconSize: 40,
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for rating ${index + 1} stars!'),
                        backgroundColor: const Color(0xFF22C55E),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromLine(String lineName) {
    final colorHex = MetroData.getLineColor(lineName);
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }
}

class MetroLinePainter extends CustomPainter {
  final Color lineColor;

  MetroLinePainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw simplified metro lines
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      paint,
    );

    // Draw station dots
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    
    final stations = [
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.4),
    ];

    for (final station in stations) {
      canvas.drawCircle(station, 12, paint);
      paint.color = lineColor;
      canvas.drawCircle(station, 8, paint);
      paint.color = Colors.white;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}