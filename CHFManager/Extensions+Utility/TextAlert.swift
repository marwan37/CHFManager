import SwiftUI

struct TextAlert: View {
    @State var title: String
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
   
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.black)
                
                Divider()
                
                TextField("Enter text", text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                Divider()
                
                HStack {
                    Button("Dismiss") {
                        self.showingAlert.toggle()
                    }
                }
                .padding(30)
                .padding(.horizontal, 40)
            }
        }
        .frame(width: 300, height: 200)
    }
}

