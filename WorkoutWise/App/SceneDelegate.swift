import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let rootAssembly = RootAssembly()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        createStartView(window: window)
    }

    private func createStartView(window: UIWindow) {
        self.window = window
        window.rootViewController = rootAssembly.presentationAssembly.lounchScreen()
        window.makeKeyAndVisible()

        // Check if we need to ask for push notification permission
        checkForPushNotificationPermission()
    }

    // Check if the user has already been asked for push notification permissions
    private func checkForPushNotificationPermission() {
        // Check if we've already asked for push notifications
        if !UserDefaultsStorage.shared.getAskPushValue() {
            // If not asked yet, show the push notification alert
            registerForPushNotifications(completionHandler: {
                
            })
        } else {
            // If asked, proceed to the next screen (e.g., main app screen)
            navigateToNextScreen()
        }
    }


    private func registerForPushNotifications(completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                completionHandler()
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }

    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func navigateToNextScreen() {
        // Navigate to the next screen after push notification request
        let signInVC = rootAssembly.presentationAssembly.signInScene()
        changeRootViewController(signInVC, animated: false)
    }

    // Function to change root view controller
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

    // The remaining scene lifecycle methods can remain unchanged
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
