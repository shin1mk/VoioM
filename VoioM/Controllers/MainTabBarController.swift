////
////  MainTabBarController.swift
////  VoioM
////
////  Created by SHIN MIKHAIL on 17.12.2023.
////
//
//import UIKit
//
//final class MainTabBarController: UITabBarController {
//    //MARK: Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        generateTabBar()
////        updateFavoritesBadge()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//         super.viewWillAppear(animated)
////         updateFavoritesBadge()
//     }
//    //MARK: Create TabBar
//    private func generateTabBar() {
////        _ = configureFavoritesViewControllerBadge() // FavoritesViewControllerBadge
//        
//        viewControllers = [
//            generateVC(
//                viewController: MainViewController(),
//                title: "Main",
//                image: UIImage(systemName: "play.house.fill")),
//            generateVC(
//                viewController: FavoritesViewController(),
//                title: "Favorites",
//                image: UIImage(systemName: "star.fill")),
//            generateVC(
//                viewController: ProfileViewController(),
//                title: "Profile",
//                image: UIImage(systemName: "person.fill"))
//        ]
//    }
//    // Generate View Controllers
//    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
//        viewController.tabBarItem.title = title
//        viewController.tabBarItem.image = image
//        return viewController
//    }
//}
////MARK: - Create Badge
////extension MainTabBarController {
////    // Favorites View Controller Badge
////    private func configureFavoritesViewControllerBadge() -> UIViewController {
////        let favoritesViewController = FavoritesViewController()
////        // Получаем количество статей в избранном
////        if let badgeCount = getFavoriteArticlesCount() {
////            favoritesViewController.tabBarItem.badgeValue = String(badgeCount)
////            print("Badge count \(badgeCount)")
////        } else {
////            favoritesViewController.tabBarItem.badgeValue = nil // Если нет статей удаляем badge
////            print("No favorite articles")
////        }
////        return favoritesViewController
////    }
////    // get Favorite Articles Count
////    private func getFavoriteArticlesCount() -> Int? {
////        let favoriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
////        return favoriteArticles.count
////    }
////    // update Favorites Badge
////    private func updateFavoritesBadge() {
////        if let favoriteCount = getFavoriteArticlesCount() {
////            if favoriteCount > 0 {
////                tabBar.items?.last?.badgeValue = String(favoriteCount)
////            } else {
////                tabBar.items?.last?.badgeValue = nil
////            }
////        }
////    }
////}
