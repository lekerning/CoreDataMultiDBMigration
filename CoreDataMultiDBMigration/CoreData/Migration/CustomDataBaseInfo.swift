//
//  CustomDataBaseInfo.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import Foundation

let serverModelName = "Server"
let localModelName = "Local"

let serverDBStoreName = "Server.sqlite"
let localDBStoreName = "Local.sqlite"

public enum DataBaseInfo: VersionMigrationAble {
    case Server(ModelVersionInfo)
    case Local(ModelVersionInfo)

    func modelName() -> String {
        switch self {
        case .Server(_):
            return serverModelName
        case .Local(_):
            return localModelName
        }
    }

    func storeName() -> String {
        switch self {
        case .Server(_):
            return serverDBStoreName
        case .Local(_):
            return localDBStoreName
        }
    }

    func dataModelFolderURL() -> NSURL? {
        return NSBundle.mainBundle().URLForResource(self.modelName(), withExtension: "momd")
    }

    func modelVersionInfo() -> ModelVersionInfo {
        switch self {
        case .Server(let info):
            return  info
        case .Local(let info):
            return info
        }
    }

    func migrationUserInfo() -> [NSObject : AnyObject]? {

        return nil
    }

}
