//
//  LocalV0ToV1UserMappingPolicy.swift
//  CoreDataMultiDBMigration
//
//  Created by Jason.zhang on 9/11/16.
//  Copyright © 2016 Jason.zhang. All rights reserved.
//

import UIKit
import CoreData
class LocalV0ToV1UserMappingPolicy: NSEntityMigrationPolicy {

    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let fetchRequest = NSFetchRequest(entityName: "Role")
        guard let roleObjects = try? manager.sourceContext.executeFetchRequest(fetchRequest), roles = roleObjects as? [NSManagedObject] where roles.count > 0 else {
            try super.createDestinationInstancesForSourceInstance(sInstance, entityMapping: mapping, manager: manager)
            return
        }

        guard let roleId = roles[0].valueForKey("id") as? NSUUID else {

            try super.createDestinationInstancesForSourceInstance(sInstance, entityMapping: mapping, manager: manager)
            return
        }
        // DestinationInstance
        let dInstance = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: manager.destinationContext)
        dInstance.setValue(roleId, forKey: "role")
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
