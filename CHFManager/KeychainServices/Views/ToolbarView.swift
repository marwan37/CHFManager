/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///

import SwiftUI
import LocalAuthentication

func getBiometricType() -> String {
  let context = LAContext()

  _ = context.canEvaluatePolicy(
    .deviceOwnerAuthenticationWithBiometrics,
    error: nil)
  switch context.biometryType {
  case .faceID:
    return "faceid"
  case .touchID:
    // In iOS 14 and later, you can use "touchid" here
    return "lock"
  case .none:
    return "lock"
  @unknown default:
    return "lock"
  }
}

// swiftlint:disable multiple_closures_with_trailing_closure
struct ToolbarView: View {
  @Binding var loginLocked: Bool
@ObservedObject var loginData: LoginViewModel
  @Binding var setPasswordModal: Bool
  @State private var showUnlockModal: Bool = false
  @State private var changePasswordModal: Bool = false

  func tryBiometricAuthentication() {
    // 1
    let context = LAContext()
    var error: NSError?

    // 2
    if context.canEvaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      error: &error) {
      // 3
      let reason = "Authenticate to unlock your note."
      context.evaluatePolicy(
        .deviceOwnerAuthentication,
        localizedReason: reason) { authenticated, error in
        // 4
        DispatchQueue.main.async {
          if authenticated {
            // 5
            self.loginLocked = false
          } else {
            // 6
            if let errorString = error?.localizedDescription {
              print("Error in biometric policy evaluation: \(errorString)")
            }
            self.showUnlockModal = true
          }
        }
      }
    } else {
      // 7
      if let errorString = error?.localizedDescription {
        print("Error in biometric policy evaluation: \(errorString)")
      }
      showUnlockModal = true
    }
  }

  var body: some View {
    HStack {
      #if DEBUG
      Button(
        action: {
          print("App reset.")
//          self.loginData.noteText = ""
          self.loginData.updateStoredPassword("")
        }, label: {
          Image(systemName: "trash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25.0, height: 25.0)
        })
      #endif

      Color.clear
        .sheet(isPresented: $setPasswordModal) {
          SetPasswordView(
            title: "Set Note Password",
            subTitle: "Enter a password to protect this note.",
            loginLocked: self.$loginLocked,
            showModal: self.$setPasswordModal,
            loginData: self.loginData
          )
        }

      Spacer()

      Button(
        action: {
          self.changePasswordModal = true
        }) {
        Image(systemName: "arrow.right.arrow.left")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25.0, height: 25.0)
      }
      .disabled(loginLocked || loginData.isPasswordBlank)
      .sheet(isPresented: $changePasswordModal) {
        SetPasswordView(
          title: "Change Password",
          subTitle: "Enter new password",
          loginLocked: self.$loginLocked,
          showModal: self.$changePasswordModal,
          loginData: self.loginData)
      }

      Button(
        action: {
          if self.loginLocked {
            // Biometric Authentication Point
            self.tryBiometricAuthentication()
          } else {
            self.loginLocked = true
          }
        }) {
        // Lock Icon
        Image(systemName: loginLocked ? getBiometricType() : "lock.open")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25.0, height: 25.0)
      }
      .sheet(isPresented: $showUnlockModal) { 
        if self.loginData.isPasswordBlank {
          SetPasswordView(
            title: "Enter Password",
            subTitle: "Enter a password to protect your notes",
            loginLocked: self.$loginLocked,
            showModal: self.$changePasswordModal,
            loginData: self.loginData)
        } else {
          UnlockView(loginLocked: self.$loginLocked, showModal: self.$showUnlockModal, loginData: self.loginData)
        }
      }
    }
    .frame(height: 64)
  }
}

struct ToolbarView_Previews: PreviewProvider {
  static var previews: some View {
    ToolbarView(loginLocked: .constant(true), loginData: LoginViewModel(), setPasswordModal: .constant(false))
  }
}
