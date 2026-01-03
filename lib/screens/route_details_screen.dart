import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/models.dart';
import 'station_arrival_screen.dart';

class RouteDetailsScreen extends StatelessWidget {
  final String from;
  final String to;

  const RouteDetailsScreen({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    final route = MetroData.getSampleRoute(from, to);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Trip to $to',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Arrival in ${route.totalTime} minutes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Route Timeline
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildRouteTimeline(context, route),
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StationArrivalScreen(
                        stationName: route.stations.last.name,
                        nextStation: 'Next Station',
                        line: route.stations.last.line,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBF24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTimeline(BuildContext context, MetroRoute route) {
    return Column(
      children: List.generate(route.stations.length, (index) {
        final station = route.stations[index];
        final isFirst = index == 0;
        final isLast = index == route.stations.length - 1;
        final nextStation = !isLast ? route.stations[index + 1] : null;
        final isLineChange = nextStation != null && station.line != nextStation.line;

        return _buildStationItem(
          context,
          station,
          isFirst: isFirst,
          isLast: isLast,
          isLineChange: isLineChange,
          nextStation: nextStation,
        );
      }),
    );
  }

  Widget _buildStationItem(
    BuildContext context,
    Station station, {
    required bool isFirst,
    required bool isLast,
    required bool isLineChange,
    Station? nextStation,
  }) {
    final lineColor = _getColorFromLine(station.line);
    final nextLineColor = nextStation != null ? _getColorFromLine(nextStation.line) : lineColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        SizedBox(
          width: 60,
          child: Text(
            _formatTime(station.timeFromStart),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),

        // Timeline Column
        Column(
          children: [
            // Station Dot
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: lineColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: lineColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            // Connecting Line
            if (!isLast)
              Container(
                width: 4,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: isLineChange
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [lineColor, nextLineColor],
                        )
                      : LinearGradient(
                          colors: [lineColor, lineColor],
                        ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Station Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (isFirst)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.train,
                    size: 14,
                    color: lineColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    station.line,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Interchange Info
              if (station.isInterchange && station.interchangeLines != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.repeat_rounded,
                            size: 16,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Change trains',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: station.interchangeLines!.map((line) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getColorFromLine(line).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getColorFromLine(line),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],

              // Walk instruction
              if (!isLast && isLineChange) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Walk (2 minutes)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(int minutes) {
    final now = DateTime.now();
    final time = now.add(Duration(minutes: minutes));
    return '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getColorFromLine(String lineName) {
    final colorHex = MetroData.getLineColor(lineName);
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }
}