import UIKit // UIBezierPath を使うために必要

// MARK: - Heart Shape
extension UIBezierPath {
    /// ハート型のパスを生成
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        let width = rect.width
        let height = rect.height
        let topPoint = CGPoint(x: rect.midX, y: rect.minY)
        
        self.move(to: topPoint)
        
        // 左側のカーブ
        self.addCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - height * 0.3),
            controlPoint1: CGPoint(x: rect.midX, y: rect.minY + height * 0.3),
            controlPoint2: CGPoint(x: rect.minX, y: rect.minY + height * 0.2)
        )
        
        // 左下の円弧
        self.addArc(
            withCenter: CGPoint(x: rect.minX + width * 0.25, y: rect.maxY - height * 0.25),
            radius: width * 0.25,
            startAngle: .pi,
            endAngle: 0,
            clockwise: false
        )
        
        // 右下の円弧
        self.addArc(
            withCenter: CGPoint(x: rect.maxX - width * 0.25, y: rect.maxY - height * 0.25),
            radius: width * 0.25,
            startAngle: .pi,
            endAngle: 0,
            clockwise: false
        )
        
        // 右側のカーブ
        self.addCurve(
            to: topPoint,
            controlPoint1: CGPoint(x: rect.maxX, y: rect.minY + height * 0.2),
            controlPoint2: CGPoint(x: rect.midX, y: rect.minY + height * 0.3)
        )
        

        self.close()
    }
}
