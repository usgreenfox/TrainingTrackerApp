import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TrainingViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HeatmapView(entries: viewModel.entries)
                    .frame(height: 200)

                TrainingInputView(viewModel: viewModel)

                NavigationLink("履歴を見る", destination: HistoryView(viewModel: viewModel))
                    .padding()
            }
            .navigationTitle("トレーニング記録")
        }
    }
}
