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
        // 1.0
        let versionInfoServer: VersionMigrationAble = DataBaseInfo.Server(ModelVersionInfo(currentModel: "Server.mom", mappingModel: "ServerV0ToV1MappingModel.cdm", destinationModel: "Server_V1.mom"))
        let versionInfo1Local: VersionMigrationAble = DataBaseInfo.Local(ModelVersionInfo(currentModel: "Local.mom", mappingModel: "LocalV0ToV1MappingModel.cdm", destinationModel: "Local_V1.mom"))
        let singleManage1_0 = VersionMigrationManager(dbs: [versionInfoServer, versionInfo1Local])

        // 1.1
        let versionInfoServer1: VersionMigrationAble = DataBaseInfo.Server(ModelVersionInfo(currentModel: "Server_V1.mom", mappingModel: nil, destinationModel: nil))
        let versionInfo1Local1: VersionMigrationAble = DataBaseInfo.Local(ModelVersionInfo(currentModel: "Local_V1.mom", mappingModel: nil, destinationModel: nil))
        let singleManage1_1 = VersionMigrationManager(dbs: [versionInfoServer1, versionInfo1Local1])
        singleManage1_0.nextVersionMigrationManager = singleManage1_1





        return singleManage1_0

    }

    func dataBaseNames() -> [String] {
        return [serverDBStoreName, localDBStoreName]
    }



}
