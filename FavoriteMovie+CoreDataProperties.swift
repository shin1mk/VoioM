//
//  FavoriteMovie+CoreDataProperties.swift
//  
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var trackName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl100: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var primaryGenreName: String?
    @NSManaged public var longDescription: String?

}
