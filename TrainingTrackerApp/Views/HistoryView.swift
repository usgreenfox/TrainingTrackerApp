import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: TrainingViewModel

    var body: some View {
        List {
            ForEach(viewModel.entries) { entry in
                NavigationLink(destination: EditEntryView(viewModel: viewModel, entry: entry)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.activity)
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
    @State private var durationMinutes: Double

    private let activities = ["読書", "エクササイズ", "勉強", "筋トレ"]

    init(viewModel: TrainingViewModel, entry: TrainingEntry) {
        self.viewModel = viewModel
        _entry = State(initialValue: entry)
        _durationMinutes = State(initialValue: Double(entry.duration))
    }

    var body: some View {
        Form {
            Section(header: Text("内容")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("種目")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(activities, id: \.self) { activity in
                                Button {
                                    entry.activity = activity
                                } label: {
                                    Text(activity)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(entry.activity == activity ? Color("AccentColor").opacity(0.2) : Color.white.opacity(0.05))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color("AccentColor").opacity(entry.activity == activity ? 0.8 : 0.3), lineWidth: 1)
                                        )
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("時間（分）")
                        Spacer()
                        Text("\(Int(durationMinutes)) 分")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $durationMinutes, in: 0...180, step: 5) {
                        Text("時間（分）")
                    }
                    .tint(Color("AccentColor"))
                }

                TextField("メモ", text: $entry.note)
                    .foregroundColor(.white)
            }

            Section {
                Button("更新") {
                    entry.duration = Int(durationMinutes)
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
