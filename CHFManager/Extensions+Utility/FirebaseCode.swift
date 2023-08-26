//
//  FirebaseCode.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2021-01-02.
//

//MARK: DLOGIN
/*
 @AppStorage("current_status") var status = false
 @EnvironmentObject var authState: AuthenticationState
 
 if status || authState.loggedInUser != nil {
 
     Maison()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(DayData())
        .environmentObject(NYHAQuestions())
         .navigationBarHidden(true)


 }
 else{
     
     Login().environmentObject(AuthenticationState())
         .environment(\.managedObjectContext, shared.persistentContainer.viewContext)
         .navigationBarHidden(true)
 }
 */


//MARK: LOGIN
/*
 @State var code:String? = ""
 
 
  Displaying Alert...
            .alert(isPresented: $loginData.error, content: {

                Alert(title: Text("Error"), message: Text(loginData.errorMsg), dismissButton: .destructive(Text("Ok")))
            })
            .fullScreenCover(isPresented: $loginData.registerUser, content: {

                Register()
            })
 
 func countryFlag(country: String) -> String {
     let base: UInt32 = 127397
     var s = ""
     for v in country.unicodeScalars {
         s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
     }
     return String(s)
 }
 
 struct NumberTextField : View {
   
     @Binding var number : String
   
     var body: some View{
         VStack(spacing:0){
     
         ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
             
             Image(systemName: "phone")
                 .font(.system(size: 24))
                 .foregroundColor(Color("bottom").opacity(0.9))
                 .frame(width: 60, height: 60)
                 .background(Color.white)
                 .clipShape(Circle())
             
             
             HStack{
                 
                 TextField("123-456-7890", text: $number)
                     .frame(width: 120, height: 60)
                     .keyboardType(.numberPad)
                    
                 
             }
                 .padding(.horizontal)
                 .padding(.leading,65)
                 .frame(height: 60)
                 .background(Color.white.opacity(0.2))
                 .clipShape(Capsule())
         }
         .padding(.horizontal)
     }
 }}
 
     ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {

         Image(systemName: "phone")
             .font(.system(size: 24))
             .foregroundColor(Color("bottom").opacity(0.9))
             .frame(width: 60, height: 60)
             .background(Color.white)
             .clipShape(Circle())



         HStack{


         ModalLink(destination: CountryPicker(code: $code, phoneCode: $loginData.code)) {
             if self.code == "" {
                 HStack{

                 Text("(+?)")
                     .font(.system(size: 15, design: .monospaced))
                     .foregroundColor(Color("bottom").opacity(0.96))

                 }
//                                    .frame(minWidth: 50, maxWidth: 100, minHeight: 50)
             }  else{
                 HStack {
                     Text("\(countryFlag(country: self.code!))")



                     Text("(\(loginData.code))")
                         .font(.system(size: 15, weight: .light, design: .rounded))
                         .foregroundColor(.black)
                 }.frame(minWidth: 60, maxWidth: 80, minHeight: 50)

             }
         }


             Rectangle().frame(width: 2, height: 25).foregroundColor(Color.lairBackgroundGray)
                 .padding(.leading, 10)

             TextField("123-456-7890", text: $loginData.number)
                 .frame(width: 120, height: 60)
                 .keyboardType(.numberPad)
                 .padding(.leading, 5)
                 .dismissKeyboardOnTap()

         }
             .padding(.horizontal)
             .padding(.leading,65)
             .frame(height: 60)
             .background(Color.white.opacity(0.2))
             .clipShape(Capsule())
     }
     .padding(.horizontal)
     .dismissKeyboardOnTap()
 
 VStack(spacing: 15){
    
     Divider().padding()
     
     Button(action:{
         loginData.signInAnonymous()
     })
     {
     Text("Sign in anonymously")
     }
     
     if loginData.isLoading{
         ProgressView()
             .padding()
     }
     else{
         Button(action: loginData.verifyUser, label: {
             Text("Sign in with your phone number")
                 .foregroundColor(loginData.code != "" && loginData.number.count >= 7 ? Color.white.opacity(0.7) : Color.black.opacity(0.3))
                 .fontWeight(.regular)
           
             
             
         })
         .disabled(loginData.code == "" || loginData.number == "" ? true : false)
         .opacity(loginData.code == "" || loginData.number == "" ? 0.5 : 1)
     }

 }.padding(.vertical)

 */


