// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Comment.swift instead.

import Foundation
import CoreData

public enum CommentAttributes: String {
    case content = "content"
    case createdAt = "createdAt"
    case id = "id"
    case issueId = "issueId"
}

public enum CommentUserInfo: String {
    case attributeValueClassName = "attributeValueClassName"
}

public class _Comment: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Comment"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Comment.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var content: String

    @NSManaged public
    var createdAt: NSDate

    @NSManaged public
    var id: NSUUID

    @NSManaged public
    var issueId: AnyObject

    // MARK: - Relationships

}

