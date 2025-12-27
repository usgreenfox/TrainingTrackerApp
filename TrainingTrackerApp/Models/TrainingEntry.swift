import Foundation

struct TrainingEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var activity: String
    var duration: Int
    var note: String

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case activity
        case duration
        case note
        case exercise // For backward compatibility with previous app concept
    }

    init(id: UUID = UUID(), date: Date, activity: String, duration: Int, note: String) {
        self.id = id
        self.date = date
        self.activity = activity
        self.duration = duration
        self.note = note
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
        try container.encode(note, forKey: .note)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        date = try container.decode(Date.self, forKey: .date)

        if let activity = try container.decodeIfPresent(String.self, forKey: .activity) {
            self.activity = activity
        } else {
            self.activity = try container.decode(String.self, forKey: .exercise)
        }

        duration = try container.decode(Int.self, forKey: .duration)
        note = try container.decode(String.self, forKey: .note)
    }
}
