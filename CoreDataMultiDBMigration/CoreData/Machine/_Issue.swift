// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.swift instead.

import Foundation
import CoreData

public enum IssueAttributes: String {
    case comments = "comments"
    case content = "content"
    case createdAt = "createdAt"
    case id = "id"
    case title = "title"
}

public enum IssueUserInfo: String {
    case attributeValueClassName = "attributeValueClassName"
}

public class _Issue: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Issue"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Issue.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var comments: NSArray?

    @NSManaged public
    var content: String?

    @NSManaged public
    var createdAt: NSDate?

    @NSManaged public
    var id: AnyObject

    @NSManaged public
    var title: String

    // MARK: - Relationships

}

