import SwiftUI

struct SheetButton<Content: View>: View {
    
    @State private var isOpen: Bool = false
    
    private let title: String
    private let buttonContent: AnyView
    private let sheetContent: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.buttonContent = AnyView(Text(LocalizedStringKey(title)))
        self.sheetContent = content
    }
    
    init<T: View>(title: String, label: T, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.buttonContent = AnyView(label)
        self.sheetContent = content
    }
    
    var body: some View {
        Button(action: {
            self.isOpen = true
        }) {
            return buttonContent
        }
        .modal(title: title, isOpen: $isOpen, content: sheetContent)
    }
}

struct SheetButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SheetButton(title: "Settings") {
                Form {
                    Text("Hello")
                }
                Spacer()
            }
            
            SheetButton(title: "House", label: Image(systemName: "house")) {
                Text("Hello")
                Spacer()
                    .previewDevice("iPad Pro (9.7-inch)")
            }
        }
        
    }
}
