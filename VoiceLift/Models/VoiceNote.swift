import Foundation

struct VoiceNote: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var summary: String
    var transcript: String
    var tags: [String]
    var duration: TimeInterval
    var createdAt: Date
    var fileName: String

    var fileURL: URL {
        RecordingPaths.recordingsDirectory.appendingPathComponent(fileName)
    }

    init(
        id: UUID = UUID(),
        title: String,
        summary: String = "",
        transcript: String = "",
        tags: [String] = [],
        duration: TimeInterval,
        createdAt: Date = .now,
        fileName: String
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.transcript = transcript
        self.tags = tags
        self.duration = duration
        self.createdAt = createdAt
        self.fileName = fileName
    }
}
