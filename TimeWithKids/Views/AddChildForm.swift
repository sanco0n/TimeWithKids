import SwiftUI

struct AddChildForm: View {
    @Binding var name: String
    @Binding var birthday: Date
    @Binding var targetAge: String
    var onAdd: () -> Void
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isTargetAgeFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("子供を追加")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            HStack(spacing: 10) {
                nameField
                birthdayField
                targetAgeField
                addButton
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.85))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        .padding(.horizontal)
        .onTapGesture {
            // フォーム外をタップした時にキーボードを閉じる
            isNameFocused = false
            isTargetAgeFocused = false
        }
    }
    
    // MARK: - Form Fields
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("名前")
                .font(.caption2)
                .foregroundColor(.gray)
            TextField("例: たろう", text: $name)
                .focused($isNameFocused)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15), lineWidth: 1))
                .frame(width: 90)
        }
    }
    
    private var birthdayField: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("誕生日")
                .font(.caption2)
                .foregroundColor(.gray)
            DatePicker("", selection: $birthday, displayedComponents: .date)
                .labelsHidden()
                .frame(maxWidth: 120)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15), lineWidth: 1))
        }
    }
    
    private var targetAgeField: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("目標年齢")
                .font(.caption2)
                .foregroundColor(.gray)
            TextField("例: 10", text: $targetAge)
                .focused($isTargetAgeFocused)
                .keyboardType(.numberPad)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15), lineWidth: 1))
                .frame(width: 60)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            // 追加ボタンを押した時にキーボードを閉じる
            isNameFocused = false
            isTargetAgeFocused = false
            onAdd()
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !name.isEmpty && !targetAge.isEmpty
    }
} 