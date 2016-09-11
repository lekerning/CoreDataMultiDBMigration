//
//  MultiDBMigrationWrapper.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import Foundation
import CoreData

public enum MigrationResult: String {
    case NoNeedToDo = "no need to do migration, model version matches"
    case MigrationSuccess = "do migration successfully"
    case MigrationFailed = "do migration failing with error"
}

protocol MultiDBMigrationWrapperDelegate {
    func dataBaseStoreParentFolderURL() -> NSURL
    func migrationRoadMap() -> VersionMigrationManager
    func dataBaseNames() -> [String]
}

class  MultiDBMigrationWrapper {
    private var delegate: MultiDBMigrationWrapperDelegate
    init(delegate: MultiDBMigrationWrapperDelegate) {
        self.delegate = delegate
    }

    private  func metaDataOfOldSourceStoreForDataBase(dbName: String) -> [String: AnyObject] {
        let storePath = self.delegate.dataBaseStoreParentFolderURL().URLByAppendingPathComponent(dbName)
        var sourceMetaData = [String: AnyObject]()
        do {
            sourceMetaData =  try NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(NSSQLiteStoreType, URL: storePath, options: nil)
        } catch {

        }
        return sourceMetaData
    }

    private  func findMatchNodeWithRoadMap(manager: VersionMigrationManager, oldMetaData: [String: AnyObject]) -> VersionMigrationManager? {
        for info in manager.multiDB {
            let modelVersionInfo = info.modelVersionInfo()
            if let modelURL = info.dataModelFolderURL()?.URLByAppendingPathComponent(modelVersionInfo.currentModel), model = NSManagedObjectModel(contentsOfURL: modelURL) {
                if model.isConfiguration(nil, compatibleWithStoreMetadata: oldMetaData) {
                    return manager
                }
            }
        }

        if let nextManager = manager.nextVersionMigrationManager {
            return self.findMatchNodeWithRoadMap(nextManager, oldMetaData: oldMetaData)
        } else {
            return nil
        }
    }

    func doMigration() -> MigrationResult {
        let stores = self.delegate.dataBaseNames()
        let metaDatas = stores.map { (name) -> [String: AnyObject] in
            return self.metaDataOfOldSourceStoreForDataBase(name)
        }
        let migrationManager = self.delegate.migrationRoadMap()
        for oldMetaData in metaDatas {
            if let matchedManager = self.findMatchNodeWithRoadMap(migrationManager, oldMetaData: oldMetaData) {
                if let _ = matchedManager.nextVersionMigrationManager {
                    if matchedManager.recursiveMigrationToDestinationWithFolderURL(self.delegate.dataBaseStoreParentFolderURL()) {
                        return .MigrationSuccess
                    } else {
                        return .MigrationFailed
                    }
                } else {
                    return .NoNeedToDo
                }
            }

        }
        return .NoNeedToDo
    }

}
