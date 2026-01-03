// Station Model
class Station {
  final String name;
  final String line;
  final int timeFromStart; // in minutes
  final bool isInterchange;
  final List<String>? interchangeLines;

  Station({
    required this.name,
    required this.line,
    required this.timeFromStart,
    this.isInterchange = false,
    this.interchangeLines,
  });
}

// Route Model
class MetroRoute {
  final String from;
  final String to;
  final List<Station> stations;
  final int totalTime;
  final int totalStations;
  final int interchanges;
  final int fare;

  MetroRoute({
    required this.from,
    required this.to,
    required this.stations,
    required this.totalTime,
    required this.totalStations,
    required this.interchanges,
    required this.fare,
  });
}

// Fare Model
class Fare {
  final int tokenFare;
  final int smartCardFare;
  final int offPeakFare;

  Fare({
    required this.tokenFare,
    required this.smartCardFare,
    required this.offPeakFare,
  });
}

// Station Info Model
class StationInfo {
  final String name;
  final List<LineInfo> lines;
  final TrainTimings firstTrain;
  final TrainTimings lastTrain;
  final String openingTime;
  final String closingTime;
  final List<String> facilities;

  StationInfo({
    required this.name,
    required this.lines,
    required this.firstTrain,
    required this.lastTrain,
    required this.openingTime,
    required this.closingTime,
    required this.facilities,
  });
}

class LineInfo {
  final String name;
  final String color;
  final String direction;

  LineInfo({required this.name, required this.color, required this.direction});
}

class TrainTimings {
  final String weekday;
  final String weekend;

  TrainTimings({required this.weekday, required this.weekend});
}
