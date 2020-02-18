import Vapor
import FluentSQLite

final class Carefinder: Codable {
    var id: UUID?
    let hospName: String
    var insurance: [String]
    let latitude: Double
    let longitude: Double
    var doctor: [Doctor]
    
    init(hospName: String, insurance: [String], latitude: Double, longitude: Double, doctor: [Doctor]) {
        self.hospName = hospName
        self.insurance = insurance
        self.latitude = latitude
        self.longitude = longitude
        self.doctor = doctor
    }
    
}

class Doctor: Codable {
    let name: String
    let prof: String
    
    init(name: String, prof: String) {
        self.name = name
        self.prof = prof
    }
}

//SQliteUUIDModel to map database ID types
extension Carefinder: SQLiteUUIDModel {}

//To save the model in the database, you must create a table for it. Fluent does this with a Migration
extension Carefinder: Migration {}

