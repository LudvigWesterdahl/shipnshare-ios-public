import SwiftUI


/// A border ViewModifier that supports rounded corners.
struct RoundedBorder: ViewModifier {
    
    let cornerRadius: CGFloat
    let width: CGFloat
    let color: Color
    
    
    func body(content: Content) -> some View {
        return content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

struct RoundedBorder_Previews: PreviewProvider {
    static var previews: some View {
        Image(systemName: "house")
            .resizable()
            .frame(width: 250, height: 250, alignment: .center)
            .background(Color.white)
            .modifier(RoundedBorder(cornerRadius: 50, width: 10, color: Color.red))
    }
}
