import Foundation

struct TranscriptionResult {
    let transcript: String
    let title: String
    let summary: String
}

final class TranscriptionService {
    struct Config {
        var endpoint: URL
        var apiKey: String
    }

    private let config: Config?

    init(config: Config? = nil) {
        self.config = config
    }

    func transcribeAudio(at url: URL) async throws -> TranscriptionResult {
        guard let config else {
            return TranscriptionResult(
                transcript: "Transcription unavailable in demo mode.",
                title: "New Voice Note",
                summary: "Add your transcription API key to unlock AI summaries."
            )
        }

        var request = URLRequest(url: config.endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")

        let data = try Data(contentsOf: url)
        request.httpBody = data

        let (responseData, _) = try await URLSession.shared.data(for: request)
        let text = String(decoding: responseData, as: UTF8.self)

        return summarize(text: text)
    }

    func summarize(text: String) -> TranscriptionResult {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = clean.split(separator: " ")
        let titleWords = words.prefix(6).joined(separator: " ")
        let summaryWords = words.prefix(20).joined(separator: " ")

        return TranscriptionResult(
            transcript: clean,
            title: titleWords.isEmpty ? "Voice Note" : String(titleWords),
            summary: summaryWords.isEmpty ? "No summary available." : String(summaryWords) + "..."
        )
    }
}
