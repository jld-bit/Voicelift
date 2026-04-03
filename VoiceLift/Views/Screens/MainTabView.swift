import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RecordingsListView()
                .tabItem {
                    Label("Library", systemImage: "waveform")
                }

            RecorderView()
                .tabItem {
                    Label("Record", systemImage: "mic.fill")
                }

            UpgradeView()
                .tabItem {
                    Label("Premium", systemImage: "sparkles")
                }
        }
    }
}
