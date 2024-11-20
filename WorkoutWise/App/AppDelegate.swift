import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let rootAssembly = RootAssembly()
  let notificationCenter = UNUserNotificationCenter.current()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    createStartView(window: window ?? UIWindow(frame: UIScreen.main.bounds))
    notificationCenter.delegate = self
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

  private func createStartView(window: UIWindow) {
    self.window = window
    window.rootViewController = rootAssembly.presentationAssembly.lounchScreen()
    window.makeKeyAndVisible()
  }

  func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
    guard let window = self.window, window.rootViewController != vc else {
      return
    }
    window.rootViewController = UINavigationController(rootViewController: vc)
    window.makeKeyAndVisible()
    UIView.transition(
      with: window,
      duration: 0.3,
      options: [.transitionCrossDissolve],
      animations: nil,
      completion: nil
    )
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if #available(iOS 14.0, *) {
      completionHandler([.sound, .badge, .banner])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  func application( _ application: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    UserDefaults.standard.setValue(token, forKey: "PushToken")
    print("Device Token: \(token)")
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register: \(error)")
  }
}
