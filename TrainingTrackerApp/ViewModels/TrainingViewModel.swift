import Foundation

class TrainingViewModel: ObservableObject {
    @Published var entries: [TrainingEntry] = []

    private let storageKey = "training_entries"

    init() {
        loadEntries()
    }

    func addEntry(_ entry: TrainingEntry) {
        entries.append(entry)
        saveEntries()
    }

    func updateEntry(_ entry: TrainingEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([TrainingEntry].self, from: data) {
            entries = decoded
        }
    }
}
