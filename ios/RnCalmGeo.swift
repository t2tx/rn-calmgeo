import CalmGeo
import Foundation

@objc(RnCalmGeo)
@available(iOS 15.0, *)
class RnCalmGeo: RCTEventEmitter {
  private var _service: CalmGeoServiceType?

  @objc(getCount:withRejecter:)
  func getCount(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      resolve(_service?.getStoredCount() ?? -1)
    } else {
      resolve(-2)
    }
  }

  @objc(start:withResolver:withRejecter:)
  func start(
    config: String, resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      do {
        let config = try self.parseConfig(config)
        // start service
        if let service = _service {
          service.restart(config: config)
        } else {
          _service = startCalmGeo(config: config)
        }

        if let service = _service {
          service.registerLocationListener { location in
            do {
              let payload = try String(data: JSONEncoder().encode(location), encoding: .utf8)
              self.sendEvent(
                withName: "onLocation",
                body: payload)
            } catch {
              // ignore
            }
          }
        }

        resolve(true)
      } catch {
        Logger.standard.error("\(error)")
        let error = NSError(domain: "", code: 400, userInfo: nil)
        reject("ERROR_CODE_1", "not support", error)
      }
    } else {
      resolve(nil)
    }
  }

  @objc(config:withResolver:withRejecter:)
  func config(
    config: String, resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    self.start(config: config, resolve: resolve, reject: reject)
  }

  override func supportedEvents() -> [String]! {
    return ["onLocation"]
  }

  @objc(stop:withRejecter:)
  func stop(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      _service?.stop()
      resolve(true)
    } else {
      resolve(nil)
    }
  }

  @objc(getLocation:withRejecter:)
  func getLocation(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      resolve(_service?.getGeoData())
    } else {
      resolve(nil)
    }
  }

  @objc(clear:withRejecter:)
  func clear(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      _service?.clearAllLocations()
      resolve(true)
    } else {
      resolve(nil)
    }
  }

  @objc(sync:withRejecter:)
  func sync(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      _service?.sync()
      resolve(true)
    } else {
      resolve(nil)
    }
  }

  @objc(isRunning:withRejecter:)
  func isRunning(
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    if #available(iOS 17.0, *) {
      resolve(_service?.state ?? nil == .running)
    } else {
      resolve(false)
    }
  }

  // ---------- private methods ----------
  private func parseConfig(_ config: String) throws -> CalmGeoConfigType {
    let rnConfig = try JSONDecoder().decode(
      RnCalmGeoConfig
        .self, from: config.data(using: .utf8) ?? Data())

    var ret = CalmGeoConfig.standard

    ret.desiredAccuracy = toCalmGeoDesiredAccuracy(rn: rnConfig.desiredAccuracy).rawValue
    ret.distanceFilter = rnConfig.distanceFilter
    ret.disableSpeedMultiplier = rnConfig.disableSpeedMultiplier
    ret.speedMultiplier = rnConfig.speedMultiplier
    ret.stationaryRadius = rnConfig.stationaryRadius

    ret.url = rnConfig.url
    ret.token = rnConfig.token
    ret.httpTimeout = rnConfig.httpTimeout
    ret.method = rnConfig.method

    ret.autoSync = rnConfig.autoSync
    ret.syncThreshold = rnConfig.syncThreshold
    ret.maxBatchSize = rnConfig.maxBatchSize
    ret.maxDaysToPersist = rnConfig.maxDaysToPersist
    ret.fetchActivity = rnConfig.fetchActivity

    return ret
  }
}
