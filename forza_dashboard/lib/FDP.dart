import 'dart:typed_data';

// A class to represent the data collected by a single UDP datagram sent by Forza Motorsport 7's
// data out feature. Currently includes 'some' of the SLED attributes and all of the DASH attributes.
class FDP {

  // Parameters inclued in the V1/SLED configuration
  int isRaceOn = 0;  // 1 (currently racing) or 0 (paused/in menu)
  int timestampMS = 0;  // milliseconds passed since the game turned on

  double engineMaxRPM = 0;
  double engineIdleRPM = 0;
  double currentEngineRPM = 0;

  // In the car's local space: X = right, Y = up, Z = forward
  double accelerationX = 0;
  double accelerationY = 0;
  double accelerationZ = 0;

  // In the car's local space: X = right, Y = up, Z = forward
  double velocityX = 0;
  double velocityY = 0;
  double velocityZ = 0;

  // In the car's local space, X = pitch, Y = yaw, Z = roll
  double angularVelocityY = 0;
  double angularVelocityX = 0;
  double angularVelocityZ = 0;

  double yaw = 0;
  double pitch = 0;
  double roll = 0;

  // more params in the Sled packet but I don't need them all + CBA
  
  // Parameters in the Dash configuration:

  // position in metres
  double positionX = 0;
  double positionY = 0;
  double positionZ = 0;
  
  double speed = 0;  // metres per second
  double power = 0;  // watts
  double torque = 0;  // newton metre

  // temperatures in fahrenheit regardless of settings in game
  double tireTempFrontLeft = 0;
  double tireTempFrontRight = 0;
  double tireTempRearLeft = 0;
  double tireTempRearRight = 0;

  double boost = 0;  // bar (negative and positive values possible)
  double fuel = 0;  // 0 (empty) to 1 (full) - incl decimal values in between
  double distanceTraveled = 0;  // metres
  double bestLap = 0;  // seconds
  double lastLap = 0;  // seconds
  double currentLap = 0;  // seconds
  double currentRaceTime = 0;  // seconds

  int lapNumber = 0;
  int racePosition = 0;

  int accel = 0;  // 0 - 255
  int brake = 0;  // 0 - 255
  int clutch = 0;  // 0 - 255
  int handbrake = 0;  // 0 - 255
  int gear = 0;  // The current gear
  int steer = 0;  // -127 (max left) - 127 (max right)

  int normalizedDrivingLine = 0;
  int normalizedAIBrakeDifference = 0;


  // Receives data from a UDP datagram and initialises each member with the values from the packet.
  // Sent as a C struct, so floats are converted to Double, and all variations of the Int datatype
  // are converted to regular Int.
  FDP(Uint8List data) {

    final byteData = ByteData.sublistView(data);
    isRaceOn = byteData.getInt32(0, Endian.little);
    timestampMS = byteData.getUint32(4, Endian.little);

    engineMaxRPM = byteData.getFloat32(8, Endian.little);
    engineIdleRPM = byteData.getFloat32(12, Endian.little);
    currentEngineRPM = byteData.getFloat32(16, Endian.little);

    accelerationX = byteData.getFloat32(20, Endian.little);
    accelerationY = byteData.getFloat32(24, Endian.little);
    accelerationZ = byteData.getFloat32(28, Endian.little);

    velocityX = byteData.getFloat32(32, Endian.little);
    velocityY = byteData.getFloat32(36, Endian.little);
    velocityZ = byteData.getFloat32(40, Endian.little);

    angularVelocityX = byteData.getFloat32(44, Endian.little);
    angularVelocityY = byteData.getFloat32(48, Endian.little);
    angularVelocityZ = byteData.getFloat32(52, Endian.little);

    yaw = byteData.getFloat32(56, Endian.little);
    pitch = byteData.getFloat32(60, Endian.little);
    roll = byteData.getFloat32(64, Endian.little);

    positionX = byteData.getFloat32(232, Endian.little);
    positionY = byteData.getFloat32(236, Endian.little);
    positionZ = byteData.getFloat32(240, Endian.little);

    speed = byteData.getFloat32(244, Endian.little);
    power = byteData.getFloat32(248, Endian.little);
    torque = byteData.getFloat32(252, Endian.little);

    tireTempFrontLeft = byteData.getFloat32(256, Endian.little);
    tireTempFrontRight = byteData.getFloat32(260, Endian.little);
    tireTempRearLeft = byteData.getFloat32(264, Endian.little);
    tireTempRearRight = byteData.getFloat32(268, Endian.little);

    boost = byteData.getFloat32(272, Endian.little);
    fuel = byteData.getFloat32(276, Endian.little);
    distanceTraveled = byteData.getFloat32(280, Endian.little);
    bestLap = byteData.getFloat32(284, Endian.little);
    lastLap = byteData.getFloat32(288, Endian.little);
    currentLap = byteData.getFloat32(292, Endian.little);
    currentRaceTime = byteData.getFloat32(296, Endian.little);
    lapNumber = byteData.getUint16(300, Endian.little);
    racePosition = byteData.getUint8(302);

    accel = byteData.getUint8(303);
    brake = byteData.getUint8(304);
    clutch = byteData.getUint8(305);
    handbrake = byteData.getUint8(306);
    gear = byteData.getUint8(307);
    steer = byteData.getInt8(308);

    normalizedDrivingLine = byteData.getInt8(309);
    normalizedAIBrakeDifference = byteData.getInt8(310);

    //print("Timestamp binary: ${timestampMS.toRadixString(2)}");
  }

  // Prints all attributes in an easy to read way
  void pr() {
    print("Forza Data Packet:");
    print("Is Race On: $isRaceOn");
    print("Timestamp (MS): $timestampMS");
    print("Engine Max RPM: $engineMaxRPM");
    print("Engine Idle RPM: $engineIdleRPM");
    print("Current engine rpm: $currentEngineRPM");

    print("Tire temp front left: $tireTempFrontLeft");

    print("Boost: $boost");
    print("Fuel: $fuel");
    print("Distance: $distanceTraveled");
    print("Best lap: $bestLap");
    print("Last lap: $lastLap");
    print("Current lap: $currentLap");
    print("Current race time: $currentRaceTime");
    print("Lap number: $lapNumber");
    print("Race position: $racePosition");

    print("Accel: $accel");
    print("Brake: $brake");
    print("Clutch: $clutch");
    print("Handbrake: $handbrake");
    print("Gear: $gear");
    print("Steer: $steer");
  }


  // Converts all the values to a row in a CSV file
  String toCSV() {
    String csv = "";

    return csv;
  }


  // Creates and returns a CSV header with all the fields from the datagram
  String getCSVHeader() {
    String header = "";

    return header;
  }
}