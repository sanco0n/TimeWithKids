import Foundation

struct Child: Identifiable, Codable {
    var id = UUID()
    var name: String
    var birthday: Date
    var targetAge: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthday, targetAge
    }
} 