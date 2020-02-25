import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let carefinderController = CareFinderController()
    try router.register(collection: carefinderController)

}
