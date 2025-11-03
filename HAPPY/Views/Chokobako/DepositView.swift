import SwiftUI

// MARK: - Deposit View (入金画面)
struct DepositView: View {
    var scene: MarbleScene
    @Binding var happyEntries: [HappyEntry]
    @Binding var isPresented: Bool
    
    @State private var inputText = ""
    @State private var selectedLevel: Int?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    textInputSection
                    levelSelectionSection
                    saveButton
                    
                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
            .navigationTitle("しあわせ入金")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
    
    /// テキスト入力セクション
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("出来事を入力")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(alignment: .top) {
                TextEditor(text: $inputText)
                    .frame(minHeight: 44, maxHeight: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isTextFieldFocused)
                    .scrollContentBackground(.hidden)
                    .overlay(placeholderOverlay)
                
                if !inputText.isEmpty {
                    clearButton
                }
            }
        }
        .padding(.horizontal)
    }
    
    /// プレースホルダー表示
    private var placeholderOverlay: some View {
        Group {
            if inputText.isEmpty {
                HStack {
                    Text("しあわせを感じた出来事は?")
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.leading, 17)
                        .padding(.top, -10)
                    Spacer()
                }
            }
        }
    }
    
    /// クリアボタン
    private var clearButton: some View {
        Button(action: { inputText = "" }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
        .padding(.trailing, 8)
        .padding(.top, 12)
    }
    
    /// レベル選択セクション
    private var levelSelectionSection: some View {
        VStack(spacing: 15) {
            Text("しあわせレベル(円)を選択")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 15) {
                ForEach(1...5, id: \.self) { level in
                    levelButton(level: level)
                }
            }
        }
    }
    
    /// レベルボタン
    private func levelButton(level: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedLevel = level
            }
        }) {
            HeartButtonView(
                level: level,
                isSelected: selectedLevel == level
            )
            .opacity(selectedLevel == nil || selectedLevel == level ? 1.0 : 0.4)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedLevel)
    }
    
    /// 保存ボタン
    private var saveButton: some View {
        Button(action: saveHappy) {
            Text("貯金する")
                .fontWeight(.semibold)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canSave ? Color.pink : Color.gray)
                .cornerRadius(15)
                .shadow(
                    color: canSave ? .pink.opacity(0.3) : .clear,
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .disabled(!canSave)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    /// 保存可能かどうか
    private var canSave: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedLevel != nil
    }
    
    /// しあわせを保存
    private func saveHappy() {
        guard let level = selectedLevel else { return }
        
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = HappyEntry(text: trimmedText, level: level)
        happyEntries.insert(entry, at: 0)
        
        scene.dropMarble(size: level)
        
        isPresented = false
    }
}
