import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/discount_countdown.dart';
import '../theme/app_theme.dart';
import '../data/metro_data.dart';
import 'route_details_screen.dart';

class HomePage extends StatefulWidget {
  final Map<String, String>? initialRouteData;

  const HomePage({super.key, this.initialRouteData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  String? _selectedFrom;
  String? _selectedTo;
  List<String> _fromSuggestions = [];
  List<String> _toSuggestions = [];

  // Store recent routes (max 3)
  List<Map<String, String>> _recentRoutes = [
    {
      'from': 'Rajiv Chowk',
      'to': 'Hauz Khas',
      'line1': 'Yellow Line',
      'line2': 'Magenta Line',
    },
    {
      'from': 'Kashmere Gate',
      'to': 'Dwarka Sector 21',
      'line1': 'Red Line',
      'line2': 'Blue Line',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialRouteData != null) {
      _selectedFrom = widget.initialRouteData!['from'];
      _selectedTo = widget.initialRouteData!['to'];
      _fromController.text = _selectedFrom ?? '';
      _toController.text = _selectedTo ?? '';
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _onFromChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _fromSuggestions = [];
      } else {
        _fromSuggestions = MetroData.allStations
            .where(
              (station) => station.toLowerCase().contains(value.toLowerCase()),
            )
            .take(5)
            .toList();
      }
    });
  }

  void _onToChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _toSuggestions = [];
      } else {
        _toSuggestions = MetroData.allStations
            .where(
              (station) => station.toLowerCase().contains(value.toLowerCase()),
            )
            .take(5)
            .toList();
      }
    });
  }

  void _swapStations() {
    setState(() {
      final temp = _selectedFrom;
      _selectedFrom = _selectedTo;
      _selectedTo = temp;

      final tempText = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = tempText;
    });
  }

  void _handleSearch() {
    if (_selectedFrom != null && _selectedTo != null) {
      // Add to recent routes
      _addToRecentRoutes(_selectedFrom!, _selectedTo!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RouteDetailsScreen(from: _selectedFrom!, to: _selectedTo!),
        ),
      );
    }
  }

  void _addToRecentRoutes(String from, String to) {
    setState(() {
      // Remove if already exists
      _recentRoutes.removeWhere(
        (route) => route['from'] == from && route['to'] == to,
      );

      // Add to beginning
      _recentRoutes.insert(0, {
        'from': from,
        'to': to,
        'line1': 'Yellow Line',
        'line2': 'Blue Line',
      });

      // Keep only 3 most recent
      if (_recentRoutes.length > 3) {
        _recentRoutes = _recentRoutes.take(3).toList();
      }
    });
  }

  void _navigateToRecentRoute(Map<String, String> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RouteDetailsScreen(from: route['from']!, to: route['to']!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get real date and time from device
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now).toUpperCase();
    final dateFormatted = DateFormat('dd MMMM, yyyy').format(now);

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGradient
            : AppTheme.lightGradient,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with real date/time
                _buildHeader(dayName, dateFormatted),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Where do you want to\ngo for today?',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                // Search Card
                _buildSearchCard(),
                const SizedBox(height: 20),

                // BIG Discount Countdown
                const DiscountCountdown(),
                const SizedBox(height: 24),

                // Recent Routes (Single Pass)
                if (_recentRoutes.isNotEmpty) ...[
                  Text(
                    'Recent Routes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._recentRoutes.map((route) => _buildRecentRouteCard(route)),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String day, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$day ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const Text('☀️', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFF97316), Color(0xFFEC4899)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF97316).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // From Station
          _buildStationInput(
            controller: _fromController,
            label: "I'm leaving from",
            hint: "Type a station...",
            suggestions: _fromSuggestions,
            onChanged: _onFromChanged,
            onSuggestionTap: (station) {
              setState(() {
                _selectedFrom = station;
                _fromController.text = station;
                _fromSuggestions = [];
              });
            },
            showGPS: true,
          ),
          const SizedBox(height: 16),

          // Swap Button
          Center(
            child: InkWell(
              onTap: _swapStations,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_vert_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // To Station
          _buildStationInput(
            controller: _toController,
            label: "I'm heading to",
            hint: "Type a station...",
            suggestions: _toSuggestions,
            onChanged: _onToChanged,
            onSuggestionTap: (station) {
              setState(() {
                _selectedTo = station;
                _toController.text = station;
                _toSuggestions = [];
              });
            },
          ),
          const SizedBox(height: 20),

          // Search Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_selectedFrom != null && _selectedTo != null)
                  ? _handleSearch
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBBF24),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'SEARCH',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> suggestions,
    required Function(String) onChanged,
    required Function(String) onSuggestionTap,
    bool showGPS = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: showGPS
                ? IconButton(
                    icon: const Icon(Icons.my_location_rounded),
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  title: Text(
                    suggestions[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () => onSuggestionTap(suggestions[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecentRouteCard(Map<String, String> route) {
    return GestureDetector(
      onTap: () => _navigateToRecentRoute(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_rounded,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Single Pass',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['from']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            route['line1']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            route['to']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            route['line2']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.end,
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
      ),
    );
  }
}
