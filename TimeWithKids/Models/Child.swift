import Foundation

enum MilestoneType: String, Codable, CaseIterable, Identifiable {
    case age
    case date
    var id: String { self.rawValue }
}

struct Milestone: Identifiable, Codable {
    let id: UUID
    var title: String
    var type: MilestoneType
    var targetDate: Date? // type == .date の場合に使用
    var targetAge: Int?   // type == .age の場合に使用
    
    init(id: UUID = UUID(), title: String, type: MilestoneType, targetDate: Date? = nil, targetAge: Int? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.targetDate = targetDate
        self.targetAge = targetAge
    }
}

struct Child: Identifiable, Codable {
    let id: UUID
    var name: String
    var birthday: Date
    var milestones: [Milestone] = []
    
    init(id: UUID = UUID(), name: String, birthday: Date, milestones: [Milestone] = []) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.milestones = milestones
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthday, milestones
    }
} 