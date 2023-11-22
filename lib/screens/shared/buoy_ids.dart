class BuoyIDs {
  int buoyID = -1;
  int locationID = -1;

  // Singleton setup
  static final BuoyIDs _singleton = BuoyIDs._internal();

  factory BuoyIDs() {
    return _singleton;
  }

  BuoyIDs._internal();

  // Methods to update IDs
  void updateIDs(int buoyID, int locationID) {
    this.buoyID = buoyID;
    this.locationID = locationID;
  }
}