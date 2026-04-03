import SwiftUI

struct RecorderView: View {
    @EnvironmentObject private var vm: RecordingsViewModel
    @EnvironmentObject private var purchaseManager: PurchaseManager

    @State private var tagInput = ""
    @State private var pendingTags: [String] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                GradientCard {
                    VStack(spacing: 12) {
                        Text(timeString(vm.recorder.elapsedTime))
                            .font(.system(size: 42, weight: .bold, design: .rounded))

                        Text(statusText)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            Button(primaryButtonTitle) {
                                Task {
                                    if vm.recorder.state == .idle {
                                        guard purchaseManager.canRecord else { return }
                                        await vm.beginRecording()
                                    } else {
                                        await vm.finishRecording(tags: pendingTags)
                                        purchaseManager.incrementWeeklyRecordingCount()
                                        pendingTags.removeAll()
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            if vm.recorder.state != .idle {
                                Button(vm.recorder.state == .paused ? "Resume" : "Pause") {
                                    vm.togglePauseResume()
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }

                if !purchaseManager.canRecord {
                    Text("Free plan limit reached this week. Upgrade for unlimited recordings.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                } else {
                    Text("\(purchaseManager.weeklyFreeLimit - purchaseManager.weeklyRecordingCount) free recordings left this week")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                tagEntry
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.orange.opacity(0.14), Color.pink.opacity(0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .navigationTitle("Recorder")
        }
    }

    private var statusText: String {
        switch vm.recorder.state {
        case .idle: return "Ready to record"
        case .recording: return "Recording…"
        case .paused: return "Paused"
        }
    }

    private var primaryButtonTitle: String {
        vm.recorder.state == .idle ? "Start" : "Save"
    }

    private var tagEntry: some View {
        GradientCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tags")
                    .font(.headline)

                HStack {
                    TextField("Add a tag", text: $tagInput)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        let trimmed = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            pendingTags.append(trimmed)
                            tagInput = ""
                        }
                    }
                }

                if !pendingTags.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(pendingTags, id: \.self) { tag in
                            TagChip(title: tag)
                        }
                    }
                }
            }
        }
    }

    private func timeString(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
    }
}
