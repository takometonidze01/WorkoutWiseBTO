import UIKit

protocol IPresentationAssembly {
    func lounchScreen() -> LaunchScreenViewController
    func pushNotificationScene() -> PushNotificationViewController
    func signInScene() -> SignInViewController
    func mainDashboardScene() -> MainDashboardViewController
    func profileScene(userPoint: String) -> ProfileScene
    func navigateWebView(url: String, closeButtonIsHidden: Bool) -> WebViewController
    func gameViewController(userPoint: String, delegate: MainDelegate?) -> GameViewController
    func resultViewController(workout: WorkoutData, delegate: MainDelegate?) -> ResultViewController
    func chooseTimeScene(delegate: ChooseTimeDelegate?) -> ChooseTimeViewController
    func workoutScene(time: String, delegate: MainDelegate?) -> WorkoutViewController
}

class PresentationAssembly: IPresentationAssembly {
    func lounchScreen() -> LaunchScreenViewController {
        LaunchScreenViewController(presentationAssembly: self)
    }
    
    func pushNotificationScene() -> PushNotificationViewController {
        PushNotificationViewController(presentationAssembly: self)
    }
    
    func signInScene() -> SignInViewController {
        SignInViewController(presentationAssembly: self)
    }
    
    func mainDashboardScene() -> MainDashboardViewController {
        MainDashboardViewController(presentationAssembly: self)
    }
    
    func profileScene(userPoint: String) -> ProfileScene {
        ProfileScene(
            userPoint: userPoint,
            presentationAssembly: self
        )
    }
    
    func navigateWebView(url: String, closeButtonIsHidden: Bool) -> WebViewController {
        WebViewController(
            urlString: url,
            presentationAssembly: self,
            closeButtonIsHidden: closeButtonIsHidden
        )
    }
    
    func gameViewController(userPoint: String, delegate: MainDelegate?) -> GameViewController {
        GameViewController(
            userPoint: userPoint,
            delegate: delegate,
            presentationAssembly: self
        )
    }
    
    func resultViewController(workout: WorkoutData, delegate: MainDelegate?) -> ResultViewController {
        ResultViewController(
            workoutData: workout,
            delegate: delegate,
            presentationAssembly: self
        )
    }
    
    func chooseTimeScene(delegate: ChooseTimeDelegate?) -> ChooseTimeViewController {
        return ChooseTimeViewController(delegate: delegate, presentationAssembly: self)
    }
    
    func workoutScene(time: String, delegate: MainDelegate?) -> WorkoutViewController {
        return WorkoutViewController(time: time, delegate: delegate, presentationAssembly: self)
    }
}

