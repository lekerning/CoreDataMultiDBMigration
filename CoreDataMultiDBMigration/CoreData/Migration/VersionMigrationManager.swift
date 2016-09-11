//
//  VersionMigrationManager.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import Foundation
import CoreData

let migrationToFolder = "Destination"
let backupFolder = "Backup"

public struct ModelVersionInfo {
    let currentModel: String
    var mappingModel: String?
    var destinationModel: String?
}

protocol VersionMigrationAble {
    func modelName() -> String
    func storeName() -> String
    func modelVersionInfo() -> ModelVersionInfo

    func dataModelFolderURL() -> NSURL?
    func mappingModelFolderURL() -> NSURL

    func migrationUserInfo() -> [NSObject : AnyObject]?

}

extension VersionMigrationAble {
    func mappingModelFolderURL() -> NSURL {
        return NSBundle.mainBundle().bundleURL
    }
}

class VersionMigrationManager {

    var multiDB: [VersionMigrationAble]
    var nextVersionMigrationManager: VersionMigrationManager?

    var coreObjectsInfo = NSMutableArray()

    init(dbs: [VersionMigrationAble]) {
        self.multiDB = dbs
    }

    func destinationStoreURLWithSourceStoreURL(storeURL: NSURL, modelName: String) -> NSURL? {
        guard let folderURL = storeURL.URLByDeletingLastPathComponent, last = storeURL.URLByDeletingPathExtension?.lastPathComponent else {
            return nil
        }
        let toFolder  = folderURL.URLByAppendingPathComponent(migrationToFolder)
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(toFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
            return nil
        }

        if let storeExtension = storeURL.pathExtension {
            return  toFolder.URLByAppendingPathComponent(last + "_" + modelName + "." + storeExtension)
        }
        return nil

    }

    func backupWithProjectFolder(pFolder: NSURL, sourceStoreURL: NSURL, destinationURL: NSURL, modelName: String, currentVersionName: String) -> Bool {
        guard let storeName = sourceStoreURL.URLByDeletingPathExtension?.lastPathComponent, storeFile = sourceStoreURL.lastPathComponent, destinationFolder = destinationURL.URLByDeletingLastPathComponent else {
            return false
        }

        defer {
            do {
                try fileManager.removeItemAtURL(backFolder)
            } catch {
                print(error)
            }
            do {
                try fileManager.removeItemAtURL(destinationFolder)
            } catch {
                print(error)
            }
        }

        let fileManager = NSFileManager.defaultManager()
        let backFolder = pFolder.URLByAppendingPathComponent(backupFolder)

        do {
            try fileManager.createDirectoryAtURL(backFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }

        let fileExts = ["sqlite", "sqlite-shm", "sqlite-wal"]
        for ext in fileExts {
            let file = storeName + "." + ext
            let sPath = pFolder.URLByAppendingPathComponent(file)
            let dPath = backFolder.URLByAppendingPathComponent(file)
            if let filePath = sPath.path where fileManager.fileExistsAtPath(filePath) {
                do {
                    try fileManager.moveItemAtURL(sPath, toURL: dPath)
                } catch {
                    print(error)
                    return false
                }
            }
        }
        do {
            try fileManager.moveItemAtURL(destinationURL, toURL: sourceStoreURL)
        } catch {
            //try fileManager.moveItemAtURL(backupURL, toURL: sourceURL)
            return false
        }
        return true
    }

    func doMigrationWithFolderURL(url: NSURL) -> Bool {
        for dbInfo in multiDB {
            let modelVersionInfo = dbInfo.modelVersionInfo()
            guard let cdm = modelVersionInfo.mappingModel, dm = modelVersionInfo.destinationModel else {
                continue
            }
            let mappModelPath = dbInfo.mappingModelFolderURL().URLByAppendingPathComponent(cdm)
            let storeURL = url.URLByAppendingPathComponent(dbInfo.storeName())
            guard let sourceModelPath = dbInfo.dataModelFolderURL()?.URLByAppendingPathComponent(modelVersionInfo.currentModel), sourceModel = NSManagedObjectModel(contentsOfURL: sourceModelPath), mappingModel = NSMappingModel(contentsOfURL: mappModelPath), destinationModelPath = dbInfo.dataModelFolderURL()?.URLByAppendingPathComponent(dm), destinationModel = NSManagedObjectModel(contentsOfURL: destinationModelPath) else {
                continue
            }
            guard let destinationURL = self.destinationStoreURLWithSourceStoreURL(storeURL, modelName: dbInfo.modelName()) else {
                continue
            }
            let manager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
            // Add user info in migration manager to identify different data base
            manager.userInfo = dbInfo.migrationUserInfo()

            do {
                try manager.migrateStoreFromURL(storeURL, type: NSSQLiteStoreType, options: nil, withMappingModel: mappingModel, toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
            } catch {
                print(error)
                if let destinationFolderPath = destinationURL.URLByDeletingLastPathComponent?.path where NSFileManager.defaultManager().fileExistsAtPath(destinationFolderPath) {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(destinationFolderPath)
                    } catch {
                        print(error)
                    }

                }
                return false
            }
            if !self.backupWithProjectFolder(url, sourceStoreURL: storeURL, destinationURL: destinationURL, modelName: dbInfo.modelName(), currentVersionName: dm) {
                return false
            }
        }
        return true
    }

    func recursiveMigrationToDestinationWithFolderURL(url: NSURL) -> Bool {
        if self.doMigrationWithFolderURL(url) {
            if let next = self.nextVersionMigrationManager {

                return  next.recursiveMigrationToDestinationWithFolderURL(url)
            } else {

                return true
            }
        } else {

            return false
        }

    }

}
