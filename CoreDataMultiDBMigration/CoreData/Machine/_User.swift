// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import Foundation
import CoreData

public enum UserAttributes: String {
    case country = "country"
    case id = "id"
    case name = "name"
}

public class _User: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "User"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _User.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var country: String?

    @NSManaged public
    var id: NSUUID

    @NSManaged public
    var name: String?

    // MARK: - Relationships

}

