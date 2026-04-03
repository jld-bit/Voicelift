import SwiftUI

struct TagChip: View {
    let title: String
    var isSelected = false

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.15))
            .clipShape(Capsule())
    }
}
