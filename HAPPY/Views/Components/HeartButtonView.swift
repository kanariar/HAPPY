import SwiftUI

// MARK: - Heart Button View
struct HeartButtonView: View {
    let level: Int
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            heartBackground
            valueLabel
        }
        .frame(width: 55, height: 55)
        .shadow(
            color: isSelected ? Color.forLevel(level).opacity(0.5) : .clear,
            radius: 8,
            x: 0,
            y: 3
        )
        .scaleEffect(isSelected ? 1.15 : 0.9)
    }
    
    /// ハート型の背景
    private var heartBackground: some View {
        ZStack {
            HeartShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.forLevel(level).opacity(isSelected ? 0.9 : 0.15),
                            Color.forLevel(level).opacity(isSelected ? 0.7 : 0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HeartShape()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(isSelected ? 0.4 : 0.2),
                            Color.clear
                        ]),
                        center: UnitPoint(x: 0.3, y: 0.3),
                        startRadius: 0,
                        endRadius: 35
                    )
                )
            
            HeartShape()
                .stroke(Color.forLevel(level, isDark: true), lineWidth: isSelected ? 3 : 2)
        }
        .rotationEffect(.degrees(180))
    }
    
    /// 値ラベル
    private var valueLabel: some View {
        Text("\(LevelConfig.displayValue(for: level))")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(
                isSelected
                    ? Color.forLevel(level, isDark: true)
                    : Color.forLevel(level, isDark: true).opacity(0.65)
            )
    }
}
