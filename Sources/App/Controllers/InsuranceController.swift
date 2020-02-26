import Vapor

struct InsuranceController: RouteCollection {
    
    func boot(router: Router) throws {
        let insuranceRoute = router.grouped("api", "insurance")
        
        insuranceRoute.post(Insurance.self, use: createHandler)
        insuranceRoute.get(use: getAllHandeler)
        insuranceRoute.get(Insurance.parameter, use: getHandler)
    }
    
    func createHandler(_ req: Request, insurance: Insurance) throws -> Future<Insurance> {
        return insurance.save(on: req)
    }
    
    func getAllHandeler(_ req: Request) throws -> Future <[Insurance]> {
        return Insurance.query(on: req).all()
    }

    func getHandler(_ req: Request) throws -> Future<Insurance> {
        return try req.parameters.next(Insurance.self)
    }
    
    func getCareFinderHandle(_ req: Request) throws -> Future<Carefinder> {
        return try req.parameters.next(Insurance.self)
            .flatMap(to: Carefinder.self, { (insurance)  in
                insurance.carefinder.get(on: req)
            })
    }
    
    
}
