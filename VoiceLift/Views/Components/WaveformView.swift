import SwiftUI

struct WaveformView: View {
    let progress: Double

    private let bars = (0..<30).map { _ in Double.random(in: 0.2...1.0) }

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(Array(bars.enumerated()), id: \.offset) { index, barHeight in
                Capsule()
                    .fill(indexRatio(index) <= progress ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 5, height: CGFloat(12 + barHeight * 35))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: progress)
    }

    private func indexRatio(_ index: Int) -> Double {
        Double(index + 1) / Double(bars.count)
    }
}
