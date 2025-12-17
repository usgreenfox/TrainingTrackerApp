import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: TrainingViewModel

    var body: some View {
        List {
            ForEach(viewModel.entries) { entry in
                NavigationLink(destination: EditEntryView(viewModel: viewModel, entry: entry)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.exercise)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(entry.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 10)
                }
                .listRowBackground(Color("AppSurface"))
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("AppBackground"))
        .navigationTitle("履歴一覧")
    }
}

struct EditEntryView: View {
    @ObservedObject var viewModel: TrainingViewModel
    @State var entry: TrainingEntry

    var body: some View {
        Form {
            Section(header: Text("内容")) {
                TextField("種目", text: $entry.exercise)
                    .foregroundColor(.white)
                TextField("時間", value: $entry.duration, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                TextField("メモ", text: $entry.note)
                    .foregroundColor(.white)
            }

            Section {
                Button("更新") {
                    viewModel.updateEntry(entry)
                }
                .foregroundColor(Color("AccentColor"))
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("AppBackground"))
        .tint(Color("AccentColor"))
    }
}
