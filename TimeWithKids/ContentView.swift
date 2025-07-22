//
//  ContentView.swift
//  TimeWithKids
//
//  Created by santamaru on 2025/07/18.
//

import SwiftUI

struct ContentView: View {
    @State private var children: [Child] = []
    @State private var name: String = ""
    @State private var birthday: Date = Date()
    @State private var targetAge: String = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var editingChild: Child? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showAddSheet = false
    @FocusState private var isAnyFieldFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                VStack(spacing: 16) {
                    titleSection
                    addButtonSection
                    childrenListSection
                }
                .padding(.top, 4)
            }
            .navigationTitle("")
            .onTapGesture {
                isAnyFieldFocused = false
            }
        }
        .onReceive(timer) { _ in
            updateChildren()
        }
        .sheet(item: $editingChild) { child in
            EditChildSheet(
                child: child,
                onSave: handleChildUpdate,
                onCancel: { editingChild = nil }
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddChildSheet(
                name: $name,
                birthday: $birthday,
                targetAge: $targetAge,
                onAdd: {
                    addChild()
                    showAddSheet = false
                },
                onCancel: {
                    showAddSheet = false
                }
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("入力エラー"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            loadChildren()
        }
    }
    
    // MARK: - UI Components
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 0.93, green: 0.89, blue: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var titleSection: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 54, height: 54)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                Image(systemName: "clock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.blue)
            }
            Text("子供との時間")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color.blue)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.leading, 8)
    }
    
    private var addButtonSection: some View {
        HStack {
            Spacer()
            Button(action: {
                showAddSheet = true
            }) {
                Label("追加", systemImage: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
            }
            Spacer()
        }
    }
    
    private var childrenListSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            List {
                ForEach(children) { child in
                    ChildRowView(child: child) {
                        editingChild = child
                    }
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteChild)
            }
            .background(Color.clear)
            .listStyle(PlainListStyle())
        }
        .padding([.horizontal, .bottom])
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Business Logic
    private func addChild() {
        guard let age = Int(targetAge), !name.isEmpty else { return }
        
        if !DateCalculator.isValidTargetAge(birthday: birthday, targetAge: age) {
            alertMessage = "目標年齢は現在の年齢以上にしてください。"
            showAlert = true
            return
        }
        
        let newChild = Child(name: name, birthday: birthday, targetAge: age)
        children.append(newChild)
        saveChildren()
        clearForm()
    }
    
    private func deleteChild(at offsets: IndexSet) {
        children.remove(atOffsets: offsets)
        saveChildren()
    }
    
    private func handleChildUpdate(_ updatedChild: Child) {
        if !DateCalculator.isValidTargetAge(birthday: updatedChild.birthday, targetAge: updatedChild.targetAge) {
            alertMessage = "目標年齢は現在の年齢以上にしてください。"
            showAlert = true
            return
        }
        
        if let idx = children.firstIndex(where: { $0.id == updatedChild.id }) {
            children[idx] = updatedChild
            saveChildren()
        }
        editingChild = nil
    }
    
    private func updateChildren() {
        self.children = self.children.map { $0 }
    }
    
    private func clearForm() {
        name = ""
        birthday = Date()
        targetAge = ""
    }
    
    // MARK: - Data Persistence
    private func saveChildren() {
        if let encoded = try? JSONEncoder().encode(children) {
            UserDefaults.standard.set(encoded, forKey: "SavedChildren")
        }
    }
    
    private func loadChildren() {
        if let data = UserDefaults.standard.data(forKey: "SavedChildren"),
           let decoded = try? JSONDecoder().decode([Child].self, from: data) {
            children = decoded
        }
    }
}

// 子供追加用のシート
struct AddChildSheet: View {
    @Binding var name: String
    @Binding var birthday: Date
    @Binding var targetAge: String
    var onAdd: () -> Void
    var onCancel: () -> Void
    @FocusState private var isNameFocused: Bool
    @FocusState private var isTargetAgeFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                AddChildForm(
                    name: $name,
                    birthday: $birthday,
                    targetAge: $targetAge,
                    onAdd: onAdd
                )
                Spacer()
            }
            .navigationBarTitle("子供を追加", displayMode: .inline)
            .navigationBarItems(
                leading: Button("キャンセル") {
                    isNameFocused = false
                    isTargetAgeFocused = false
                    onCancel()
                },
                trailing: Button("追加") {
                    isNameFocused = false
                    isTargetAgeFocused = false
                    onAdd()
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
