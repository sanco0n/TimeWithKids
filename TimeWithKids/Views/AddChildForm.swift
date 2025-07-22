import SwiftUI

struct AddChildForm: View {
    @Binding var name: String
    @Binding var birthday: Date
    var onAdd: () -> Void
    
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("子供を追加")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            VStack(spacing: 16) {
                nameField
                birthdayField
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.85))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        .padding(.horizontal)
        .onTapGesture {
            isNameFocused = false
        }
    }
    
    // MARK: - Form Fields
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("名前")
                .font(.caption)
                .foregroundColor(.gray)
            TextField("例: たろう", text: $name)
                .focused($isNameFocused)
                .font(.system(size: 18))
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.18), lineWidth: 1))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
    }
    
    private var birthdayField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("誕生日")
                .font(.caption)
                .foregroundColor(.gray)
            DatePicker("", selection: $birthday, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.18), lineWidth: 1))
                .frame(maxWidth: .infinity, minHeight: 44)
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }
    }
    
    private var addButton: some View {
        Button(action: {
            // 追加ボタンを押した時にキーボードを閉じる
            isNameFocused = false
            onAdd()
        }) {
            Text("追加")
                .font(.headline)
                .foregroundColor(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(isFormValid ? Color.blue.opacity(0.12) : Color.gray.opacity(0.08))
                .cornerRadius(10)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !name.isEmpty
    }
} 