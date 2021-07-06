import SwiftUI

struct Sheet<Content: View> : View {
    
    let title: String
    let isOpen: Binding<Bool>
    let content: Content
    
    init(title: String, isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isOpen = isOpen
        self.content = content()
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text(LocalizedStringKey(title))
                    .fontWeight(.semibold)
                HStack {
                    Spacer()
                    Button(action: {
                        self.isOpen.wrappedValue = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                //.frame(alignment: Alignment.trailing)
            }
            .padding(16)
            content
        }
    }
}

struct VModal_Previews: PreviewProvider {
    static var previews: some View {
        Sheet(title: "Hello", isOpen: .constant(true)) {
            Text("Test")
        }
    }
}