//MARK: LoginViewModel - Phone verification code, signinAnonymous, checkUser
/*
 import SwiftUI
 import Firebase


 class LoginViewModel : ObservableObject{
     var userRepository = SettingsViewModel()
     @Published var code = ""
     @Published var number = ""
     
     // For Any Errors..
     @Published var errorMsg = ""
     @Published var error = false

     @Published var registerUser = false
     @AppStorage("current_status") var status = false
     
     // Loading when Searches for user...
     @Published var isLoading = false
     

     func verifyUser(){
         
         isLoading = true
         
         // Remove When TEsting In Live
         Auth.auth().settings?.isAppVerificationDisabledForTesting = false
         
         let phoneNumber = "+" + code + number
         PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (ID, err) in
             
             if err != nil{
                 self.errorMsg = err!.localizedDescription
                 self.error.toggle()
                 self.isLoading = false
                 return
             }
             
             // Code Sent Successfully...
             
             alertView(msg: "Enter Verification Code") { (Code) in
                 
                 let credential = PhoneAuthProvider.provider().credential(withVerificationID: ID!, verificationCode: Code)
                 
                 Auth.auth().signIn(with: credential) { (res, err) in
                     
                     if err != nil{
                         self.errorMsg = err!.localizedDescription
                         self.error.toggle()
                         self.isLoading = false
                         return
                     }
                     
                     self.checkUser()
                 }
             }
         }
     }
     
     func signInAnonymous() {
         isLoading = true
        
         Auth.auth().signInAnonymously()
         self.isLoading = false
       
     }
     
     
     
     func checkUser(){
         
         let ref = Firestore.firestore()
         let uid = Auth.auth().currentUser!.uid
         
         ref.collection("Users").whereField("uid", isEqualTo: uid).getDocuments { (snap, err) in
             
             if err != nil{
                 // No Documents..
                 // No User Found...
                 self.registerUser.toggle()
                 self.isLoading = false
                 return
             }
             
             if snap!.documents.isEmpty{
                 
                 self.registerUser.toggle()
                 self.isLoading = false
                 return
             }
             self.status = true
         }
     }
 }

 */

//MARK: REGISTERVIEWMODEL
/*
 
 import SwiftUI
 import Firebase

 class RegisterViewModel : ObservableObject{
    let shared = CoreDataManager()
     @Published var name = ""
     @Published var gender = ""
     @Published var birthDate = Date()
     @Published var email = ""
     @Published var password = ""
     // Loading View...
     @Published var isLoading = false
     @AppStorage("current_status") var status = false
     let ref = Firestore.firestore()
     
     func register(){
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         isLoading = true
      
     
         // setting User Data To Firestore....
         let uid = Auth.auth().currentUser!.uid
         
             self.ref.collection("Users").document(uid).setData([
             
                 "uid": uid,
                 "username": self.name,
                 "gender": self.gender,
                 "birthDate": formatter.string(from: self.birthDate)
                 
             ]) { (err) in
              
                 if err != nil{
                     self.isLoading = false
                     return
                 }
                 self.isLoading = false
                 // success means settings status as true...
                 self.status = true
             }
         
         shared.createUserdetails(name: self.name, email: self.email, password: self.password, birthDate: formatter.string(from: self.birthDate), gender: self.gender, uid: UUID().uuidString)
         
        
             

     }
     
     
 }
 
 */
