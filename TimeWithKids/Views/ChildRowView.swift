import SwiftUI

struct ChildRowView: View {
    let child: Child
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            headerSection
            ageSection
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
            editButton
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
    
    private var editButton: some View {
        Group {
            if let onEdit = onEdit {
                Button(action: {
                    onEdit()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    // MARK: - Age Section
    private var ageSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("誕生日: \(formattedBirthday)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("年齢: \(currentAge, specifier: "%.2f") 歳")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var formattedBirthday: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: child.birthday)
    }
    
    private var currentAge: Double {
        DateCalculator.calculateAge(from: child.birthday)
    }
} 