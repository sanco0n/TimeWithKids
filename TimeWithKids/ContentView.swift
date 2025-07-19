//
//  ContentView.swift
//  TimeWithKids
//
//  Created by santamaru on 2025/07/18.
//

import SwiftUI

struct Child: Identifiable, Codable {
    let id = UUID()
    var name: String
    var birthday: Date
    var targetAge: Int
}

struct ContentView: View {
    @State private var children: [Child] = []
    @State private var name: String = ""
    @State private var birthday: Date = Date()
    @State private var targetAge: String = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var editingChild: Child? = nil
    @State private var showEditSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                // 柔らかいグラデーション背景（万人受けのブルー＆ラベンダー系）
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.85, green: 0.93, blue: 1.0), Color(red: 0.93, green: 0.89, blue: 1.0)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    // タイトル部
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
                    // 登録フォーム
                    VStack(alignment: .leading, spacing: 6) {
                        Text("子供を追加")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("名前")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("例: たろう", text: $name)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15), lineWidth: 1))
                                    .frame(width: 90)
                            }
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
                            VStack(alignment: .leading, spacing: 2) {
                                Text("目標年齢")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                TextField("例: 10", text: $targetAge)
                                    .keyboardType(.numberPad)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15), lineWidth: 1))
                                    .frame(width: 60)
                            }
                            Button(action: { addChild() }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor((name.isEmpty || targetAge.isEmpty) ? Color.gray.opacity(0.4) : Color.blue)
                                    .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                            .disabled(name.isEmpty || targetAge.isEmpty)
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    // 結果表示欄
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.white.opacity(0.7))
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        List {
                            ForEach(children) { child in
                                ChildRow(child: child, onEdit: {
                                    editingChild = child
                                    showEditSheet = true
                                })
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
                .padding(.top, 4)
            }
            .navigationTitle("")
        }
        .onReceive(timer) { _ in
            self.children = self.children.map { $0 }
        }
        .sheet(item: $editingChild) { child in
            EditChildSheet(child: child, onSave: { updatedChild in
                if !isValidTargetAge(birthday: updatedChild.birthday, targetAge: updatedChild.targetAge) {
                    alertMessage = "目標年齢は現在の年齢以上にしてください。"
                    showAlert = true
                    return
                }
                if let idx = children.firstIndex(where: { $0.id == updatedChild.id }) {
                    children[idx] = updatedChild
                }
                editingChild = nil
            }, onCancel: {
                editingChild = nil
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("入力エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func addChild() {
        guard let age = Int(targetAge), !name.isEmpty else { return }
        if !isValidTargetAge(birthday: birthday, targetAge: age) {
            alertMessage = "目標年齢は現在の年齢以上にしてください。"
            showAlert = true
            return
        }
        let newChild = Child(name: name, birthday: birthday, targetAge: age)
        children.append(newChild)
        name = ""
        birthday = Date()
        targetAge = ""
    }

    func deleteChild(at offsets: IndexSet) {
        children.remove(atOffsets: offsets)
    }

    func isValidTargetAge(birthday: Date, targetAge: Int) -> Bool {
        let now = Date()
        let age = now.timeIntervalSince(birthday) / (60*60*24*365.2425)
        return Double(targetAge) >= age
    }
}

struct ChildRow: View {
    let child: Child
    var onEdit: (() -> Void)? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
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
                Text("\(child.name)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Spacer()
                if let onEdit = onEdit {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.bottom, 2)
            Text("年齢: \(currentAge, specifier: "%.2f") 歳")
                .font(.subheadline)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 2) {
                Text("目標年齢(\(child.targetAge)歳)まで残り:")
                    .foregroundColor(.blue)
                    .font(.subheadline)
                Text(timeLeftString)
                    .foregroundColor(.blue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
                .foregroundColor(.blue)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            HStack(spacing: 16) {
                Label("残り週末: \(weekendsLeft) 回", systemImage: "calendar")
                    .foregroundColor(.orange)
                    .font(.caption)
                Label("残り祝日: \(holidaysLeft) 日", systemImage: "flag")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.9))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        .padding(.vertical, 4)
    }
    var currentAge: Double {
        let now = Date()
        let age = now.timeIntervalSince(child.birthday) / (60*60*24*365.2425)
        return age
    }
    var secondsLeft: Int {
        let targetDate = Calendar.current.date(byAdding: .year, value: child.targetAge, to: child.birthday) ?? Date()
        let left = Int(targetDate.timeIntervalSince(Date()))
        return max(left, 0)
    }
    var timeLeftString: String {
        var seconds = secondsLeft
        let years = seconds / (60*60*24*365)
        seconds %= (60*60*24*365)
        let months = seconds / (60*60*24*30)
        seconds %= (60*60*24*30)
        let days = seconds / (60*60*24)
        seconds %= (60*60*24)
        let hours = seconds / (60*60)
        seconds %= (60*60)
        let minutes = seconds / 60
        seconds %= 60
        return "\(years)年\(months)ヶ月\(days)日\(hours)時間\(minutes)分\(seconds)秒"
    }
    var weekendsLeft: Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let targetDate = Calendar.current.date(byAdding: .year, value: child.targetAge, to: child.birthday) ?? now
        var count = 0
        var date = calendar.startOfDay(for: now)
        while date <= targetDate {
            let weekday = calendar.component(.weekday, from: date)
            if weekday == 7 || weekday == 1 { // 土曜(7)・日曜(1)
                count += 1
            }
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        return count / 2 // 1週末=土日セット
    }
    var holidaysLeft: Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let targetDate = Calendar.current.date(byAdding: .year, value: child.targetAge, to: child.birthday) ?? now
        let holidays = allJapaneseHolidays(from: now, to: targetDate)
        return holidays.count
    }
    // 複数年対応の日本の祝日リスト
    func allJapaneseHolidays(from start: Date, to end: Date) -> [Date] {
        var holidays: [Date] = []
        let calendar = Calendar(identifier: .gregorian)
        let startYear = calendar.component(.year, from: start)
        let endYear = calendar.component(.year, from: end)
        for year in startYear...endYear {
            holidays.append(contentsOf: japaneseHolidays(for: year))
        }
        return holidays.filter { $0 >= start && $0 <= end }
    }
    // 年ごとの日本の祝日（主要な祝日＋可変祝日を含む例示）
    func japaneseHolidays(for year: Int) -> [Date] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let base = "\(year)-"
        var holidays: [Date] = [
            formatter.date(from: base + "01-01"), // 元日
            formatter.date(from: base + "02-11"), // 建国記念の日
            formatter.date(from: base + "02-23"), // 天皇誕生日
            formatter.date(from: base + "03-20"), // 春分の日（例示）
            formatter.date(from: base + "04-29"), // 昭和の日
            formatter.date(from: base + "05-03"), // 憲法記念日
            formatter.date(from: base + "05-04"), // みどりの日
            formatter.date(from: base + "05-05"), // こどもの日
            formatter.date(from: base + "09-23"), // 秋分の日（例示）
            formatter.date(from: base + "11-03"), // 文化の日
            formatter.date(from: base + "11-23"), // 勤労感謝の日
        ].compactMap { $0 }
        // 可変祝日を追加
        if let seijin = nthWeekdayOfMonth(year: year, month: 1, weekday: 2, n: 2) { // 成人の日: 1月第2月曜
            holidays.append(seijin)
        }
        if let umi = nthWeekdayOfMonth(year: year, month: 7, weekday: 2, n: 3) { // 海の日: 7月第3月曜
            holidays.append(umi)
        }
        if let keirou = nthWeekdayOfMonth(year: year, month: 9, weekday: 2, n: 3) { // 敬老の日: 9月第3月曜
            holidays.append(keirou)
        }
        if let sports = nthWeekdayOfMonth(year: year, month: 10, weekday: 2, n: 2) { // スポーツの日: 10月第2月曜
            holidays.append(sports)
        }
        return holidays
    }
    // 指定年・月の第n週weekday（weekday:1=日曜,2=月曜...）の日付を返す
    func nthWeekdayOfMonth(year: Int, month: Int, weekday: Int, n: Int) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        var components = DateComponents()
        components.year = year
        components.month = month
        components.weekday = weekday
        components.weekdayOrdinal = n
        return calendar.date(from: components)
    }
}

// 編集用シート
struct EditChildSheet: View {
    @State var child: Child
    var onSave: (Child) -> Void
    var onCancel: () -> Void
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("子供情報を編集")) {
                    TextField("名前", text: $child.name)
                    DatePicker("誕生日", selection: $child.birthday, displayedComponents: .date)
                    TextField("目標年齢", value: $child.targetAge, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("編集", displayMode: .inline)
            .navigationBarItems(leading: Button("キャンセル", action: onCancel), trailing: Button("保存") {
                if !isValidTargetAge(birthday: child.birthday, targetAge: child.targetAge) {
                    alertMessage = "目標年齢は現在の年齢以上にしてください。"
                    showAlert = true
                    return
                }
                onSave(child)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("入力エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    func isValidTargetAge(birthday: Date, targetAge: Int) -> Bool {
        let now = Date()
        let age = now.timeIntervalSince(birthday) / (60*60*24*365.2425)
        return Double(targetAge) >= age
    }
}

#Preview {
    ContentView()
}
