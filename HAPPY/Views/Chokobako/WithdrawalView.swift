import SwiftUI

// MARK: - Withdrawal View
struct WithdrawalView: View {
    @Binding var happyEntries: [HappyEntry]
    let maxAmount: Int
    @Binding var isPresented: Bool
    
    @State private var contentText = ""
    @State private var amountText = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case content
        case amount
    }
    
    /// 入力された金額
    private var enteredAmount: Int? {
        Int(amountText)
    }
    
    /// 金額の妥当性チェック
    private var isValidAmount: Bool {
        guard let amount = enteredAmount else { return false }
        return amount > 0 && amount <= maxAmount
    }
    
    /// 出金可能かどうか
    private var canWithdraw: Bool {
        !contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isValidAmount
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    currentBalanceCard
                    contentInputSection
                    amountInputSection
                    withdrawButton
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("お返し(出金)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
    
    /// 現在の貯金額カード
    private var currentBalanceCard: some View {
        HStack {
            Text("現在の貯金額")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text("\(maxAmount)円")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// 内容入力セクション
    private var contentInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("内容")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(alignment: .top) {
                TextEditor(text: $contentText)
                    .frame(minHeight: 44, maxHeight: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($focusedField, equals: .content)
                    .scrollContentBackground(.hidden)
                    .overlay(placeholderOverlay(text: "誰に何をプレゼントしますか?"))
                
                if !contentText.isEmpty {
                    clearButton { contentText = "" }
                }
            }
        }
    }
    
    /// 金額入力セクション
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("金額")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                TextField("金額を入力", text: $amountText)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Text("円")
                    .foregroundColor(.gray)
            }
            
            if let amount = enteredAmount, amount > maxAmount {
                Text("貯金額を超えています")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    /// 出金ボタン
    private var withdrawButton: some View {
        Button(action: executeWithdrawal) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                Text("出金する")
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(canWithdraw ? Color.orange : Color.gray)
            .cornerRadius(15)
            .shadow(
                color: canWithdraw ? .orange.opacity(0.3) : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(!canWithdraw)
        .padding(.top, 10)
    }
    
    /// プレースホルダーオーバーレイ
    private func placeholderOverlay(text: String) -> some View {
        Group {
            if contentText.isEmpty {
                HStack {
                    Text(text)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.leading, 17)
                        .padding(.top, -10)
                    Spacer()
                }
            }
        }
    }
    
    /// クリアボタン
    private func clearButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
        .padding(.trailing, 8)
        .padding(.top, 12)
    }
    
    /// 出金を実行
    private func executeWithdrawal() {
        guard let amount = enteredAmount, canWithdraw else { return }
        
        let trimmedText = contentText.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = HappyEntry(
            text: trimmedText,
            level: 0,
            isWithdrawal: true,
            amount: amount
        )
        happyEntries.insert(entry, at: 0)
        
        isPresented = false
    }
}
