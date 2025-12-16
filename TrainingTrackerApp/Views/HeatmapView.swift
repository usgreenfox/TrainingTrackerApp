import SwiftUI

struct HeatmapView: View {
    var entries: [TrainingEntry]

    var body: some View {
        Text("ヒートマップはここに表示されます（簡易）")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}
