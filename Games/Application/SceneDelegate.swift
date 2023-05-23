//
//  SceneDelegate.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let homeButtomBar = CustomTabbarVC()
        homeButtomBar.selectedTitleColor = DesignSystem.AppColors.blackColor.color
        homeButtomBar.navigationItem.titleView?.tintColor = DesignSystem.AppColors.blueColor.color
        let gamesVC = CNavigation(rootViewController: GamesListVC())
        gamesVC.navigationItem.titleView?.tintColor = DesignSystem.AppColors.blueColor.color
        
        gamesVC.navigationBar.prefersLargeTitles = true

        homeButtomBar
            .addtabbrItem(atIndex: 0,
                          viewContrller: gamesVC,
                          andTitle: "Games",
                          andImgName: "ic_games",
                          andSeletedImg: "ic_games",
                          isHideTitle: false,
                          imageInsets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0),
                          titlePos: UIOffset(horizontal: 0, vertical: CGFloat(0)))

        let favVC = CNavigation(rootViewController: FavoritesListVC())
        favVC.navigationBar.prefersLargeTitles = true
        homeButtomBar
            .addtabbrItem(atIndex: 1,
                          viewContrller: favVC,
                          andTitle: "Favorites",
                          andImgName: "ic_fav",
                          andSeletedImg: "ic_fav",
                          isHideTitle: false,
                          imageInsets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0),
                          titlePos: UIOffset(horizontal: 0, vertical: CGFloat(0)))

        // Create a new UIWindow and set the root view controller
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = homeButtomBar
        window.makeKeyAndVisible()

        // Assign the window to the scene delegate's window property
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

