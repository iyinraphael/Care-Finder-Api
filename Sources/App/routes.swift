import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
//    // Basic "It works" example
//    router.get { req in
//        return "It works!"
//    }
//
//    // Basic "Hello, world!" example
//    router.get("hello") { req in
//        return "Hello, world!"
//    }
//
//    router.get("hello", String.parameter) { req -> String in
//        let name = try req.parameters.next(String.self)
//      return "Hello \(name)"
//    }
//
//    router.post(InfoData.self, at: "info") { req, data -> InfoResponse in
//    return InfoResponse(request: data)
//    }
    
    
    
    //Register a new route at /api/careFinder that accepts POST request and returns Future<CareFinder>.
    router.post("api", "carefinder") { req -> Future<Carefinder> in
        
        //Decode the request's JSON into an CareFinder model using Codable
        return try req.content.decode(Carefinder.self)
            .flatMap(to: Carefinder.self) { careFinder  in
                
            //This returns Future<CareFinder as it returns the model once it's saved
                return careFinder.save(on: req)
            }
    }
    
    //GET all data
    router.get("api", "carefinder") { req -> Future<[Carefinder]> in
        
        return Carefinder.query(on: req).all()
    }
    //GET single data with parameter
    router.get("api", "carefinder", Carefinder.parameter) { req -> Future<Carefinder> in
        
        return try req.parameters.next(Carefinder.self)
    }
    //PUT to update single data json
    router.put("api", "carefinder", Carefinder.parameter) { req -> Future<Carefinder> in
        
        return try flatMap(to: Carefinder.self,
                           req.parameters.next(Carefinder.self),
                           req.content.decode(Carefinder.self), { (carefinder, updatedCarefinder) in
                            
                            carefinder.hospName = updatedCarefinder.hospName
                            carefinder.latitude = updatedCarefinder.latitude
                            carefinder.longitude = updatedCarefinder.longitude
                            
                            return carefinder.save(on: req)
                                
        })
    }
    //DELETE data from json
    router.delete("api", "carefinder", Carefinder.parameter) { (req) -> Future<HTTPStatus> in
        
        return try req.parameters.next(Carefinder.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }
    
    
    //SEARCH with FLUENT
    router.get("api", "carefinder", "search") { (req) -> Future<[Carefinder]> in
    
        guard let searhTerm = req.query[String.self, at: "term"] else { throw Abort(.badRequest)}
        
        return Carefinder.query(on: req)
                .filter(\.hospName == searhTerm)
                .all()
    }
}

//struct InfoResponse: Content {
//  let request: InfoData
//}
//
//struct InfoData: Content {
// let name: String
//}
