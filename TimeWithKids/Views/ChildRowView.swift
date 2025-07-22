import SwiftUI

struct ChildRowView: View {
    let child: Child
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            headerSection
            eventSection
        }
        .padding(10)
        .background(Color.white.opacity(0.9))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        .padding(.vertical, 4)
        .onLongPressGesture {
            onEdit?()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            iconView
            Text("\(child.name)")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            Spacer()
        }
        .padding(.bottom, 2)
    }
    
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 36, height: 36)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.blue)
        }
    }
    
    // MARK: - Event Section
    private var eventSection: some View {
        let now = Date()
        let futureEvents: [(title: String, weekendsLeft: Int, holidaysLeft: Int)] = child.milestones.compactMap { milestone in
            let date: Date? = {
                if milestone.type == .date {
                    return milestone.targetDate
                } else if milestone.type == .age, let age = milestone.targetAge {
                    return Calendar.current.date(byAdding: .year, value: age, to: child.birthday)
                }
                return nil
            }()
            guard let d = date, d > now else { return nil }
            let weekends = DateCalculator.calculateWeekendsLeft(birthday: now, targetAge: Calendar.current.dateComponents([.year], from: now, to: d).year ?? 0)
            let holidays = DateCalculator.calculateHolidaysLeft(birthday: now, targetAge: Calendar.current.dateComponents([.year], from: now, to: d).year ?? 0)
            return (milestone.title, weekends, holidays)
        }
        if futureEvents.isEmpty {
            return AnyView(
                VStack(alignment: .leading, spacing: 2) {
                    Text("イベント未登録")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {}
                }
                .allowsHitTesting(false)
            )
        } else {
            return AnyView(
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(futureEvents.enumerated()), id: \.offset) { idx, event in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("イベント: \(event.title)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack(spacing: 16) {
                                Label("残り週末: \(event.weekendsLeft) 回", systemImage: "calendar")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                Label("残り祝日: \(event.holidaysLeft) 日", systemImage: "flag")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(10)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
                        .padding(.bottom, 2)
                    }
                }
                .allowsHitTesting(false)
            )
        }
    }
    
    // MARK: - Nearest Event Calculation
    private var nearestEvent: (title: String, weekendsLeft: Int, holidaysLeft: Int)? {
        let now = Date()
        let futureMilestones = child.milestones.compactMap { milestone -> (String, Date)? in
            let date: Date? = {
                if milestone.type == .date {
                    return milestone.targetDate
                } else if milestone.type == .age, let age = milestone.targetAge {
                    return Calendar.current.date(byAdding: .year, value: age, to: child.birthday)
                }
                return nil
            }()
            guard let d = date, d > now else { return nil }
            return (milestone.title, d)
        }
        guard let nearest = futureMilestones.sorted(by: { $0.1 < $1.1 }).first else { return nil }
        let weekends = DateCalculator.calculateWeekendsLeft(birthday: now, targetAge: Calendar.current.dateComponents([.year], from: now, to: nearest.1).year ?? 0)
        let holidays = DateCalculator.calculateHolidaysLeft(birthday: now, targetAge: Calendar.current.dateComponents([.year], from: now, to: nearest.1).year ?? 0)
        return (nearest.0, weekends, holidays)
    }
} 