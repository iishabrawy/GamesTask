//
//  CoreDataManager.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation
import CoreData

/// A manager class responsible for managing Core Data operations for the Games app.
class CoreDataManager {
    /// The shared instance of the CoreDataManager.
    static let shared = CoreDataManager()

    /// The Core Data persistent container.
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Games")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    /// The managed object context associated with the persistent container.
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// Save the list of GameDataModel objects to Core Data.
    ///
    /// - Parameter gamesList: The list of GameDataModel objects to be saved.
    func saveGamesModels(_ gamesList: [GameDataModel]) {
        context.perform { [weak self] in
            if let dataInDB = self?.fetchGamesModels() {
                for gameModel in gamesList {
                    if !dataInDB.contains(where: { $0.id == gameModel.id ?? 0 }) {
                        guard let context = self?.context else {
                            print("Error: Unable to access Core Data context")
                            return
                        }

                        let gamesModelEntity = GameDataEntity(context: context)
                        gamesModelEntity.gameId = String(gameModel.id ?? 0)
                        gamesModelEntity.slug = gameModel.slug
                        gamesModelEntity.name = gameModel.name
                        gamesModelEntity.released = gameModel.released
                        gamesModelEntity.backgroundImage = gameModel.backgroundImage
                        gamesModelEntity.rating = gameModel.rating ?? 0.0
                        gamesModelEntity.metacritic = gameModel.metacritic ?? 0.0
                        gamesModelEntity.gameDescription = gameModel.description ?? ""
                        gamesModelEntity.favourite = gameModel.favorite
                        gamesModelEntity.redditUrl = gameModel.redditUrl
                        gamesModelEntity.redditName = gameModel.redditName
                        gamesModelEntity.website = gameModel.website
                        gamesModelEntity.genres = self?.encodeObject(gameModel.genres as AnyObject)
                        self?.saveContext()
                    } else {
                        print("👍 Item exists in Core Data")
                    }
                }
                self?.context.reset()
            }
        }
    }