//MARK: DayData
//class FireData: ObservableObject{
//    @Published var allData = [DayCellModel]()
//
//    @Published var noData = false
//
//        let dbRef = Firestore.firestore()
//        init() {
//            readAllData()
//
//
//        }
//        func readAllData(){
//
//            dbRef.collection("dayDatas").addSnapshotListener { (snap, err) in
//
//                if err != nil{
//
//                    print((err?.localizedDescription)!)
//                    self.noData = true
//                    return
//                }
//
//                if (snap?.documentChanges.isEmpty)!{
//
//                    self.noData = true
//                    return
//                }
//
//
//                for i in snap!.documentChanges{
//
//                    if i.type == .added{
//
//                    let uid = i.document.documentID
//                    let date = i.document.get("date") as? Date
//                    let completed = i.document.get("completed") as! Int
//                    let percentage = i.document.get("percentage") as! Double
//                    let liquids = i.document.get("liquids") as! Int
//                    let swelling = i.document.get("swelling") as! String
//                    let fatigue = i.document.get("fatigue") as! String
//                    let dyspnea = i.document.get("dyspnea") as! String
//                    let isAceComplete = i.document.get("isAceComplete") as? Int
//                    let isBetaComplete = i.document.get("isBetaComplete") as? Int
//                    let isDeltaComplete = i.document.get("isDeltaComplete") as? Int
//                    let isNitroComplete = i.document.get("isNitroComplete") as? Int
//
//
//                        self.allData.append(DayCellModel(date: date ?? Date(), uid: uid, completed: completed, percentage: percentage, liquids: liquids, swelling: swelling, fatigue: fatigue, dyspnea: dyspnea, isAceComplete: isAceComplete ?? 0, isBetaComplete: isBetaComplete ?? 0, isDeltaComplete: isDeltaComplete ?? 0, isNitroComplete: isNitroComplete ?? 0))
//
//                    }
//
//                    if i.type == .modified{
//
//                        // when data is changed...
//
//                        let uid = i.document.documentID
//                        let date = i.document.get("date") as? Date
//                        let completed = i.document.get("completed") as? Int
//                        let percentage = i.document.get("percentage") as! Double
//                        let liquids = i.document.get("liquids") as! Int
//                        let swelling = i.document.get("swelling") as! String
//                        let fatigue = i.document.get("fatigue") as! String
//                        let dyspnea = i.document.get("dyspnea") as! String
//                        let isAceComplete = i.document.get("isAceComplete") as? Int
//                        let isBetaComplete = i.document.get("isBetaComplete") as? Int
//                        let isDeltaComplete = i.document.get("isDeltaComplete") as? Int
//                        let isNitroComplete = i.document.get("isNitroComplete") as? Int
//
//                        for i in 0..<self.allData.count{
//
//                            if self.allData[i].uid == uid{
//
//                                self.allData[i].date = date ?? Date()
//                                self.allData[i].completed = completed ?? 0
//                                self.allData[i].percentage = percentage
//                                self.allData[i].liquids = liquids
//                                self.allData[i].swelling = swelling
//                                self.allData[i].fatigue = fatigue
//                                self.allData[i].dyspnea = dyspnea
//                                self.allData[i].isAceComplete = isAceComplete ?? 0
//                                self.allData[i].isBetaComplete = isBetaComplete ?? 0
//                                self.allData[i].isDeltaComplete = isDeltaComplete ?? 0
//                                self.allData[i].isNitroComplete = isNitroComplete ?? 0
//                            }
//                        }
//                    }
//
//                    if i.type == .removed {
//
//                        let id = i.document.documentID
//
//                        for i in 0..<self.allData.count{
//                            if self.allData[i].uid == id {
//                                self.allData.remove(at: i)
//
//                                if self.allData.isEmpty {
//                                    self.noData = true
//                                }
//                                return
//                            }
//                        }
//                    }
//                }
//            }
//        }
//}
//
//
//
//
//
//
//
//
//


