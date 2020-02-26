import Vapor
import FluentPostgreSQL

final class Carefinder: Codable {
    var id: UUID?
    var hospName: String
    var latitude: Double
    var longitude: Double
    
    init(hospName: String, latitude: Double, longitude: Double) {
        self.hospName = hospName
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

final class Doctor: Codable {
    var id: Int?
    var doctorID: Carefinder.ID
    let name: String 
    let prof: String
    
    init(name: String, prof: String, doctorID: Carefinder.ID) {
        self.name = name
        self.prof = prof
        self.doctorID = doctorID
    }
}

final class Insurance: Codable {
    var id: Int?
    var insuranceID: Carefinder.ID
    let name: String
    
    init(name: String, insuranceID: Carefinder.ID) {
        self.name = name
        self.insuranceID = insuranceID
    }
}

//SQliteUUIDModel to map database ID types
extension Carefinder: PostgreSQLUUIDModel {}
extension Insurance: PostgreSQLModel {}
extension Doctor: PostgreSQLModel {}

//sTo save the model in the database, you must create a table for it. Fluent does this with a Migration
extension Carefinder: Migration {}

extension Doctor: Migration {
    static func prepare( on connection: PostgreSQLConnection ) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
        try addProperties(to: builder)
        builder.reference(from: \.doctorID, to: \Carefinder.id)
        }
    }
}
extension Insurance: Migration {
    static func prepare( on connection: PostgreSQLConnection ) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
        try addProperties(to: builder)
        builder.reference(from: \.insuranceID, to: \Carefinder.id)
        }
    }
}

//Saving new data is done using Content
extension Carefinder: Content {}
extension Doctor: Content {}
extension Insurance: Content {}

//Parameter
extension Carefinder: Parameter {}
extension Doctor: Parameter {}
extension Insurance: Parameter {}


extension Doctor {
    var carefinder: Parent<Doctor, Carefinder> {
        return parent(\.doctorID)
    }
}

extension Insurance {
    var carefinder: Parent<Insurance, Carefinder> {
        return parent(\.insuranceID)
    }
}


extension Carefinder {
    var doctor: Children<Carefinder, Doctor> {
        return children(\.doctorID)
    }
    var insurance: Children<Carefinder, Insurance> {
        return children(\.insuranceID)
    }
}
