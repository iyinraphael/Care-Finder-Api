import Vapor
import Fluent


struct CareFinderController: RouteCollection {
    
    
    func boot(router: Router) throws {
        let carefinderRoutes = router.grouped("api", "carefinder")
        
        carefinderRoutes.get(use: getAllHandler)
        carefinderRoutes.get(Carefinder.parameter, use: getHandler)
        carefinderRoutes.post(Carefinder.self, use: creatHandler)
        carefinderRoutes.put(use: updateHandler)
        carefinderRoutes.get("search", use: searchHandler)
        carefinderRoutes.delete(use: deleteHandler)
    }
    
    
//MARK: - CRUD
    
     //POST Data to Database
    func creatHandler(_ req: Request, carefinder: Carefinder) throws -> Future<Carefinder> {
        return carefinder.save(on: req)
    }
    
    //GET all Data from Database
    func getAllHandler(_ req: Request) throws -> Future<[Carefinder]>  {
        return Carefinder.query(on: req).all()
    }
    
    //GET single Data from Database with ID
    func getHandler(_ req: Request) throws -> Future<Carefinder> {
        return try req.parameters.next(Carefinder.self)
    }
    
    //UPDATE Data from Database
    func updateHandler(_ req: Request) throws -> Future<Carefinder> {
        return try flatMap(to: Carefinder.self,
                           req.parameters.next(Carefinder.self),
                           req.content.decode(Carefinder.self), { (carefinder, updatedCarefinder) in
                            
                            carefinder.hospName = updatedCarefinder.hospName
                            carefinder.latitude = updatedCarefinder.latitude
                            carefinder.longitude = updatedCarefinder.longitude
                            
                            return carefinder.save(on: req)
        })
    }
    
    //SEARCH for Data in Database
    func searchHandler(_ req: Request) throws -> Future<[Carefinder]> {
        guard let searchTerm = req.query[String.self, at: "term"] else { throw Abort(.badRequest) }
        return Carefinder.query(on: req).group(.or) { (or) in
            or.filter(\.hospName == searchTerm)
        }.all()
    }
    
    //DELETE data from database
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters
                    .next(Carefinder.self)
                    .delete(on: req)
                    .transform(to: HTTPStatus.noContent)
    }
}
