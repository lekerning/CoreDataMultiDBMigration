//
//  ServerV0ToV1IssueMappingPolicy.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import UIKit
import CoreData
@objc
class ServerV0ToV1IssueMappingPolicy: NSEntityMigrationPolicy {
    @objc override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        if let commnetsIds = sInstance.valueForKey("comments") as? [NSUUID] {
            guard let issueId = sInstance.valueForKey("id") as? NSUUID  else {
                try super.createDestinationInstancesForSourceInstance(sInstance, entityMapping: mapping, manager: manager)
                return
            }
            for commentId in commnetsIds {
                let request = NSFetchRequest(entityName: "Comment")
                request.predicate = NSPredicate(format: "id = %@", commentId)
                if let commentAarray = try? manager.destinationContext.executeFetchRequest(request), commments = commentAarray as? [NSManagedObject] {
                    for comment in commments {
                        comment.setValue(issueId, forKey: "issueId")
                    }
                }
            }
        }
        // DestinationInstance
        let dInstance = NSEntityDescription.insertNewObjectForEntityForName("Issue", inManagedObjectContext: manager.destinationContext)
        let attributesKeys = dInstance.entity.attributesByName.keys
        let sAttaributes = sInstance.entity.attributesByName
        for attribute in attributesKeys {
            if let _ = sAttaributes[attribute] {
                if let value = sInstance.valueForKey(attribute) {
                    dInstance.setValue(value, forKey: attribute)
                } else {
                    dInstance.setNilValueForKey(attribute)
                }
            }
        }
        manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)

    }

}
