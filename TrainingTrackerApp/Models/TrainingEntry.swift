import Foundation

struct TrainingEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var exercise: String
    var duration: Int
    var note: String
}
