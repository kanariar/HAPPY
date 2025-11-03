import Foundation

// MARK: - Data Model
struct HappyEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let text: String
    let level: Int
    let isWithdrawal: Bool
    let amount: Int?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        text: String,
        level: Int,
        isWithdrawal: Bool = false,
        amount: Int? = nil
    ) {
        self.id = id
        self.date = date
        self.text = text
        self.level = level
        self.isWithdrawal = isWithdrawal
        self.amount = amount
    }
    
    /// エントリーの値を取得（出金の場合は負の値）
    var value: Int {
        if isWithdrawal {
            return -(amount ?? 0)
        } else {
            return LevelConfig.displayValue(for: level)
        }
    }
}
