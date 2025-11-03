import SwiftUI
import SpriteKit

// MARK: - Color Extensions
extension Color {
    // パステルカラー定義
    static let pastelBlue   = Color(red: 167/255, green: 215/255, blue: 247/255)
    static let pastelGreen  = Color(red: 188/255, green: 234/255, blue: 188/255)
    static let pastelYellow = Color(red: 253/255, green: 253/255, blue: 196/255)
    static let pastelOrange = Color(red: 255/255, green: 204/255, blue: 169/255)
    static let pastelRed    = Color(red: 255/255, green: 179/255, blue: 186/255)
    static let pastelGray   = Color(red: 207/255, green: 207/255, blue: 207/255)
    
    // ダークパステルカラー定義
    static let darkPastelBlue   = Color(red: 106/255, green: 168/255, blue: 204/255)
    static let darkPastelGreen  = Color(red: 124/255, green: 191/255, blue: 124/255)
    static let darkPastelYellow = Color(red: 228/255, green: 228/255, blue: 146/255)
    static let darkPastelOrange = Color(red: 245/255, green: 174/255, blue: 132/255)
    static let darkPastelRed    = Color(red: 230/255, green: 138/255, blue: 146/255)
    static let darkPastelGray   = Color(red: 160/255, green: 160/255, blue: 160/255)
    
    // レベルに応じた色を取得
    static func forLevel(_ level: Int, isDark: Bool = false) -> Color {
        let colors: [Color] = isDark
            ? [.darkPastelBlue, .darkPastelGreen, .darkPastelYellow, .darkPastelOrange, .darkPastelRed]
            : [.pastelBlue, .pastelGreen, .pastelYellow, .pastelOrange, .pastelRed]
        
        guard level >= 1 && level <= 5 else {
            return isDark ? .darkPastelGray : .pastelGray
        }
        return colors[level - 1]
    }
}

extension SKColor {
    // SpriteKit用のパステルカラー定義
    static let pastelBlue   = SKColor(red: 167/255, green: 215/255, blue: 247/255, alpha: 1.0)
    static let pastelGreen  = SKColor(red: 188/255, green: 234/255, blue: 188/255, alpha: 1.0)
    static let pastelYellow = SKColor(red: 253/255, green: 253/255, blue: 196/255, alpha: 1.0)
    static let pastelOrange = SKColor(red: 255/255, green: 204/255, blue: 169/255, alpha: 1.0)
    static let pastelRed    = SKColor(red: 255/255, green: 179/255, blue: 186/255, alpha: 1.0)
    static let pastelGray   = SKColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0)
    
    static let darkPastelBlue   = SKColor(red: 106/255, green: 168/255, blue: 204/255, alpha: 1.0)
    static let darkPastelGreen  = SKColor(red: 124/255, green: 191/255, blue: 124/255, alpha: 1.0)
    static let darkPastelYellow = SKColor(red: 228/255, green: 228/255, blue: 146/255, alpha: 1.0)
    static let darkPastelOrange = SKColor(red: 245/255, green: 174/255, blue: 132/255, alpha: 1.0)
    static let darkPastelRed    = SKColor(red: 230/255, green: 138/255, blue: 146/255, alpha: 1.0)
    static let darkPastelGray   = SKColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    
    // レベルに応じた色を取得
    static func forLevel(_ level: Int, isDark: Bool = false) -> SKColor {
        let colors: [SKColor] = isDark
            ? [.darkPastelBlue, .darkPastelGreen, .darkPastelYellow, .darkPastelOrange, .darkPastelRed]
            : [.pastelBlue, .pastelGreen, .pastelYellow, .pastelOrange, .pastelRed]
        
        guard level >= 1 && level <= 5 else {
            return isDark ? .darkPastelGray : .pastelGray
        }
        return colors[level - 1]
    }
}
