import SwiftUI

struct TrainingInputView: View {
    @ObservedObject var viewModel: TrainingViewModel

    @State private var selectedActivity = "読書"
    @State private var durationMinutes: Double = 30
    @State private var note = ""

    private let activities = ["読書", "エクササイズ", "勉強", "筋トレ"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("種目")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    ForEach(activities, id: \.self) { activity in
                        Button {
                            selectedActivity = activity
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: activityIcon(for: activity))
                                    .font(.footnote)
                                Text(activity)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .frame(maxWidth: .infinity)
                            .background(selectedActivity == activity ? Color("AccentColor").opacity(0.2) : Color.white.opacity(0.05))
                            .overlay(
                                Capsule()
                                    .stroke(Color("AccentColor").opacity(selectedActivity == activity ? 0.8 : 0.3), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("時間（分）")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(durationMinutes)) 分")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Slider(value: $durationMinutes, in: 0...180, step: 5) {
                    Text("時間（分）")
                }
                .tint(Color("AccentColor"))
            }

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
        let entry = TrainingEntry(date: Date(), activity: selectedActivity, duration: Int(durationMinutes), note: note)
        viewModel.addEntry(entry)
        durationMinutes = 30
        note = ""
    }

    private func activityIcon(for activity: String) -> String {
        switch activity {
        case "読書":
            return "book.fill"
        case "エクササイズ":
            return "figure.cooldown"
        case "勉強":
            return "brain.head.profile"
        case "筋トレ":
            return "dumbbell.fill"
        default:
            return "sparkles"
        }
    }
}
