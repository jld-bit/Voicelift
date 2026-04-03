import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.indigo.opacity(0.4), Color.pink.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "waveform.badge.mic")
                    .font(.system(size: 72))
                    .symbolRenderingMode(.multicolor)

                Text("Welcome to VoiceLift")
                    .font(.largeTitle.bold())

                Text("Capture ideas, transcribe voice notes, and organize your day with colorful, effortless audio journaling.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Label("Pause and resume while recording", systemImage: "pause.circle")
                    Label("AI titles + quick summaries", systemImage: "sparkles")
                    Label("Tags to keep notes organized", systemImage: "tag")
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                Button("Get Started") {
                    onFinish()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
    }
}
