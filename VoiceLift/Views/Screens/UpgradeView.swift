import SwiftUI

struct UpgradeView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                GradientCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Free")
                            .font(.headline)
                        Label("Up to 5 recordings/week", systemImage: "mic")
                        Label("Local playback and tags", systemImage: "folder")
                    }
                }

                GradientCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Premium")
                            .font(.headline)
                        Label("Unlimited recordings", systemImage: "infinity")
                        Label("Transcription + summaries", systemImage: "text.bubble")
                        Label("Export and sync ready", systemImage: "square.and.arrow.up")
                    }
                }

                Button("Upgrade to Premium") {
                    Task { try? await purchaseManager.purchasePremium() }
                }
                .buttonStyle(.borderedProminent)

                Text("Current plan: \(purchaseManager.tier.rawValue.capitalized)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.cyan.opacity(0.13), Color.purple.opacity(0.13)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .navigationTitle("Premium")
            .task {
                await purchaseManager.refreshEntitlements()
            }
        }
    }
}
