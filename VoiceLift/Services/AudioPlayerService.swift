import AVFoundation
import Foundation

@MainActor
final class AudioPlayerService: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published private(set) var isPlaying = false
    @Published private(set) var progress: Double = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    func play(url: URL) throws {
        player = try AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.play()
        isPlaying = true
        startTimer()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        progress = 0
        isPlaying = false
        timer?.invalidate()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let player else { return }
            if player.duration > 0 {
                self.progress = player.currentTime / player.duration
            }
        }
    }
}
