import Flutter
import UIKit
import Beacon

public class SwiftFlutterHelpScoutPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "kelvinforteta.dev/flutter_help_scout", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterHelpScoutPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    
    if call.method.elementsEqual("initialize") {
        if let arguments = arguments {
            // initialize beacon
            initializeBeacon(arguments: arguments)
            result("Beacon successfully initialized")
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Arguments are nil", details: nil))
        }
    } else if call.method.elementsEqual("openBeacon") {
        if let beaconId = arguments?["beaconId"] as? String {
            // open beacon
            openBeacon(beaconId: beaconId)
            result("Beacon open successfully!")
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Beacon ID is nil", details: nil))
        }
    } else if call.method.elementsEqual("logoutBeacon") {
        // logout beacon
        logoutBeacon()
        result("Beacon logged out successfully!")
    } else if call.method.elementsEqual("clearBeacon") {
        // reset beacon
        resetBeacon()
        result("Beacon reset successfully!")
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
    
  public func initializeBeacon(arguments: NSDictionary) {
    let user = HSBeaconUser()
    user.email = arguments["email"] as? String
    user.name = arguments["name"] as? String
    user.company = arguments["company"] as? String
    user.jobTitle = arguments["jobTitle"] as? String
    if let avatarString = arguments["avatar"] as? String, let avatarURL = URL(string: avatarString) {
        user.avatar = avatarURL
    }
    HSBeacon.identify(user)
  }

  // open the beacon
  public func openBeacon(beaconId: String) {
    let settings = HSBeaconSettings(beaconId: beaconId)
    HSBeacon.open(settings)
  }

  // logout beacon
  public func logoutBeacon() {
    HSBeacon.logout()
  }

  // reset beacon
  public func resetBeacon() {
    HSBeacon.reset()
  }
}
