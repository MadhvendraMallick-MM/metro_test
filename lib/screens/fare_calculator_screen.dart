import 'package:flutter/material.dart';
import '../widgets/glassmorphic_card.dart';
import '../theme/app_theme.dart';
import '../data/metro_data.dart';
import '../models/models.dart';

class FareCalculatorScreen extends StatefulWidget {
  const FareCalculatorScreen({super.key});

  @override
  State<FareCalculatorScreen> createState() => _FareCalculatorScreenState();
}

class _FareCalculatorScreenState extends State<FareCalculatorScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  String? _selectedFrom;
  String? _selectedTo;
  List<String> _fromSuggestions = [];
  List<String> _toSuggestions = [];
  Fare? _calculatedFare;
  bool _showFareDetails = false;

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
            .where((station) => station.toLowerCase().contains(value.toLowerCase()))
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
            .where((station) => station.toLowerCase().contains(value.toLowerCase()))
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

      // Recalculate fare if both stations are selected
      if (_selectedFrom != null && _selectedTo != null) {
        _calculateFare();
      }
    });
  }

  void _calculateFare() {
    if (_selectedFrom != null && _selectedTo != null) {
      setState(() {
        _calculatedFare = MetroData.getFare(_selectedFrom!, _selectedTo!);
        _showFareDetails = true;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFrom = null;
      _selectedTo = null;
      _fromController.clear();
      _toController.clear();
      _calculatedFare = null;
      _showFareDetails = false;
      _fromSuggestions = [];
      _toSuggestions = [];
    });
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
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Calculate Your\nMetro Fare',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 24),

                // Station Selection Card
                _buildStationSelectionCard(),
                const SizedBox(height: 20),

                // Fare Details Card
                if (_showFareDetails && _calculatedFare != null)
                  _buildFareDetailsCard(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'FARE CALCULATOR',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
        ),
        if (_showFareDetails)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _clearSelection,
            color: Theme.of(context).colorScheme.primary,
            tooltip: 'Clear',
          ),
      ],
    );
  }

  Widget _buildStationSelectionCard() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // From Station
          _buildStationInput(
            controller: _fromController,
            label: "From Station",
            hint: "Select starting station...",
            suggestions: _fromSuggestions,
            onChanged: _onFromChanged,
            onSuggestionTap: (station) {
              setState(() {
                _selectedFrom = station;
                _fromController.text = station;
                _fromSuggestions = [];
                if (_selectedTo != null) {
                  _calculateFare();
                }
              });
            },
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
            label: "To Station",
            hint: "Select destination station...",
            suggestions: _toSuggestions,
            onChanged: _onToChanged,
            onSuggestionTap: (station) {
              setState(() {
                _selectedTo = station;
                _toController.text = station;
                _toSuggestions = [];
                if (_selectedFrom != null) {
                  _calculateFare();
                }
              });
            },
          ),
          const SizedBox(height: 20),

          // Calculate Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_selectedFrom != null && _selectedTo != null)
                  ? _calculateFare
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
                'CALCULATE FARE',
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
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: Colors.grey[600],
            ),
          ),
        ),
        // Suggestions dropdown
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

  Widget _buildFareDetailsCard() {
    return Column(
      children: [
        GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFF97316),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Fare Breakdown',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Route info
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedFrom ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedTo ?? '',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Divider(color: Colors.grey[300], height: 1),
              const SizedBox(height: 20),

              // Fare options
              _buildFareOption(
                icon: Icons.confirmation_number_rounded,
                title: 'Token',
                description: 'Single journey ticket',
                price: _calculatedFare!.tokenFare,
                color: const Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),

              _buildFareOption(
                icon: Icons.credit_card_rounded,
                title: 'Smart Card',
                description: '10% discount',
                price: _calculatedFare!.smartCardFare,
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(height: 16),

              _buildFareOption(
                icon: Icons.access_time_rounded,
                title: 'Off-Peak Hours',
                description: '20% discount',
                price: _calculatedFare!.offPeakFare,
                color: const Color(0xFF22C55E),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Savings info card
        GlassmorphicCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.savings_rounded,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save up to ₹${_calculatedFare!.tokenFare - _calculatedFare!.offPeakFare}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22C55E),
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Travel during off-peak hours',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareOption({
    required IconData icon,
    required String title,
    required String description,
    required int price,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '₹$price',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }
}
