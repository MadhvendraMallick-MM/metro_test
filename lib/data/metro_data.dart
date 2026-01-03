import '../models/models.dart';

// ============================================================================
// METRO DATA CONFIGURATION
// ============================================================================
// Fill this file with your metro system's actual data
// This is your SINGLE SOURCE OF TRUTH for all metro information
// ============================================================================

class MetroData {
  // =========================================================================
  // SECTION 1: STATIONS LIST
  // =========================================================================
  // Add ALL your metro stations here
  // This list will be used throughout the app for selection
  
  static final List<String> allStations = [
    // RED LINE
    'Rithala',
    'Rohini East',
    'Rohini West',
    'Pitampura',
    'Kohat Enclave',
    'Netaji Subhash Place',
    'Keshav Puram',
    'Kanhaiya Nagar',
    'Inderlok',
    'Shastri Nagar',
    'Pratap Nagar',
    'Pulbangash',
    'Tis Hazari',
    'Kashmere Gate',
    'Shastri Park',
    'Seelampur',
    'Welcome',
    'Shahdara',
    
    // YELLOW LINE
    'Samaypur Badli',
    'Rohini Sector 18-19',
    'Haiderpur Badli Mor',
    'Jahangirpuri',
    'Adarsh Nagar',
    'Azadpur',
    'Model Town',
    'GTB Nagar',
    'Vishwavidyalaya',
    'Vidhan Sabha',
    'Civil Lines',
    'Rajiv Chowk',
    'Central Secretariat',
    'Udyog Bhawan',
    'INA',
    'AIIMS',
    'Green Park',
    'Hauz Khas',
    'Malviya Nagar',
    'Saket',
    'Qutab Minar',
    'Chhattarpur',
    'Sultanpur',
    'Ghitorni',
    'Arjan Garh',
    'Guru Dronacharya',
    'Sikanderpur',
    'MG Road',
    'IFFCO Chowk',
    'HUDA City Centre',
    
    // BLUE LINE
    'Dwarka Sector 21',
    'Dwarka Sector 8',
    'Dwarka Sector 9',
    'Dwarka Sector 10',
    'Dwarka Sector 11',
    'Dwarka Sector 12',
    'Dwarka Sector 13',
    'Dwarka Sector 14',
    'Dwarka',
    'Dwarka Mor',
    'Nawada',
    'Uttam Nagar West',
    'Uttam Nagar East',
    'Janakpuri West',
    'Janakpuri East',
    'Tilak Nagar',
    'Subhash Nagar',
    'Tagore Garden',
    'Rajouri Garden',
    'Ramesh Nagar',
    'Moti Nagar',
    'Kirti Nagar',
    'Shadipur',
    'Patel Nagar',
    'Karol Bagh',
    'Jhandewalan',
    'RK Ashram Marg',
    'Barakhamba Road',
    'Mandi House',
    'Pragati Maidan',
    'Indraprastha',
    'Yamuna Bank',
    'Laxmi Nagar',
    'Nirman Vihar',
    'Preet Vihar',
    'Karkarduma',
    'Anand Vihar',
    'Kaushambi',
    'Vaishali',
    'Noida Sector 16',
    'Noida Sector 15',
    'Noida Sector 18',
    'Botanical Garden',
    'Noida City Centre',
    
    // Add more stations for other lines...
  ];

  // =========================================================================
  // SECTION 2: STATION COORDINATES (FOR GPS DETECTION)
  // =========================================================================
  // Add GPS coordinates for each station
  // Format: {'name': 'Station Name', 'latitude': XX.XXXX, 'longitude': XX.XXXX}
  // You can get these coordinates from Google Maps
  
  static final List<Map<String, dynamic>> allStationsWithCoordinates = [
    // RED LINE COORDINATES
    {'name': 'Rithala', 'latitude': 28.7233, 'longitude': 77.1025},
    {'name': 'Rohini East', 'latitude': 28.7151, 'longitude': 77.1069},
    {'name': 'Rohini West', 'latitude': 28.7088, 'longitude': 77.1109},
    {'name': 'Pitampura', 'latitude': 28.6999, 'longitude': 77.1314},
    {'name': 'Kashmere Gate', 'latitude': 28.6675, 'longitude': 77.2273},
    {'name': 'Shahdara', 'latitude': 28.6855, 'longitude': 77.2867},
    
    // YELLOW LINE COORDINATES
    {'name': 'Samaypur Badli', 'latitude': 28.7297, 'longitude': 77.1365},
    {'name': 'Rajiv Chowk', 'latitude': 28.6328, 'longitude': 77.2197},
    {'name': 'Hauz Khas', 'latitude': 28.5494, 'longitude': 77.2065},
    {'name': 'HUDA City Centre', 'latitude': 28.4595, 'longitude': 77.0720},
    
    // BLUE LINE COORDINATES
    {'name': 'Dwarka Sector 21', 'latitude': 28.5522, 'longitude': 77.0589},
    {'name': 'Rajouri Garden', 'latitude': 28.6414, 'longitude': 77.1213},
    {'name': 'Yamuna Bank', 'latitude': 28.6191, 'longitude': 77.2834},
    {'name': 'Vaishali', 'latitude': 28.6491, 'longitude': 77.3410},
    {'name': 'Noida City Centre', 'latitude': 28.5747, 'longitude': 77.3560},
    
    // ADD MORE COORDINATES FOR ALL YOUR STATIONS HERE
    // To get coordinates:
    // 1. Open Google Maps
    // 2. Search for the station
    // 3. Right-click on the location
    // 4. Click "What's here?"
    // 5. Copy the latitude and longitude
  ];

