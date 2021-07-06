import SwiftUI

struct CircularProgressBar: View {
    
    @Binding var progress: Float
    var maxProgress: Float
    var color: Color
    
    var formatText: (Float) -> String
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(color)
                .opacity(0.25)
                .padding(10)
            Text(formatText(progress))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .font(.title2)
            Circle()
                .trim(from: 0, to: CGFloat.init(progress / maxProgress))
                .rotation(Angle.degrees(-90))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .padding(10)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    @State static var value: Float = 3.0
    static var previews: some View {
        CircularProgressBar(progress: .constant(3.0),
                            maxProgress: 10.0,
                            color: Color(red: 67 / 255, green: 160 / 255, blue: 71 / 255)) { progress in
            return "$ \(String(format: "%.2f", progress))"
        }
    }
}
