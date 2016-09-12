# CoreDataMultiDBMigration
Core Data multi data base migration, multi data bases migrate from certain version to the latest version concurrently, do data operation across data base
    
    Two general classes:
    
    VersionMigrationManager
     A singly linked list, each node contains information of multi core data models
     do migration from version to version 
     
    MultiDBMigrationWrapper
     A wrapper of VersionMigrationManager, use delegate pattern to get migration infos form delegate
     
    Useage:  
        1 Custom a type that confirms protocol VersionMigrationAble, which contains model info of single version
        like enum DataBaseInfo does
        
        2 Custom a type that comfirms protocol MultiDBMigrationWrapperDelegate
        like CustomMultiDBMigrationManager does 
    Simple code: 
         let manager = CustomMultiDBMigrationManager(url: NSURL(fileURLWithPath: parentFolderPath))
        let wrapper = MultiDBMigrationWrapper(delegate: someDelegate)
        let migrationResult = wrapper.doMigration()
        switch migrationResult {
        case .NoNeedToDo:
            // do something
            print(migrationResult.rawValue)
        case .MigrationSuccess:
             // do something
            print(migrationResult.rawValue)
        case .MigrationFailed:
            // do something
            print(migrationResult.rawValue)
        }
        
        someDelegate is a member of class that should implement MultiDBMigrationWrapperDelegate protocol

