import AVFoundation
import Foundation

@MainActor
final class AudioRecorderService: NSObject, ObservableObject {
    enum RecorderState {
        case idle
        case recording
        case paused
    }

    @Published private(set) var state: RecorderState = .idle
    @Published private(set) var elapsedTime: TimeInterval = 0

    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    private var currentFileURL: URL?

    func requestPermission() async -> Bool {
        await AVAudioSession.sharedInstance().requestRecordPermission()
    }

    func startRecording() throws {
        try configureAudioSession()
        let fileURL = RecordingPaths.recordingsDirectory
            .appendingPathComponent("voice-note-\(UUID().uuidString).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try AVAudioRecorder(url: fileURL, settings: settings)
        recorder?.record()
        currentFileURL = fileURL
        elapsedTime = 0
        state = .recording
        startTimer()
    }

    func pauseRecording() {
        recorder?.pause()
        state = .paused
        timer?.invalidate()
    }

    func resumeRecording() {
        recorder?.record()
        state = .recording
        startTimer()
    }

    func stopRecording() -> (url: URL, duration: TimeInterval)? {
        recorder?.stop()
        timer?.invalidate()

        guard let recorder, let url = currentFileURL else {
            state = .idle
            return nil
        }

        state = .idle
        return (url, recorder.currentTime)
    }

    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try session.setActive(true)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self, let recorder else { return }
            self.elapsedTime = recorder.currentTime
        }
    }
}
