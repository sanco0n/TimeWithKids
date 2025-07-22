import SwiftUI

struct AddMilestoneSheet: View {
    @Binding var child: Child
    var onDismiss: () -> Void
    
    @State private var title: String = ""
    @State private var type: MilestoneType = .age
    @State private var targetAge: String = ""
    @State private var targetDate: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("イベント情報")) {
                    TextField("イベント名（例: 成人まで）", text: $title)
                    Picker("タイプ", selection: $type) {
                        Text("年齢で指定").tag(MilestoneType.age)
                        Text("日付で指定").tag(MilestoneType.date)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if type == .age {
                        TextField("目標年齢", text: $targetAge)
                            .keyboardType(.numberPad)
                    } else {
                        DatePicker("目標日付", selection: $targetDate, displayedComponents: .date)
                    }
                }
            }
            .navigationBarTitle("イベント追加", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル", action: onDismiss),
                trailing: Button("追加") {
                    addMilestone()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("入力エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addMilestone() {
        guard !title.isEmpty else {
            alertMessage = "イベント名を入力してください。"
            showAlert = true
            return
        }
        if type == .age {
            guard let age = Int(targetAge), age > 0 else {
                alertMessage = "目標年齢を正しく入力してください。"
                showAlert = true
                return
            }
            let milestone = Milestone(title: title, type: .age, targetDate: nil, targetAge: age)
            child.milestones.append(milestone)
        } else {
            let milestone = Milestone(title: title, type: .date, targetDate: targetDate, targetAge: nil)
            child.milestones.append(milestone)
        }
        onDismiss()
    }
} 