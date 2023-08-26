// Copyright (c) 2020 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
//
// This project and source code may use libraries or frameworks that are
// released under various Open-Source licenses. Use of those libraries and
// frameworks are governed by their own individual licenses.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI

struct PasswordField: ViewModifier {
  var error: Bool

  func body(content: Content) -> some View {
    content
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .border(error ? Color.red : Color.gray)
  }
}
struct TextEditor: UIViewRepresentable {
  @Binding var text: String

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator

    textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    textView.isScrollEnabled = true
    textView.isEditable = true
    textView.isUserInteractionEnabled = true
    textView.backgroundColor = UIColor.white

    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var parent: TextEditor

    init(_ textView: TextEditor) {
      self.parent = textView
    }

    func textView(
      _ textView: UITextView,
      shouldChangeTextIn range: NSRange,
      replacementText text: String
    ) -> Bool {
      return true
    }

    func textViewDidChange(_ textView: UITextView) {
      self.parent.text = textView.text
    }
  }
}

//struct TextEditor_Previews: PreviewProvider {
//  static var previews: some View {
//    GenderField(tab: .constant("Male"))
//  }
//}
struct CustomTextField : View {
    
    var image : String
    var placeHolder : String
    @Binding var txt : String
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            
            Image(systemName: image)
                .font(.system(size: 24))
                .foregroundColor(Color.grayMe.opacity(1))
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
            
            ZStack{
                
                if placeHolder == "Password" || placeHolder == "Re-Enter"{
                    SecureField(placeHolder, text: $txt)
                        .autocapitalization(.none)
                }
                else{
                    TextField(placeHolder, text: $txt)
                        .autocapitalization(.none)
                }
            }
                .padding(.horizontal)
                .padding(.leading,65)
                .frame(height: 60)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}





struct AgeTextField : View {
    
    var image : String
   
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }
  
  
    @Binding var birthDate : Date
    var ageStr : String {
        return String(birthDate.getAge(birthday: birthDate))
    }
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            HStack{
            Image(systemName: image)
                .font(.system(size: 24))
                .foregroundColor(Color.grayMe.opacity(1))
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                
                DatePicker("Date of Birth", selection: $birthDate, in: ...Date(), displayedComponents: .date).font(.system(size: 14))
                    .opacity(0.5)
                    .frame(height: 60) .padding(.horizontal)
                    .accentColor(Color.lightRed.opacity(0.9))
                    .frame(height: 60)
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    func getAge(birthday: Date) -> Int  {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return Int(age)
    }
}

struct GenderField : View {
    @Namespace var animation
    @Binding var tab : String
    @State var image : String
    
    var body: some View{
        
        
        HStack(spacing:10){
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ultra > 400 ? 35 : 25, height: ultra > 400 ? 35 : 25)

            TabButton(selected: $tab, title: "Male", animation: animation, image: $image)
                    .onTapGesture {
                        print("gender tab is \(tab)")
                    }
            TabButton(selected: $tab, title: "Female", animation: animation, image: $image)
                
            TabButton(selected: $tab, title: "Neutral", animation: animation, image: $image)

  
        } .padding(.horizontal, ultra > 300 ? 20 : 10)
        
    }
    
}
struct TabButton : View {
    
    @Binding var selected : String
    var title : String
    var animation : Namespace.ID
    @Binding var image: String
    var body: some View{
       
        Button(action: {
            
            withAnimation(.spring()){
                
                selected = title
                  image = title
                print("gender is \(title)")
                    
            }
            
        }) {
            
            ZStack{
                
                // Capsule And Sliding Effect...
                
                Capsule()
                    .fill(Color.clear)
                    .frame(height: 35)
                    .padding(.horizontal)
                
                if selected == title{
                    
                    Capsule()
                        .fill(Color.white)
                        .opacity(0.8)
                        .frame(height: 35)
                    // Mathced Geometry Effect...
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
                
                Text(title)
                    .font(.system(size: ultra > 400 ? 15 : 14))
                    .foregroundColor(selected == title ? .navy : .gray)
                    .fontWeight(selected == title ? .semibold : .light)
                    .opacity(selected == title ? 0.9 : 0.7)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
    }
}


// Loading View...

struct LoadingView : View {
    
    @State var animation = false
    
    var body: some View{
        
        VStack{
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color("bottom"),lineWidth: 8)
                .frame(width: 75, height: 75)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all, edges: .all))
        .onAppear(perform: {
            
            withAnimation(Animation.linear(duration: 1)){
                
                animation.toggle()
            }
        })
    }
}


