import SwiftUI

struct RecordingsListView: View {
    @EnvironmentObject private var vm: RecordingsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.purple.opacity(0.15), Color.blue.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    if !vm.availableTags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                TagChip(title: "All", isSelected: vm.selectedTag == nil)
                                    .onTapGesture { vm.selectedTag = nil }
                                ForEach(vm.availableTags, id: \.self) { tag in
                                    TagChip(title: tag, isSelected: vm.selectedTag == tag)
                                        .onTapGesture { vm.selectedTag = tag }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    LazyVStack(spacing: 12) {
                        ForEach(vm.filteredNotes) { note in
                            NavigationLink {
                                VoiceNoteDetailView(note: note)
                            } label: {
                                GradientCard {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(note.title)
                                            .font(.headline)
                                        Text(note.summary)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                        HStack {
                                            Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                                            Spacer()
                                            Text(note.duration.formatted(.number.precision(.fractionLength(0))) + "s")
                                        }
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    vm.deleteNote(note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("VoiceLift")
        }
    }
}
