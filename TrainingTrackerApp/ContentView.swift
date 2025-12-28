import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TrainingViewModel()

    private let backgroundGradient = LinearGradient(
        colors: [Color("AppBackground"), Color("AppSurface")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
//                        header

                        HeatmapView(entries: viewModel.entries)
                            .frame(height: 200)
                            .padding(.bottom, 24)

                        TrainingInputView(viewModel: viewModel)

                        NavigationLink(destination: HistoryView(viewModel: viewModel)) {
                            HStack(spacing: 8) {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("履歴を見る")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor").opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color("AccentColor").opacity(0.4), lineWidth: 1)
                            )
                            .cornerRadius(14)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 32)
                    .padding(.horizontal, 16)
                }
            }
//            .navigationTitle("習慣タイム記録")
        }
        .preferredColorScheme(.dark)
        .tint(Color("AccentColor"))
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("AccentColor").opacity(0.15))
                    .frame(width: 64, height: 64)

                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color("AccentColor"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("今日の積み上げ")
                    .font(.headline)
                Text("読書やエクササイズなどの時間をシンプルに記録しましょう")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}
