import 'package:flutter/material.dart';
import 'package:metro_navigator/widgets/glassmorphic_card.dart';
import 'package:metro_navigator/data/metro_data.dart';
import '../services/location_service.dart';

class RouteSelector extends StatefulWidget {
  final Function(String from, String to) onShowRoute;

  const RouteSelector({
    super.key,
    required this.onShowRoute,
  });

  @override
  State<RouteSelector> createState() => _RouteSelectorState();
}

class _RouteSelectorState extends State<RouteSelector> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  
  String? _selectedFrom;
  String? _selectedTo;
  bool _isDetectingLocation = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
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

  Future<void> _detectLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });

    try {
      // Check if location service is enabled
      bool serviceEnabled = await LocationService.isLocationEnabled();
      
      if (!serviceEnabled) {
        _showLocationDialog(
          'Location Services Disabled',
          'Please enable location services in your device settings to use this feature.',
        );
        setState(() {
          _isDetectingLocation = false;
        });
        return;
      }

      // Find nearest station
      String? nearestStation = await LocationService.findNearestStation();
      
      if (nearestStation != null && mounted) {
        setState(() {
          _selectedFrom = nearestStation;
          _fromController.text = nearestStation;
          _isDetectingLocation = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Nearest station: $nearestStation'),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        _showLocationDialog(
          'Location Not Found',
          'Could not detect your location. Please select a station manually.',
        );
        setState(() {
          _isDetectingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        _showLocationDialog(
          'Location Error',
          'Could not access your location. Please check app permissions in settings.',
        );
        setState(() {
          _isDetectingLocation = false;
        });
      }
    }
  }

  void _showLocationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showStationPicker(BuildContext context, bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildStationPicker(isFrom),
    );
  }

  Widget _buildStationPicker(bool isFrom) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isFrom ? 'Select Starting Station' : 'Select Destination',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Text(
                  '${MetroData.allStations.length} stations',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          // Station list
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: MetroData.allStations.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final station = MetroData.allStations[index];
                final isSelected = isFrom 
                    ? station == _selectedFrom 
                    : station == _selectedTo;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.train_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      station,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected 
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        if (isFrom) {
                          _selectedFrom = station;
                          _fromController.text = station;
                        } else {
                          _selectedTo = station;
                          _toController.text = station;
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Your Journey',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),

          // From Station
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _fromController,
                readOnly: true,
                onTap: () => _showStationPicker(context, true),
                decoration: InputDecoration(
                  hintText: 'Select starting station...',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _isDetectingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location_rounded),
                          onPressed: _detectLocation,
                          color: Theme.of(context).colorScheme.primary,
                          tooltip: 'Detect current location',
                        ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Swap Button
          Center(
            child: GlassmorphicButton(
              onTap: _swapStations,
              borderRadius: 12,
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.swap_vert_rounded,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // To Station
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _toController,
                readOnly: true,
                onTap: () => _showStationPicker(context, false),
                decoration: InputDecoration(
                  hintText: 'Select destination...',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Show Route Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_selectedFrom != null && _selectedTo != null)
                  ? () => widget.onShowRoute(_selectedFrom!, _selectedTo!)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              child: Text(
                'Show Route',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}