  // =========================================================================
  // SECTION 3: FARE MATRIX
  // =========================================================================
  // Define fare based on distance or zones
  // This is a simplified version - you can make it more complex
  
  static Fare getFare(String from, String to) {
    // Calculate fare based on number of stations between from and to
    // This is a MOCK implementation - replace with your actual fare logic
    
    int fromIndex = allStations.indexOf(from);
    int toIndex = allStations.indexOf(to);
    
    if (fromIndex == -1 || toIndex == -1) {
      return Fare(tokenFare: 20, smartCardFare: 18, offPeakFare: 16);
    }
    
    int stationDistance = (fromIndex - toIndex).abs();
    
    // Fare calculation logic (CUSTOMIZE THIS)
    int baseFare = 10;
    int perStationFare = 2;
    
    int tokenFare = baseFare + (stationDistance * perStationFare);
    int smartCardFare = (tokenFare * 0.9).round(); // 10% discount
    int offPeakFare = (tokenFare * 0.8).round(); // 20% discount
    
    // Cap maximum fare
    tokenFare = tokenFare > 60 ? 60 : tokenFare;
    smartCardFare = smartCardFare > 54 ? 54 : smartCardFare;
    offPeakFare = offPeakFare > 48 ? 48 : offPeakFare;
    
    return Fare(
      tokenFare: tokenFare,
      smartCardFare: smartCardFare,
      offPeakFare: offPeakFare,
    );
  }

  // =========================================================================
  // SECTION 4: ROUTE GENERATION
  // =========================================================================
  // Generate route between two stations
  // This is a SIMPLIFIED version - you should implement actual route logic
  
  static MetroRoute getSampleRoute(String from, String to) {
    int fromIndex = allStations.indexOf(from);
    int toIndex = allStations.indexOf(to);
    
    if (fromIndex == -1 || toIndex == -1) {
      return _getDefaultRoute(from, to);
    }
    
    // Get stations in between
    List<Station> routeStations = [];
    int start = fromIndex < toIndex ? fromIndex : toIndex;
    int end = fromIndex < toIndex ? toIndex : fromIndex;
    
    int currentTime = 0;
    
    for (int i = start; i <= end; i++) {
      bool isInterchange = _isInterchangeStation(allStations[i]);
      
      routeStations.add(Station(
        name: allStations[i],
        line: _getStationLine(allStations[i]),
        timeFromStart: currentTime,
        isInterchange: isInterchange,
        interchangeLines: isInterchange ? _getInterchangeLines(allStations[i]) : null,
      ));
      
      // Add 2-3 minutes between stations
      currentTime += 3;
      
      // Add extra 2 minutes for interchange
      if (isInterchange && i < end) {
        currentTime += 2;
      }
    }
    
    int totalStations = routeStations.length;
    int interchanges = routeStations.where((s) => s.isInterchange).length;
    Fare fare = getFare(from, to);
    
    return MetroRoute(
      from: from,
      to: to,
      stations: routeStations,
      totalTime: currentTime,
      totalStations: totalStations,
      interchanges: interchanges,
      fare: fare.tokenFare,
    );
  }

  // =========================================================================
  // SECTION 5: STATION INFORMATION
  // =========================================================================
  // Define detailed information for each station
  
  static StationInfo getStationInfo(String stationName) {
    // CUSTOMIZE THIS for each major station
    // For now, returning default info
    
    return StationInfo(
      name: stationName,
      lines: _getStationLines(stationName),
      firstTrain: TrainTimings(
        weekday: '05:30 AM',
        weekend: '06:00 AM',
      ),
      lastTrain: TrainTimings(
        weekday: '11:30 PM',
        weekend: '11:00 PM',
      ),
      openingTime: '05:00 AM',
      closingTime: '12:00 AM',
      facilities: _getStationFacilities(stationName),
    );
  }

  // =========================================================================
  // SECTION 6: LINE COLORS
  // =========================================================================
  // Define colors for each metro line
  
  static const Map<String, String> lineColors = {
    'Red Line': '#EF4444',
    'Yellow Line': '#EAB308',
    'Blue Line': '#3B82F6',
    'Green Line': '#22C55E',
    'Magenta Line': '#EC4899',
    'Pink Line': '#F4C2C2',
    'Orange Line': '#F97316',
    'Violet Line': '#8B5CF6',
    'Grey Line': '#6B7280',
    'Rapid Metro': '#14B8A6',
    'Airport Express': '#F59E0B',
  };

  static String getLineColor(String lineName) {
    return lineColors[lineName] ?? '#6B7280';
  }

  // =========================================================================
  // HELPER FUNCTIONS
  // =========================================================================
  
