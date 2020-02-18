import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
      return "Hello \(name)"
    }
    
    router.post(InfoData.self, at: "info") { req, data -> InfoResponse in
    return InfoResponse(request: data)
    }
}

struct InfoResponse: Content {
  let request: InfoData
}

struct InfoData: Content {
 let name: String
}
