import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let screenWidth = UIScreen.main.bounds.width
        
        var currentViewController: UIViewController!
        switch screenWidth {
        case 320:
            currentViewController = UIStoryboard(name: "Mini", bundle: nil).instantiateInitialViewController()
        default:
            currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
        window.rootViewController = currentViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
