import Vapor
import FluentPostgreSQL

final class Carefinder: Codable {
    var id: UUID?
    var hospName: String
    var latitude: Double
    var longitude: Double
    //var doctor: [Doctor]
    //var insurance: [Insurance]
    
    init(hospName: String, latitude: Double, longitude: Double) {
        self.hospName = hospName
        self.latitude = latitude
        self.longitude = longitude
        //self.doctor = doctor
        //self.insurance = insurance
    }
    
}

final class Doctor: Codable {
    var id: UUID?
    let name: String
    let prof: String
    
    init(name: String, prof: String) {
        self.name = name
        self.prof = prof
    }
}

final class Insurance: Codable {
    var id: UUID?
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

//SQliteUUIDModel to map database ID types
extension Carefinder: PostgreSQLUUIDModel {}
//extension Doctor: SQLiteUUIDModel {}

//sTo save the model in the database, you must create a table for it. Fluent does this with a Migration
extension Carefinder: Migration {}
//extension Doctor: Migration {}

//Saving new data is done using Content
extension Carefinder: Content {}
//extension Doctor: Content {}

extension Carefinder: Parameter {}
