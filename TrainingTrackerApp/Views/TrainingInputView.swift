import SwiftUI

struct TrainingInputView: View {
    @ObservedObject var viewModel: TrainingViewModel

    @State private var exercise = ""
    @State private var duration = ""
    @State private var note = ""

    var body: some View {
        VStack {
            TextField("種目", text: $exercise)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("時間（分）", text: $duration)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("メモ", text: $note)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("登録") {
                if let durationInt = Int(duration) {
                    let entry = TrainingEntry(date: Date(), exercise: exercise, duration: durationInt, note: note)
                    viewModel.addEntry(entry)
                    exercise = ""
                    duration = ""
                    note = ""
                }
            }
            .padding()
        }
        .padding()
    }
}
