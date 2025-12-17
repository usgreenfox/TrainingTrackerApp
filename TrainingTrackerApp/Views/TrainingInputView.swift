import SwiftUI

struct TrainingInputView: View {
    @ObservedObject var viewModel: TrainingViewModel

    @State private var exercise = ""
    @State private var duration = ""
    @State private var note = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            inputField(title: "種目", text: $exercise, systemIcon: "figure.run")

            inputField(title: "時間（分）", text: $duration, systemIcon: "clock", keyboard: .numberPad)

            inputField(title: "メモ", text: $note, systemIcon: "pencil.line")

            Button(action: registerEntry) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                    Text("登録")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color("AccentColor"), Color("AccentColor").opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
                .shadow(color: Color("AccentColor").opacity(0.35), radius: 12, x: 0, y: 8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color("AppSurface"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private func inputField(title: String, text: Binding<String>, systemIcon: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Image(systemName: systemIcon)
                    .foregroundColor(Color("AccentColor"))

                TextField(title, text: text)
                    .foregroundColor(.white)
                    .keyboardType(keyboard)
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }

    private func registerEntry() {
        if let durationInt = Int(duration) {
            let entry = TrainingEntry(date: Date(), exercise: exercise, duration: durationInt, note: note)
            viewModel.addEntry(entry)
            exercise = ""
            duration = ""
            note = ""
        }
    }
}
