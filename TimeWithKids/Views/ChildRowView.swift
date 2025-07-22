import SwiftUI

struct ChildRowView: View {
    let child: Child
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            headerSection
            ageSection
            timeLeftSection
            additionalInfoSection
        }
        .padding(10)
        .background(Color.white.opacity(0.9))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        .padding(.vertical, 4)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            iconView
            Text("\(child.name)")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            Spacer()
            editButton
        }
        .padding(.bottom, 2)
    }
    
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 36, height: 36)
            Image(systemName: "clock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.blue)
        }
    }
    
    private var editButton: some View {
        Group {
            if let onEdit = onEdit {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    // MARK: - Age Section
    private var ageSection: some View {
        Text("年齢: \(currentAge, specifier: "%.2f") 歳")
            .font(.subheadline)
            .foregroundColor(.gray)
    }
    
    // MARK: - Time Left Section
    private var timeLeftSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("目標年齢(\(child.targetAge)歳)まで残り:")
                .foregroundColor(.blue)
                .font(.subheadline)
            Text(timeLeftString)
                .foregroundColor(.blue)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    // MARK: - Additional Info Section
    private var additionalInfoSection: some View {
        HStack(spacing: 16) {
            Label("残り週末: \(weekendsLeft) 回", systemImage: "calendar")
                .foregroundColor(.orange)
                .font(.caption)
            Label("残り祝日: \(holidaysLeft) 日", systemImage: "flag")
                .foregroundColor(.red)
                .font(.caption)
        }
    }
    
    // MARK: - Computed Properties
    private var currentAge: Double {
        DateCalculator.calculateAge(from: child.birthday)
    }
    
    private var timeLeftString: String {
        let seconds = DateCalculator.calculateSecondsLeft(birthday: child.birthday, targetAge: child.targetAge)
        return DateCalculator.formatTimeLeft(seconds)
    }
    
    private var weekendsLeft: Int {
        DateCalculator.calculateWeekendsLeft(birthday: child.birthday, targetAge: child.targetAge)
    }
    
    private var holidaysLeft: Int {
        DateCalculator.calculateHolidaysLeft(birthday: child.birthday, targetAge: child.targetAge)
    }
} 