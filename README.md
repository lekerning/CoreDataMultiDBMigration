# CoreDataMultiDBMigration
Core Data multi data base migration, multi data bases migrate from certain version to the latest version concurrently, do data operation across data base
    
    1 Use:
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

