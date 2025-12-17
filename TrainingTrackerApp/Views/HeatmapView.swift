import SwiftUI

struct HeatmapView: View {
    var entries: [TrainingEntry]

    private let weeksToShow = 12
    private let calendar = Calendar.current

    private var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }

    private var startDate: Date {
        calendar.date(byAdding: .day, value: -(weeksToShow - 1) * 7, to: startOfWeek) ?? startOfWeek
    }

    private var days: [Date] {
        (0..<(weeksToShow * 7)).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }

    private var maxDuration: Int {
        entries.map { $0.duration }.max() ?? 0
    }

    private func duration(for date: Date) -> Int {
        entries
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { $0 + $1.duration }
    }

    private func color(for duration: Int) -> Color {
        guard duration > 0 else { return Color.white.opacity(0.08) }

        let normalized = maxDuration > 0 ? Double(duration) / Double(maxDuration) : 0
        let opacity = 0.25 + normalized * 0.65
        return Color("AccentColor").opacity(opacity)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("直近12週間のトレーニング量")
                .font(.headline)
                .foregroundColor(.white)

            HStack(alignment: .top, spacing: 4) {
                ForEach(0..<weeksToShow, id: \.self) { week in
                    VStack(spacing: 4) {
                        ForEach(0..<7, id: \.self) { day in
                            let index = week * 7 + day
                            let date = days[index]
                            let value = duration(for: date)

                            Rectangle()
                                .fill(color(for: value))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(value > 0 ? "\(min(value, 99))" : "")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                )
                                .cornerRadius(4)
                                .accessibilityLabel(Text("\(dateFormatted(date)): \(value)分"))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color("AppSurface"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
