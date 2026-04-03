import Foundation

@MainActor
final class StorageService {
    func saveNotes(_ notes: [VoiceNote]) throws {
        let data = try JSONEncoder().encode(notes)
        try data.write(to: RecordingPaths.metadataFile, options: [.atomic])
    }

    func loadNotes() -> [VoiceNote] {
        guard
            FileManager.default.fileExists(atPath: RecordingPaths.metadataFile.path),
            let data = try? Data(contentsOf: RecordingPaths.metadataFile),
            let notes = try? JSONDecoder().decode([VoiceNote].self, from: data)
        else {
            return []
        }

        return notes.sorted { $0.createdAt > $1.createdAt }
    }

    func deleteNote(_ note: VoiceNote) throws {
        if FileManager.default.fileExists(atPath: note.fileURL.path) {
            try FileManager.default.removeItem(at: note.fileURL)
        }
    }

    func seedSampleRecordingsIfNeeded() -> [VoiceNote] {
        let existing = loadNotes()
        guard existing.isEmpty else { return existing }

        let sampleA = VoiceNote(
            title: "Team Standup",
            summary: "Highlights: prioritize checkout bug fix and customer follow-up.",
            transcript: "Quick update from engineering standup...",
            tags: ["Work", "Daily"],
            duration: 82,
            fileName: "sample-standup.m4a"
        )

        let sampleB = VoiceNote(
            title: "Idea Spark",
            summary: "Concept for habit tracker with voice reflections.",
            transcript: "A concept for a voice-first habit tracker...",
            tags: ["Ideas"],
            duration: 55,
            fileName: "sample-idea.m4a"
        )

        let samples = [sampleA, sampleB]
        try? saveNotes(samples)
        return samples
    }
}
