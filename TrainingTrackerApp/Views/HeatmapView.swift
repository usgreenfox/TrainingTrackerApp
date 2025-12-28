import SwiftUI

struct HeatmapView: View {
    var entries: [TrainingEntry]

    private let weeksToShow = 12
    private let calendar = Calendar.current
    private let intensityLevels = 4
    private let referenceDuration = 180

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

    private func duration(for date: Date) -> Int {
        entries
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { $0 + $1.duration }
    }

    private func color(for duration: Int) -> Color {
        guard duration > 0 else { return Color.white.opacity(0.08) }

        let clampedDuration = min(duration, referenceDuration)
        let normalized = Double(clampedDuration) / Double(referenceDuration)
        let level = max(1, Int(ceil(normalized * Double(intensityLevels))))
        let minOpacity: Double = 0.2
        let maxOpacity: Double = 0.85
        let step = (maxOpacity - minOpacity) / Double(max(intensityLevels - 1, 1))
        let opacity = minOpacity + step * Double(level - 1)

        return Color("AccentColor").opacity(opacity)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("直近12週間のアクティビティ")
                .font(.headline)
                .foregroundColor(.white)

            ZStack(alignment: .topLeading) {
                heatmapGrid

                HStack {
                    Text("過去")
                    Spacer()
                    Text("今日")
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 4)
                .padding(.top, -2)

                VStack {
                    HStack {
                        Spacer()
                        Text("Sun")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    HStack {
                        Text("Sat")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }
                }
                .padding(2)
            }

            legend
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

    private var heatmapGrid: some View {
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
                            .cornerRadius(4)
                            .accessibilityLabel(Text("\(dateFormatted(date)): \(value)分"))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var legend: some View {
        HStack(spacing: 8) {
            Text("less")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))

            HStack(spacing: 4) {
                ForEach(0..<intensityLevels, id: \.self) { level in
                    let sampleDuration = Int(
                        Double(referenceDuration) * Double(level) / Double(max(intensityLevels - 1, 1))
                    )
                    Rectangle()
                        .fill(color(for: sampleDuration))
                        .frame(width: 18, height: 10)
                        .cornerRadius(2)
                }
            }

            Text("more")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}
