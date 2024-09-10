import CalmGeo

enum RnCalmGeoDesiredAccuracy: String, Codable {
  case BEST_FOR_NAVIGATION
  case BEST
  case TEN_METERS
  case HUNDRED_METERS
  case KILOMETER
  case THREE_KILOMETER
}

func toCalmGeoDesiredAccuracy(rn: RnCalmGeoDesiredAccuracy) -> CalmGeoDesiredAccuracy {
  switch rn {
    case .BEST_FOR_NAVIGATION:
        CalmGeoDesiredAccuracy.bestForNavigation
    case .BEST:
      CalmGeoDesiredAccuracy.best
    case .TEN_METERS:
      CalmGeoDesiredAccuracy.tenMeters
    case .HUNDRED_METERS:
      CalmGeoDesiredAccuracy.hundredMeters
    case .KILOMETER:
      CalmGeoDesiredAccuracy.kilometer
    case .THREE_KILOMETER:
      CalmGeoDesiredAccuracy.threeKilometer
  }
}

struct RnCalmGeoConfig: Codable {
  public var desiredAccuracy: RnCalmGeoDesiredAccuracy
  public var distanceFilter: Int
  public var disableSpeedMultiplier: Bool
  public var speedMultiplier: Double
  public var stationaryRadius: Double

  public var url: String?
  public var token: String?
  public var httpTimeout: Int
  public var method: RequestMethod

  public var autoSync: Bool
  public var syncThreshold: Int
  public var maxBatchSize: Int
  public var maxDaysToPersist: UInt32
}