    /// Retrieve the list of GameDataModel objects from Core Data.
    ///
    /// - Returns: An array of GameDataModel objects.
    func fetchGamesModels() -> [GameDataModel] {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()

        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            let gameDataModels = gameDataEntities.compactMap { gameDataEntity -> GameDataModel? in
                guard let slug = gameDataEntity.slug,
                      let name = gameDataEntity.name,
                      let released = gameDataEntity.released,
                      let backgroundImage = gameDataEntity.backgroundImage
                else {
                    return nil
                }

                // Convert the transformable property to an array of GameGenres objects
                var gameGenres: [GameGenres]?
                if let genresData = gameDataEntity.genres as? Data,
                   let genres = NSKeyedUnarchiver.unarchiveObject(with: genresData) as? [GameGenres] {
                    gameGenres = genres
                }
                
                return GameDataModel(id: Int(gameDataEntity.gameId ?? ""),
                                     slug: slug,
                                     name: name,
                                     released: released,
                                     backgroundImage: backgroundImage,
                                     rating: gameDataEntity.rating,
                                     metacritic: gameDataEntity.metacritic,
                                     genres: gameGenres,
                                     description: gameDataEntity.gameDescription,
                                     redditUrl: gameDataEntity.redditUrl,
                                     redditName: gameDataEntity.redditName,
                                     website: gameDataEntity.website,
                                     favorite: gameDataEntity.favourite)
            }
            
            return gameDataModels
        } catch {
            print("Error fetching GameDataEntities: \(error)")
            return []
        }
    }
    
    // Retrieve a specific range of GameDataModel objects from Core Data with pagination
    func fetchGamesModels(page: Int, pageSize: Int) -> [GameDataModel] {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()
        fetchRequest.fetchOffset = (page - 1) * pageSize
        fetchRequest.fetchLimit = pageSize
        
        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            let gameDataModels = gameDataEntities.compactMap { gameDataEntity -> GameDataModel? in
                guard let slug = gameDataEntity.slug,
                      let name = gameDataEntity.name,
                      let released = gameDataEntity.released,
                      let backgroundImage = gameDataEntity.backgroundImage
                else {
                    return nil
                }
                
                // Convert the transformable property to an array of GameGenres objects
                var gameGenres: [GameGenres]?
                if let genresData = gameDataEntity.genres as? Data,
                   let genres = NSKeyedUnarchiver.unarchiveObject(with: genresData) as? [GameGenres] {
                    gameGenres = genres
                }
                
                return GameDataModel(id: Int(gameDataEntity.gameId ?? ""),
                                     slug: slug,
                                     name: name,
                                     released: released,
                                     backgroundImage: backgroundImage,
                                     rating: gameDataEntity.rating,
                                     metacritic: gameDataEntity.metacritic,
                                     genres: gameGenres,
                                     description: gameDataEntity.gameDescription,
                                     redditUrl: gameDataEntity.redditUrl,
                                     redditName: gameDataEntity.redditName,
                                     website: gameDataEntity.website,
                                     favorite: gameDataEntity.favourite)
            }
            
            return gameDataModels
        } catch {
            print("Error fetching GameDataEntities: \(error)")
            return []
        }
    }

    // Retrieve the list of GameDataModel objects from Core Data
    func fetchFavoritedGamesModels() -> [GameDataModel] {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite == true")
        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            let gameDataModels = gameDataEntities.compactMap { gameDataEntity -> GameDataModel? in
                guard let slug = gameDataEntity.slug,
                      let name = gameDataEntity.name,
                      let released = gameDataEntity.released,
                      let backgroundImage = gameDataEntity.backgroundImage
                else {
                    return nil
                }

                // Convert the transformable property to an array of GameGenres objects
                var gameGenres: [GameGenres]?
                if let genresData = gameDataEntity.genres as? Data,
                   let genres = NSKeyedUnarchiver.unarchiveObject(with: genresData) as? [GameGenres] {
                    gameGenres = genres
                }

                return GameDataModel(id: Int(gameDataEntity.gameId ?? ""),
                                     slug: slug,
                                     name: name,
                                     released: released,
                                     backgroundImage: backgroundImage,
                                     rating: gameDataEntity.rating,
                                     metacritic: gameDataEntity.metacritic,
                                     genres: gameGenres,
                                     description: gameDataEntity.gameDescription,
                                     redditUrl: gameDataEntity.redditUrl,
                                     redditName: gameDataEntity.redditName,
                                     website: gameDataEntity.website,
                                     favorite: gameDataEntity.favourite)
            }

            return gameDataModels
        } catch {
            print("Error fetching GameDataEntities: \(error)")
            return []
        }
    }

    // Get an item from Core Data by item ID
    func getItemByID(_ id: Int) -> GameDataModel? {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %ld", id)
        
        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            guard let gameDataEntity = gameDataEntities.first else {
                return nil
            }
            
            guard let slug = gameDataEntity.slug,
                  let name = gameDataEntity.name,
                  let released = gameDataEntity.released,
                  let backgroundImage = gameDataEntity.backgroundImage
            else {
                return nil
            }
            
            // Convert the transformable property to an array of GameGenres objects
            var gameGenres: [GameGenres]?
            if let genresData = gameDataEntity.genres as? Data,
               let genres = NSKeyedUnarchiver.unarchiveObject(with: genresData) as? [GameGenres] {
                gameGenres = genres
            }
            
            return GameDataModel(id: Int(gameDataEntity.gameId ?? ""),
                                 slug: slug,
                                 name: name,
                                 released: released,
                                 backgroundImage: backgroundImage,
                                 rating: gameDataEntity.rating,
                                 metacritic: gameDataEntity.metacritic,
                                 genres: gameGenres,
                                 description: gameDataEntity.gameDescription,
                                 redditUrl: gameDataEntity.redditUrl,
                                 redditName: gameDataEntity.redditName,
                                 website: gameDataEntity.website,
                                 favorite: gameDataEntity.favourite)
        } catch {
            print("Error fetching GameDataEntity: \(error)")
            return nil
        }
    }
    
    // Get an item from Core Data by item ID and update its attributes
    func updateItemByID(_ id: Int, withAttributes attributes: GameDataModel) {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %ld", id)
        
        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            guard let gameDataEntity = gameDataEntities.first else {
                return
            }
            
            // Update the attributes of the gameDataEntity based on the provided GameDataModel object
            gameDataEntity.slug = attributes.slug ?? gameDataEntity.slug
            gameDataEntity.name = attributes.name ?? gameDataEntity.name
            gameDataEntity.released = attributes.released ?? gameDataEntity.released
            gameDataEntity.backgroundImage = attributes.backgroundImage ?? gameDataEntity.backgroundImage
            gameDataEntity.rating = attributes.rating ?? gameDataEntity.rating
            gameDataEntity.metacritic = attributes.metacritic ?? gameDataEntity.metacritic
            gameDataEntity.gameDescription = attributes.description ?? gameDataEntity.gameDescription
            gameDataEntity.favourite = attributes.favorite
            gameDataEntity.redditUrl = attributes.redditUrl ?? gameDataEntity.redditUrl
            gameDataEntity.redditName = attributes.redditName ?? gameDataEntity.redditName
            gameDataEntity.website = attributes.website ?? gameDataEntity.website
            
            // Save the changes to the Core Data context
            saveContext()
        } catch {
            print("Error fetching GameDataEntity: \(error)")
        }
    }

    // Remove an item from Core Data by its ID
    func removeItemByID(_ id: Int) {
        let fetchRequest: NSFetchRequest<GameDataEntity> = GameDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %ld", id)

        do {
            let gameDataEntities = try context.fetch(fetchRequest)
            if let gameDataEntity = gameDataEntities.first {
                context.delete(gameDataEntity)
                saveContext()
            }
        } catch {
            print("Error fetching GameDataEntity: \(error)")
        }
    }

    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameDataEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            // Save the changes to the Core Data context
            saveContext()
        } catch {
            print("Error deleting all items: \(error)")
        }
    }
    
    // Helper method to encode objects
    private func encodeObject(_ value: AnyObject) -> NSObject? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            return data as NSObject
        } catch {
            print("Error encoding object: \(error)")
            return nil
        }
    }
    
    // Helper method to decode objects
    private func decodeObject(_ object: NSObject) -> Any? {
        do {
            if #available(iOS 12.0, *) {
                if let data = object as? Data {
                    return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSDictionary.self, NSString.self, NSNumber.self, NSDate.self, NSData.self, NSValue.self, NSURL.self], from: data)
                }
            } else {
                if let data = object as? Data {
                    return NSKeyedUnarchiver.unarchiveObject(with: data)
                }
            }
            
            return nil
        } catch {
            print("Error decoding object: \(error)")
            return nil
        }
    }
    
    // Save the changes to the Core Data context
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
}
