//
//  CustomMultiDBMigrationManager.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import Foundation

class CustomMultiDBMigrationManager {
    var url: NSURL
    init(url: NSURL) {
        self.url = url
    }
}

extension CustomMultiDBMigrationManager: MultiDBMigrationWrapperDelegate {
    func dataBaseStoreParentFolderURL() -> NSURL {
        return self.url
    }

    func migrationRoadMap() -> VersionMigrationManager {
        let versionInfo1: VersionMigrationAble = DataBaseInfo.Server(ModelVersionInfo(currentModel: "Server.mom", mappingModel: nil, destinationModel: nil))
        let versionInfo1Local: VersionMigrationAble = DataBaseInfo.Local(ModelVersionInfo(currentModel: "Local.mom", mappingModel: nil, destinationModel: nil))
        let singleManage1_1 = VersionMigrationManager(dbs: [versionInfo1, versionInfo1Local])

        return singleManage1_1

    }

    func dataBaseNames() -> [String] {
        return [serverDBStoreName, localDBStoreName]
    }



}
