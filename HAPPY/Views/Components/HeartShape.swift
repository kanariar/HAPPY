import SwiftUI

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath(heartIn: rect)
        return Path(bezierPath.cgPath)
    }
}
