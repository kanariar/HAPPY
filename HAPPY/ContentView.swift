import SwiftUI
import SpriteKit

// MARK: - Tab Enum
enum Tab {
    case chokobako
    case history
}

// MARK: - Main Content View
struct ContentView: View {
    // @StateはViewが所有する状態。アプリのライフサイクル全体でデータを保持するには、
    // 本来は@StateObjectなどを使う方が望ましいですが、今回は元の構造を維持します。
    @State private var scene: MarbleScene
    @State private var selectedTab: Tab = .chokobako
    @State private var happyEntries: [HappyEntry] = []
    
    init() {
        // SpriteKitシーンの初期化
        let newScene = MarbleScene()
        newScene.scaleMode = .resizeFill
        _scene = State(initialValue: newScene)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChokoBakoView(scene: scene, happyEntries: $happyEntries)
                .tabItem {
                    Label("貯金箱", systemImage: "archivebox.fill")
                }
                .tag(Tab.chokobako)
            
            HappyHistoryView(happyEntries: $happyEntries)
                .tabItem {
                    Label("履歴", systemImage: "list.bullet")
                }
                .tag(Tab.history)
        }
    }
}

#Preview {
    ContentView()
}
