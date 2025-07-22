import Foundation

struct DateCalculator {
    
    // MARK: - Age Calculation
    static func calculateAge(from birthday: Date) -> Double {
        let now = Date()
        return now.timeIntervalSince(birthday) / (60*60*24*365.2425)
    }
    
    // MARK: - Time Left Calculation
    static func calculateSecondsLeft(birthday: Date, targetAge: Int) -> Int {
        let targetDate = Calendar.current.date(byAdding: .year, value: targetAge, to: birthday) ?? Date()
        let left = Int(targetDate.timeIntervalSince(Date()))
        return max(left, 0)
    }
    
    static func formatTimeLeft(_ seconds: Int) -> String {
        var remainingSeconds = seconds
        let years = remainingSeconds / (60*60*24*365)
        remainingSeconds %= (60*60*24*365)
        let months = remainingSeconds / (60*60*24*30)
        remainingSeconds %= (60*60*24*30)
        let days = remainingSeconds / (60*60*24)
        remainingSeconds %= (60*60*24)
        let hours = remainingSeconds / (60*60)
        remainingSeconds %= (60*60)
        let minutes = remainingSeconds / 60
        remainingSeconds %= 60
        return "\(years)年\(months)ヶ月\(days)日\(hours)時間\(minutes)分\(remainingSeconds)秒"
    }
    
    // MARK: - Weekend Calculation
    static func calculateWeekendsLeft(birthday: Date, targetAge: Int) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let targetDate = Calendar.current.date(byAdding: .year, value: targetAge, to: birthday) ?? now
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
    
    // MARK: - Holiday Calculation
    static func calculateHolidaysLeft(birthday: Date, targetAge: Int) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let targetDate = Calendar.current.date(byAdding: .year, value: targetAge, to: birthday) ?? now
        let holidays = JapaneseHolidayCalculator.allHolidays(from: now, to: targetDate)
        return holidays.count
    }
    
    // MARK: - Validation
    static func isValidTargetAge(birthday: Date, targetAge: Int) -> Bool {
        let currentAge = calculateAge(from: birthday)
        return Double(targetAge) >= currentAge
    }
} 