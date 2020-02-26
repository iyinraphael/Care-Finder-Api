import Vapor

struct DoctorController: RouteCollection {
    
    func boot(router: Router) throws {
        let doctorRoute = router.grouped("api", "doctor")
        
        doctorRoute.post(Doctor.self, use: createHandler)
        doctorRoute.get(use: getAllHandeler)
        doctorRoute.get(Doctor.parameter, use: getHandler)
        doctorRoute.get(Doctor.parameter, "carefinder", use: getCareFinderHandle)
    }
    
    func createHandler(_ req: Request, doctor: Doctor) throws -> Future<Doctor> {
        return doctor.save(on: req)
    }
    
    func getAllHandeler(_ req: Request) throws -> Future <[Doctor]> {
          return Doctor.query(on: req).all()
      }

    func getHandler(_ req: Request) throws -> Future<Doctor> {
          return try req.parameters.next(Doctor.self)
      }
    
    func getCareFinderHandle(_ req: Request) throws -> Future<Carefinder> {
        return try req.parameters.next(Doctor.self)
            .flatMap(to: Carefinder.self, { (doctor)  in
                doctor.carefinder.get(on: req)
            })
    }
    
}
