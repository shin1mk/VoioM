//
//  User+CoreDataProperties.swift
//
//
//  Created by SHIN MIKHAIL on 19.12.2023.
//
//

import Foundation
import CoreData


extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
//    @NSManaged public var favoriteMovies: Set<FavoriteMovie>?
//    
//    // Метод для добавления фильма к избранным
//    func addToFavoriteMovies(_ value: FavoriteMovie) {
//        if favoriteMovies == nil {
//            favoriteMovies = Set<FavoriteMovie>()
//        }
//        favoriteMovies?.insert(value)
//    }
//    
//    // Метод для удаления фильма из избранного
//    func removeFromFavoriteMovies(_ value: FavoriteMovie) {
//        favoriteMovies?.remove(value)
//    }
    
}
