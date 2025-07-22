import Foundation

enum MilestoneType: String, Codable, CaseIterable, Identifiable {
    case age
    case date
    var id: String { self.rawValue }
}

struct Milestone: Identifiable, Codable {
    var id = UUID()
    var title: String
    var type: MilestoneType
    var targetDate: Date? // type == .date の場合に使用
    var targetAge: Int?   // type == .age の場合に使用
}

struct Child: Identifiable, Codable {
    var id = UUID()
    var name: String
    var birthday: Date
    var milestones: [Milestone] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthday, milestones
    }
} 