  // Check if station is an interchange
  static bool _isInterchangeStation(String stationName) {
    const List<String> interchangeStations = [
      'Kashmere Gate',
      'Rajiv Chowk',
      'Central Secretariat',
      'Hauz Khas',
      'Yamuna Bank',
      'Inderlok',
      'Netaji Subhash Place',
      'Kalkaji Mandir',
      'Botanical Garden',
      'Mandi House',
      'Azadpur',
      'Janakpuri West',
      // Add all your interchange stations here
    ];
    
    return interchangeStations.contains(stationName);
  }

  // Get primary line for a station
  static String _getStationLine(String stationName) {
    // CUSTOMIZE THIS based on your metro system
    // This is a simplified mapping
    
    if (stationName.contains('Dwarka') || stationName.contains('Noida')) {
      return 'Blue Line';
    } else if (stationName.contains('Rohini') || stationName == 'Kashmere Gate') {
      return 'Red Line';
    } else if (stationName == 'Rajiv Chowk' || stationName.contains('HUDA')) {
      return 'Yellow Line';
    }
    
    // Default
    return 'Yellow Line';
  }

  // Get all lines for a station
  static List<LineInfo> _getStationLines(String stationName) {
    // CUSTOMIZE THIS for each station
    // For now, returning sample data
    
    return [
      LineInfo(
        name: 'Blue Line',
        color: '#3B82F6',
        direction: 'Dwarka Sector 21 ↔ Noida/Vaishali',
      ),
    ];
  }

  // Get interchange lines
  static List<String> _getInterchangeLines(String stationName) {
    // CUSTOMIZE THIS for each interchange station
    
    Map<String, List<String>> interchangeMap = {
      'Kashmere Gate': ['Red Line', 'Yellow Line', 'Violet Line'],
      'Rajiv Chowk': ['Blue Line', 'Yellow Line'],
      'Central Secretariat': ['Yellow Line', 'Violet Line'],
      'Hauz Khas': ['Yellow Line', 'Magenta Line'],
      'Yamuna Bank': ['Blue Line', 'Red Line'],
      // Add more interchange stations
    };
    
    return interchangeMap[stationName] ?? ['Blue Line', 'Yellow Line'];
  }

  // Get station facilities
  static List<String> _getStationFacilities(String stationName) {
    // CUSTOMIZE THIS based on actual facilities
    // Major stations typically have more facilities
    
    List<String> standardFacilities = ['Elevator', 'Escalator'];
    List<String> majorStationFacilities = [
      'Parking',
      'Elevator',
      'Escalator',
      'ATM',
      'Water',
      'Washroom',
    ];
    
    // Major stations
    const List<String> majorStations = [
      'Rajiv Chowk',
      'Kashmere Gate',
      'Hauz Khas',
      'HUDA City Centre',
      'Noida City Centre',
      'Dwarka Sector 21',
    ];
    
    return majorStations.contains(stationName)
        ? majorStationFacilities
        : standardFacilities;
  }

  // Default route for unknown stations
  static MetroRoute _getDefaultRoute(String from, String to) {
    return MetroRoute(
      from: from,
      to: to,
      stations: [
        Station(name: from, line: 'Unknown', timeFromStart: 0),
        Station(name: to, line: 'Unknown', timeFromStart: 15),
      ],
      totalTime: 15,
      totalStations: 2,
      interchanges: 0,
      fare: 30,
    );
  }
}

// ============================================================================
// INSTRUCTIONS FOR CUSTOMIZATION
// ============================================================================
/*

1. STATIONS LIST (Section 1):
   - Add all your metro stations in order
   - Group them by line for easier management
   - This list is used for station selection throughout the app

2. GPS COORDINATES (Section 2):
   - Add latitude and longitude for each station
   - Get coordinates from Google Maps:
     * Search station on Google Maps
     * Right-click → "What's here?"
     * Copy latitude and longitude
   - This enables GPS detection of nearest station

3. FARE CALCULATION (Section 3):
   - Customize the fare calculation logic
   - Can be based on:
     * Distance between stations
     * Zone-based system
     * Fixed fares for certain routes
   - Update base fare and per-station fare

4. ROUTE GENERATION (Section 4):
   - Currently simplified - shows direct path
   - For production, implement:
     * Multi-line routing with transfers
     * Optimal route selection
     * Alternative routes

5. STATION INFO (Section 5):
   - Add specific timings for each station
   - Update facilities list based on actual amenities
   - Can vary by station importance

6. LINE COLORS (Section 6):
   - Update colors to match your metro system
   - Add/remove lines as needed

7. INTERCHANGE STATIONS:
   - Update _isInterchangeStation() with all interchange points
   - Update _getInterchangeLines() with correct line connections

8. TIMINGS:
   - Update first/last train timings in getStationInfo()
   - Can create station-specific timing if needed

HOW TO FILL YOUR DATA:
1. Start with Section 1 - add all station names
2. Add coordinates in Section 2 for GPS functionality
3. Test GPS detection
4. Customize fare logic in Section 3
5. Update timing and facility information
6. Test thoroughly

*/