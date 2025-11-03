import SwiftUI
import SpriteKit

// MARK: - Piggy Bank View
struct ChokoBakoView: View {
    var scene: MarbleScene
    @Binding var happyEntries: [HappyEntry]
    @State private var showWithdrawalSheet = false
    @State private var showDepositSheet = false
    
    /// 総額を計算
    private var totalAmount: Int {
        happyEntries.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                balanceHeader
                spriteSceneView
                Text("箱内♡の数は今までの「しあわせ貯金」総数です")
                    .font(.system(size: 13, weight: .thin))
                Text("「しあわせお返し」では残高のみが差し引かれます")
                    .font(.system(size: 13, weight: .thin))
            }
            .navigationTitle("しあわせ貯金箱")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showWithdrawalSheet) {
                WithdrawalView(
                    happyEntries: $happyEntries,
                    maxAmount: totalAmount,
                    isPresented: $showWithdrawalSheet
                )
            }
            .sheet(isPresented: $showDepositSheet) {
                DepositView(
                    scene: scene,
                    happyEntries: $happyEntries,
                    isPresented: $showDepositSheet
                )
            }
        }
    }
    
    /// 残高表示ヘッダー
    private var balanceHeader: some View {
        VStack(spacing: 16) {
            // 残高表示
            balanceDisplay
            
            // 入金・出金ボタン
            HStack(spacing: 1) {
                depositButton
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1)
                withdrawalButton
            }
            .frame(height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
    
    /// 残高表示
    private var balanceDisplay: some View {
        HStack(spacing: 4) {
            Text("\(totalAmount)")
                .font(.system(size: 40, weight: .bold))
            
            Text("円")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
    }
    
    /// 入金ボタン
    private var depositButton: some View {
        Button(action: { showDepositSheet = true }) {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.pink)
                    Text("入金")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                Text("(しあわせ貯金)")
                    .font(.system(size: 11))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    /// 出金ボタン
    private var withdrawalButton: some View {
        Button(action: { showWithdrawalSheet = true }) {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(totalAmount > 0 ? .orange : .gray)
                    Text("出金")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                Text("(しあわせお返し)")
                    .font(.system(size: 11))
                    .fontWeight(.medium)
                    .foregroundColor(totalAmount > 0 ? .secondary : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .disabled(totalAmount <= 0)
    }
    
    /// SpriteKitシーン表示
    private var spriteSceneView: some View {
        SpriteView(scene: scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .border(Color.gray.opacity(0.5), width: 5)
            .padding()
    }
}
