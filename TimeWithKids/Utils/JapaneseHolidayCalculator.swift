import Foundation

struct JapaneseHolidayCalculator {
    
    // MARK: - All Holidays
    static func allHolidays(from start: Date, to end: Date) -> [Date] {
        var holidays: [Date] = []
        let calendar = Calendar(identifier: .gregorian)
        let startYear = calendar.component(.year, from: start)
        let endYear = calendar.component(.year, from: end)
        
        for year in startYear...endYear {
            holidays.append(contentsOf: holidaysForYear(year))
        }
        
        return holidays.filter { $0 >= start && $0 <= end }
    }
    
    // MARK: - Holidays for Specific Year
    private static func holidaysForYear(_ year: Int) -> [Date] {
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
    
    // MARK: - Nth Weekday of Month
    private static func nthWeekdayOfMonth(year: Int, month: Int, weekday: Int, n: Int) -> Date? {
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