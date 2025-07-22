import SwiftUI

struct EditChildSheet: View {
    @State var child: Child
    var onSave: (Child) -> Void
    var onCancel: () -> Void
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isTargetAgeFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("子供情報を編集")) {
                    TextField("名前", text: $child.name)
                        .focused($isNameFocused)
                    DatePicker("誕生日", selection: $child.birthday, displayedComponents: .date)
                    TextField("目標年齢", value: $child.targetAge, formatter: NumberFormatter())
                        .focused($isTargetAgeFocused)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("編集", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル") {
                    // キャンセル時にキーボードを閉じる
                    isNameFocused = false
                    isTargetAgeFocused = false
                    onCancel()
                },
                trailing: Button("保存") {
                    // 保存時にキーボードを閉じる
                    isNameFocused = false
                    isTargetAgeFocused = false
                    validateAndSave()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("入力エラー"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onTapGesture {
                // フォーム外をタップした時にキーボードを閉じる
                isNameFocused = false
                isTargetAgeFocused = false
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateAndSave() {
        if !DateCalculator.isValidTargetAge(birthday: child.birthday, targetAge: child.targetAge) {
            alertMessage = "目標年齢は現在の年齢以上にしてください。"
            showAlert = true
            return
        }
        onSave(child)
    }
} 