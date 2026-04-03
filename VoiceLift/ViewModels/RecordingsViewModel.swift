import Foundation

@MainActor
final class RecordingsViewModel: ObservableObject {
    @Published private(set) var notes: [VoiceNote] = []
    @Published var selectedTag: String?
    @Published var lastErrorMessage: String?

    let recorder = AudioRecorderService()
    let player = AudioPlayerService()

    private let storage = StorageService()
    private let transcriptionService = TranscriptionService()

    init() {
        notes = storage.seedSampleRecordingsIfNeeded()
    }

    var availableTags: [String] {
        Array(Set(notes.flatMap(\.tags))).sorted()
    }

    var filteredNotes: [VoiceNote] {
        guard let selectedTag else { return notes }
        return notes.filter { $0.tags.contains(selectedTag) }
    }

    func beginRecording() async {
        do {
            let granted = await recorder.requestPermission()
            guard granted else {
                lastErrorMessage = "Microphone permission is required to record."
                return
            }
            try recorder.startRecording()
        } catch {
            lastErrorMessage = "Unable to start recording: \(error.localizedDescription)"
        }
    }

    func togglePauseResume() {
        switch recorder.state {
        case .recording:
            recorder.pauseRecording()
        case .paused:
            recorder.resumeRecording()
        case .idle:
            break
        }
    }

    func finishRecording(tags: [String]) async {
        guard let result = recorder.stopRecording() else { return }

        do {
            let transcription = try await transcriptionService.transcribeAudio(at: result.url)
            let note = VoiceNote(
                title: transcription.title,
                summary: transcription.summary,
                transcript: transcription.transcript,
                tags: tags,
                duration: result.duration,
                fileName: result.url.lastPathComponent
            )
            notes.insert(note, at: 0)
            try storage.saveNotes(notes)
        } catch {
            lastErrorMessage = "Saved audio, but transcription failed."
        }
    }

    func deleteNote(_ note: VoiceNote) {
        do {
            try storage.deleteNote(note)
            notes.removeAll { $0.id == note.id }
            try storage.saveNotes(notes)
        } catch {
            lastErrorMessage = "Could not delete note."
        }
    }

    func addTag(_ tag: String, to note: VoiceNote) {
        guard let idx = notes.firstIndex(where: { $0.id == note.id }) else { return }
        if !notes[idx].tags.contains(tag) {
            notes[idx].tags.append(tag)
            try? storage.saveNotes(notes)
        }
    }
}
