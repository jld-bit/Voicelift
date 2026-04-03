import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var tier: SubscriptionTier = .free
    @Published private(set) var weeklyRecordingCount: Int = 0

    let weeklyFreeLimit = 5
    private let premiumProductID = "com.voicelift.premium.monthly"

    var canRecord: Bool {
        tier == .premium || weeklyRecordingCount < weeklyFreeLimit
    }

    var canUseTranscription: Bool {
        tier == .premium
    }

    func incrementWeeklyRecordingCount() {
        weeklyRecordingCount += 1
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == premiumProductID {
                tier = .premium
                return
            }
        }
        tier = .free
    }

    func purchasePremium() async throws {
        let products = try await Product.products(for: [premiumProductID])
        guard let product = products.first else { return }

        let result = try await product.purchase()
        if case .success(let verification) = result,
           case .verified = verification {
            tier = .premium
        }
    }
}
