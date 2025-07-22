import SwiftUI

struct ChildDetailView: View {
    @Binding var child: Child
    @State private var showAddMilestone = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("\(child.name) のイベント一覧")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 24)
                List {
                    ForEach(child.milestones) { milestone in
                        MilestoneRowView(child: child, milestone: milestone)
                    }
                    .onDelete(perform: deleteMilestone)
                }
                .listStyle(PlainListStyle())
                Button(action: { showAddMilestone = true }) {
                    Label("イベントを追加", systemImage: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitle("子供の詳細", displayMode: .inline)
            .sheet(isPresented: $showAddMilestone) {
                AddMilestoneSheet(child: $child, onDismiss: { showAddMilestone = false })
            }
        }
    }
    
    private func deleteMilestone(at offsets: IndexSet) {
        child.milestones.remove(atOffsets: offsets)
    }
}

// イベント（マイルストン）1件の表示
struct MilestoneRowView: View {
    let child: Child
    let milestone: Milestone
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(milestone.title)
                .font(.headline)
            Text("目標日: " + formattedTargetDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("残り: " + timeLeftString)
                .font(.subheadline)
                .foregroundColor(.blue)
            HStack(spacing: 16) {
                Label("残り週末: \(weekendsLeft) 回", systemImage: "calendar")
                    .foregroundColor(.orange)
                    .font(.caption)
                Label("残り祝日: \(holidaysLeft) 日", systemImage: "flag")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(8)
    }
    private var targetDate: Date? {
        if milestone.type == .date {
            return milestone.targetDate
        } else if milestone.type == .age, let age = milestone.targetAge {
            return Calendar.current.date(byAdding: .year, value: age, to: child.birthday)
        }
        return nil
    }
    private var formattedTargetDate: String {
        guard let date = targetDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    private var timeLeftString: String {
        guard let date = targetDate else { return "-" }
        let seconds = Int(date.timeIntervalSince(Date()))
        return DateCalculator.formatTimeLeft(seconds)
    }
    private var weekendsLeft: Int {
        guard let date = targetDate else { return 0 }
        return DateCalculator.calculateWeekendsLeft(birthday: Date(), targetAge: Calendar.current.dateComponents([.year], from: Date(), to: date).year ?? 0)
    }
    private var holidaysLeft: Int {
        guard let date = targetDate else { return 0 }
        return DateCalculator.calculateHolidaysLeft(birthday: Date(), targetAge: Calendar.current.dateComponents([.year], from: Date(), to: date).year ?? 0)
    }
} 