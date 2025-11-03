import SpriteKit
import UIKit // UIGraphicsImageRenderer を使うために必要

// MARK: - SpriteKit Scene
class MarbleScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // 境界を設定
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0.3
        border.restitution = 0.2
        self.physicsBody = border
    }
    
    /// ハート型のマーブルを落とす
    func dropMarble(size: Int) {
        let heartSize = LevelConfig.marbleSize(for: size)
        let fillColor = SKColor.forLevel(size, isDark: false)
        let strokeColor = SKColor.forLevel(size, isDark: true)
        
        let marble = createMarbleNode(
            size: heartSize,
            fillColor: fillColor,
            strokeColor: strokeColor,
            physicsLevel: size
        )
        
        // ランダムな位置から落下
        let randomX = CGFloat.random(in: frame.width * 0.3...frame.width * 0.7)
        marble.position = CGPoint(x: randomX, y: frame.height - 50)
        
        addChild(marble)
    }
    
    private func createMarbleNode(
        size: CGFloat,
        fillColor: SKColor,
        strokeColor: SKColor,
        physicsLevel: Int
    ) -> SKNode {
        let marble = SKNode()
        
        // グラデーションテクスチャを適用
        let gradientTexture = createMarbleTexture(
            size: CGSize(width: size, height: size),
            color: fillColor
        )
        let fillSprite = SKSpriteNode(
            texture: gradientTexture,
            size: CGSize(width: size, height: size)
        )
        marble.addChild(fillSprite)
        
        // ハート型のアウトラインを追加
        let heartRect = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
        let heartPath = UIBezierPath(heartIn: heartRect).cgPath
        let strokeShape = SKShapeNode(path: heartPath)
        strokeShape.strokeColor = strokeColor
        strokeShape.lineWidth = 2.5
        strokeShape.fillColor = .clear
        marble.addChild(strokeShape)
        
        // 物理ボディを設定
        marble.physicsBody = SKPhysicsBody(circleOfRadius: size / 2.0)
        marble.physicsBody?.isDynamic = true
        marble.physicsBody?.mass = CGFloat(physicsLevel) * 0.1
        marble.physicsBody?.friction = 0.5
        marble.physicsBody?.restitution = 0.15
        marble.physicsBody?.linearDamping = 0.2
        marble.physicsBody?.angularDamping = 0.2
        
        return marble
    }
    
    private func createMarbleTexture(size: CGSize, color: SKColor) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let ctx = context.cgContext
            
            // Y軸を反転
            ctx.translateBy(x: 0, y: size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            
            let heartRect = CGRect(origin: .zero, size: size)
            let heartPath = UIBezierPath(heartIn: heartRect).cgPath
            
            // ベースカラーを塗りつぶし
            let darkerColor = color.withAlphaComponent(0.9)
            ctx.addPath(heartPath)
            ctx.setFillColor(darkerColor.cgColor)
            ctx.fillPath()
            
            // グラデーション効果を追加
            ctx.saveGState()
            ctx.addPath(heartPath)
            ctx.clip()
            
            if let mainGradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [
                    CGColor(red: 1, green: 1, blue: 1, alpha: 0.6),
                    CGColor(red: 1, green: 1, blue: 1, alpha: 0.0)
                ] as CFArray,
                locations: [0.0, 1.0]
            ) {
                ctx.drawRadialGradient(
                    mainGradient,
                    startCenter: CGPoint(x: size.width * 0.3, y: size.height * 0.7),
                    startRadius: 0,
                    endCenter: CGPoint(x: size.width * 0.5, y: size.height * 0.5),
                    endRadius: size.width * 0.6,
                    options: []
                )
            }
            ctx.restoreGState()
            
            // ハイライトを追加
            ctx.addPath(heartPath)
            ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.3))
            ctx.setLineWidth(1.5)
            ctx.strokePath()
        }
        
        return SKTexture(image: image)
    }
}
