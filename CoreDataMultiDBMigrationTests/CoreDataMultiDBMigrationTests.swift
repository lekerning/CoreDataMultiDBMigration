//
//  CoreDataMultiDBMigrationTests.swift
//  CoreDataMultiDBMigrationTests
//
//  Created by Jason.zhang on 9/4/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataMultiDBMigration

let docDir: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]

}()

class CoreDataMultiDBMigrationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }

    func clearFilesForStore(storeName: String) {
        let fileManager = NSFileManager.defaultManager()
        let fileExts = [".sqlite", ".sqlite-shm", ".sqlite-wal"]
        for ext in fileExts {
            if let filePath = docDir.URLByAppendingPathComponent(storeName + ext).path where fileManager.fileExistsAtPath(filePath) {
                do {
                    try fileManager.removeItemAtPath(filePath)
                } catch {
                    print(error)
                }
            }
        }

    }


    func testServerDB_OriginalVersion() {
        // Test original model version
        let serverModelName = "Server"
        let serverStoreName = "server"
        // Test begin, clear old stores
        self.clearFilesForStore(serverStoreName)
        let serverCoreStack = CoreDataStack(modelName: serverModelName, modelVersion: serverModelName, storeFileName: serverStoreName + ".sqlite")
        let serverContext = serverCoreStack.theMainContext

        let newComment0: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: serverContext)
        let id0 = NSUUID()

        newComment0.setValue(id0, forKey: "id")
        newComment0.setValue("This is first comment from jason zhang", forKey: "content")
        newComment0.setValue(NSDate(), forKey: "createdAt")

        let newComment1: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: serverContext)
        let id1 = NSUUID()

        newComment1.setValue(id1, forKey: "id")
        newComment1.setValue("This is second comment from  young", forKey: "content")
        newComment1.setValue(NSDate(), forKey: "createdAt")

        let issue0: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Issue", inManagedObjectContext: serverContext)
        let issueId0 = NSUUID()

        issue0.setValue(issueId0, forKey: IssueAttributes.id.rawValue)
        issue0.setValue("First issue", forKey: IssueAttributes.title.rawValue)
        issue0.setValue("First issue in original model version", forKey: IssueAttributes.content.rawValue)
        issue0.setValue(NSDate(), forKey: IssueAttributes.createdAt.rawValue)
        issue0.setValue([id0, id1], forKey: "comments")

        serverCoreStack.saveMainContext()

        // Local db, ===
        let localModelName = "Local"
        let localStoreName = "Local"

        self.clearFilesForStore(localStoreName)

        let localCoreStack = CoreDataStack(modelName: localModelName, modelVersion: localModelName, storeFileName: localStoreName + ".sqlite")
        let localContext = localCoreStack.theMainContext

        let user0 = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: localContext)

        user0.setValue(NSUUID(), forKey: UserAttributes.id.rawValue)
        user0.setValue("Lily", forKey: UserAttributes.name.rawValue)
        user0.setValue("China", forKey: UserAttributes.country.rawValue)


        let user1 = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: localContext)
        user1.setValue(NSUUID(), forKey: UserAttributes.id.rawValue)
        user1.setValue("Jason", forKey: UserAttributes.name.rawValue)
        user1.setValue("US", forKey: UserAttributes.country.rawValue)


        let role0 = NSEntityDescription.insertNewObjectForEntityForName("Role", inManagedObjectContext: localContext)
        role0.setValue(NSUUID(), forKey: RoleAttributes.id.rawValue)
        role0.setValue("Teacher", forKey: RoleAttributes.title.rawValue)
        role0.setValue("people who teach others", forKey: RoleAttributes.comment.rawValue)


        let role1 = NSEntityDescription.insertNewObjectForEntityForName("Role", inManagedObjectContext: localContext)
        role1.setValue(NSUUID(), forKey: RoleAttributes.id.rawValue)
        role1.setValue("Engineer", forKey: RoleAttributes.title.rawValue)
        role1.setValue("People who has special skill", forKey: RoleAttributes.comment.rawValue)

        localCoreStack.saveMainContext()

    }


    func test_MigrationDataBaseOfV0() {

        let testFolder = "DataV0"
        guard let parentFolderPath = docDir.URLByAppendingPathComponent(testFolder).path else {
            XCTAssert(false)
            return
        }

        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(parentFolderPath) {
            do {
                try fileManager.removeItemAtPath(parentFolderPath)
            } catch {
                print(error)
            }
        }

        do {
            try fileManager.createDirectoryAtPath(parentFolderPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }

        let storeNames = ["Server", "Local"]
        let exts = [".sqlite", ".sqlite-shm", ".sqlite-wal"]
        let bundleURL =  NSBundle.mainBundle().bundleURL

        for store in storeNames {
            for ext in exts {
                let file = store + ext
                let sourceURL = bundleURL.URLByAppendingPathComponent(file)
                let destinationURL = docDir.URLByAppendingPathComponent(testFolder).URLByAppendingPathComponent(file)
                if let sourcePath = sourceURL.path where fileManager.fileExistsAtPath(sourcePath) {

                    do {

                        try fileManager.copyItemAtURL(sourceURL, toURL: destinationURL)
                    } catch {
                        print(error)
                    }


                }
            }
        }

        // do migration
        let manager = CustomMultiDBMigrationManager(url: NSURL(fileURLWithPath: parentFolderPath))
        let wrapper = MultiDBMigrationWrapper(delegate: manager)

        let migrationResult = wrapper.doMigration()

        switch migrationResult {

        case .NoNeedToDo, .MigrationSuccess:
            print(migrationResult.rawValue)

        case .MigrationFailed:

            XCTAssert(false)

        }

    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
