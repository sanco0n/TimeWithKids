import SwiftUI

struct EditChildSheet: View {
    @State var child: Child
    var onSave: (Child) -> Void
    var onCancel: () -> Void
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("名前", text: $child.name)
                        .focused($isNameFocused)
                    DatePicker("誕生日", selection: $child.birthday, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                } header: {
                    Text("子供情報を編集")
                }
            }
            .navigationBarTitle("編集", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル") {
                    isNameFocused = false
                    onCancel()
                },
                trailing: Button("保存") {
                    isNameFocused = false
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
                isNameFocused = false
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateAndSave() {
        if child.name.isEmpty {
            alertMessage = "名前を入力してください。"
            showAlert = true
            return
        }
        onSave(child)
    }
} 