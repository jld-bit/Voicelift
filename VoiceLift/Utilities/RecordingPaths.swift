import Foundation

enum RecordingPaths {
    static var appSupportDirectory: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = url.appendingPathComponent("VoiceLift", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static var recordingsDirectory: URL {
        let folder = appSupportDirectory.appendingPathComponent("Recordings", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static var metadataFile: URL {
        appSupportDirectory.appendingPathComponent("voice-notes.json")
    }
}
