import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      // Initialize Flutter MethodChannel
      let controller = window?.rootViewController as! FlutterViewController
      let deviceInfoChannel = FlutterMethodChannel(name: "com.example/device_info", binaryMessenger: controller.binaryMessenger)
      
      // Set MethodCallHandler
      deviceInfoChannel.setMethodCallHandler { (call, result) in
          if call.method == "getDeviceInfo" {
              // Fetch device info
              let deviceInfo = self.getDeviceInfo()
              result(deviceInfo)
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // Function to fetch device info
    private func getDeviceInfo() -> [String: String] {
        let device = UIDevice.current
        return [
            "modelName": device.model,
            "systemVersion": device.systemVersion,
            "systemName": device.systemName
        ]
    }
}
