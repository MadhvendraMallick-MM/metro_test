import 'dart:async';
import 'package:flutter/material.dart';
import 'glassmorphic_card.dart';

class DiscountCountdown extends StatefulWidget {
  const DiscountCountdown({super.key});

  @override
  State<DiscountCountdown> createState() => _DiscountCountdownState();
}

class _DiscountCountdownState extends State<DiscountCountdown> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isDiscountActive = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    final currentHour = now.hour;

    // Off-peak hours: 8:00 AM - 5:00 PM (example)
    if (currentHour >= 8 && currentHour < 17) {
      setState(() {
        _isDiscountActive = true;
        final endTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
        _timeRemaining = endTime.difference(now);
      });
    } else {
      setState(() {
        _isDiscountActive = false;
        DateTime startTime;
        if (currentHour >= 17) {
          startTime = DateTime(now.year, now.month, now.day + 1, 8, 0, 0);
        } else {
          startTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
        }
        _timeRemaining = startTime.difference(now);
      });
    }
  }

  void _showDiscountInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF97316).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.percent_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Smart Card Discounts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Discount Info
            _buildDiscountRow(
              '10% OFF',
              'Smart Card (Regular Hours)',
              'Available all day with smart card',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildDiscountRow(
              '20% OFF',
              'Off-Peak Hours (8 AM - 5 PM)',
              'Extra savings during off-peak times',
              Colors.orange,
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Get a smart card today and save on every journey!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBF24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountRow(
    String discount,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes.remainder(60);
    final seconds = _timeRemaining.inSeconds.remainder(60);

    return GestureDetector(
      onTap: () => _showDiscountInfo(context),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDiscountActive
                ? [const Color(0xFF22C55E).withOpacity(0.2), const Color(0xFF10B981).withOpacity(0.1)]
                : [const Color(0xFFFBBF24).withOpacity(0.2), const Color(0xFFF97316).withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isDiscountActive
                ? const Color(0xFF22C55E).withOpacity(0.3)
                : const Color(0xFFF97316).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (_isDiscountActive ? const Color(0xFF22C55E) : const Color(0xFFF97316)).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isDiscountActive
                        ? const Color(0xFF22C55E).withOpacity(0.2)
                        : const Color(0xFFF97316).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isDiscountActive ? Icons.stars_rounded : Icons.access_time_rounded,
                    color: _isDiscountActive ? const Color(0xFF22C55E) : const Color(0xFFF97316),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isDiscountActive ? '🎉 Off-Peak Active!' : '⏰ Smart Card Discount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isDiscountActive ? 'Enjoy 20% savings now' : 'Don\'t miss out!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // BIG COUNTDOWN TIMER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox(context, hours.toString().padLeft(2, '0'), 'HRS'),
                const SizedBox(width: 8),
                _buildColon(),
                const SizedBox(width: 8),
                _buildTimeBox(context, minutes.toString().padLeft(2, '0'), 'MIN'),
                const SizedBox(width: 8),
                _buildColon(),
                const SizedBox(width: 8),
                _buildTimeBox(context, seconds.toString().padLeft(2, '0'), 'SEC'),
              ],
            ),
            const SizedBox(height: 12),

            // Status Text
            Text(
              _isDiscountActive ? 'Discount ends in' : 'Discount starts in',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(BuildContext context, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isDiscountActive
                ? const Color(0xFF22C55E).withOpacity(0.15)
                : const Color(0xFFF97316).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDiscountActive
                  ? const Color(0xFF22C55E).withOpacity(0.3)
                  : const Color(0xFFF97316).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildColon() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}