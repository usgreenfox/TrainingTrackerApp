import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: TrainingViewModel

    var body: some View {
        List {
            ForEach(viewModel.entries) { entry in
                NavigationLink(destination: EditEntryView(viewModel: viewModel, entry: entry)) {
                    VStack(alignment: .leading) {
                        Text(entry.exercise)
                            .font(.headline)
                        Text(entry.date, style: .date)
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationTitle("履歴一覧")
    }
}

struct EditEntryView: View {
    @ObservedObject var viewModel: TrainingViewModel
    @State var entry: TrainingEntry

    var body: some View {
        Form {
            TextField("種目", text: $entry.exercise)
            TextField("時間", value: $entry.duration, formatter: NumberFormatter())
            TextField("メモ", text: $entry.note)

            Button("更新") {
                viewModel.updateEntry(entry)
            }
        }
    }
}
