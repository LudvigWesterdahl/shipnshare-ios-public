import SwiftUI

extension View {
    func modal<Content: View>(title: String,
                              isOpen: Binding<Bool>,
                              @ViewBuilder content: @escaping () -> Content) -> some View {
        return self.sheet(isPresented: isOpen) {
            Sheet(title: title, isOpen: isOpen, content: content)
        }
    }
}
