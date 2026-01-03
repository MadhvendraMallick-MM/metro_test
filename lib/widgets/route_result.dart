import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/models.dart';
import 'glassmorphic_card.dart';

class RouteResult extends StatelessWidget {
  final String fromStation;
  final String toStation;
  final VoidCallback? onClear;

  const RouteResult({
    super.key,
    required this.fromStation,
    required this.toStation,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final route = MetroData.getSampleRoute(fromStation, toStation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with clear button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Route',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Route Summary Card
        GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Time and Stations Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    context,
                    Icons.access_time_rounded,
                    '${route.totalTime} min',
                    'Travel Time',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).dividerColor,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.train_rounded,
                    '${route.totalStations}',
                    'Stations',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).dividerColor,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.swap_horiz_rounded,
                    '${route.interchanges}',
                    'Changes',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fare Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fare',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${route.fare}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Token Price',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Station List
        GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Route Details',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              ...route.stations.asMap().entries.map((entry) {
                int index = entry.key;
                Station station = entry.value;
                bool isFirst = index == 0;
                bool isLast = index == route.stations.length - 1;

                return _buildStationItem(
                  context,
                  station,
                  isFirst,
                  isLast,
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStationItem(
    BuildContext context,
    Station station,
    bool isFirst,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isFirst || isLast
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Station info
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getLineColor(station.line).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          station.line,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getLineColor(station.line),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                        ),
                      ),
                      if (station.isInterchange) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.swap_horiz_rounded,
                                size: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Interchange',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Time
          Text(
            '${station.timeFromStart} min',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Color _getLineColor(String lineName) {
    final colorMap = {
      'Red Line': const Color(0xFFEF4444),
      'Yellow Line': const Color(0xFFEAB308),
      'Blue Line': const Color(0xFF3B82F6),
      'Green Line': const Color(0xFF22C55E),
      'Magenta Line': const Color(0xFFEC4899),
      'Orange Line': const Color(0xFFF97316),
      'Violet Line': const Color(0xFF8B5CF6),
      'Grey Line': const Color(0xFF6B7280),
    };

    return colorMap[lineName] ?? const Color(0xFF6B7280);
  }
}
