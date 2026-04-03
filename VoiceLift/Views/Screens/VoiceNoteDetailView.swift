import SwiftUI

struct VoiceNoteDetailView: View {
    @EnvironmentObject private var vm: RecordingsViewModel
    let note: VoiceNote

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                GradientCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(note.title)
                            .font(.title2.bold())
                        Text(note.summary)
                        WaveformView(progress: vm.player.progress)

                        HStack {
                            Button(vm.player.isPlaying ? "Pause" : "Play") {
                                if vm.player.isPlaying {
                                    vm.player.pause()
                                } else {
                                    try? vm.player.play(url: note.fileURL)
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Stop") {
                                vm.player.stop()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                GradientCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transcript")
                            .font(.headline)
                        Text(note.transcript)
                            .font(.body)
                    }
                }

                if !note.tags.isEmpty {
                    GradientCard {
                        HStack {
                            ForEach(note.tags, id: \.self) { tag in
                                TagChip(title: tag)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.14), Color.mint.opacity(0.14)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}
