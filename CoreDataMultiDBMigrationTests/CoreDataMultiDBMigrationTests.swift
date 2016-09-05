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


    func testServerDB_OriginalVersion() {

        // Test original model version
        let fileManager = NSFileManager.defaultManager()
        let serverModelName = "Server"
        let storeFile = "server.sqlite"

        if let storePath = docDir.URLByAppendingPathComponent(storeFile).path {
            let files = [storePath, storePath + "-shm", storePath + "-wal"]
            for file in files {
                if fileManager.fileExistsAtPath(file) {
                    do {
                        try fileManager.removeItemAtPath(file)
                    } catch {
                        print(error)
                    }
                }
            }
        }

        let serverCoreStack = CoreDataStack(modelName: serverModelName, modelVersionName: serverModelName, storeFileName: storeFile)
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
        issue0.setValue([id0, id1], forKey: IssueAttributes.comments.rawValue)

        serverCoreStack.saveMainContext()

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
