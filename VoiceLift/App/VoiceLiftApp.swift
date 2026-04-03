import SwiftUI

@main
struct VoiceLiftApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var recordingsViewModel = RecordingsViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(purchaseManager)
                .environmentObject(recordingsViewModel)
        }
    }
}
