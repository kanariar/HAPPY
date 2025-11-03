import Foundation
import CoreGraphics // CGFloatを使うために必要

// MARK: - Level Configuration
/// レベルに関する設定を管理
struct LevelConfig {
    static let values = [5, 10, 50, 100, 500]
    
    /// レベルから表示値に変換
    static func displayValue(for level: Int) -> Int {
        guard level >= 1 && level <= values.count else { return 0 }
        return values[level - 1]
    }
    
    /// レベルからマーブルサイズを取得
    static func marbleSize(for level: Int) -> CGFloat {
        let sizes: [CGFloat] = [30, 40, 50, 60, 70]
        guard level >= 1 && level <= sizes.count else { return 40 }
        return sizes[level - 1]
    }
}
