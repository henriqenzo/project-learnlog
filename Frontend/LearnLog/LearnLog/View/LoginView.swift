//
//  LoginView.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = "joao@gmail.com"
    @State private var password = "123456"
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 0) {
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .foregroundColor(.blue)
                    .padding(.bottom, 40)
                
                Text("LearnLog")
                    .font(.largeTitle)
                    .bold()
            }
            
            VStack(spacing: 36) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Email")
                            .font(.system(size: 18))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                    TextField("Digite seu email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Senha")
                            .font(.system(size: 18))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                    SecureField("Digite sua senha", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: {
                    authViewModel.login(email: email, pass: password)
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(Color.white)
                    } else {
                        Text("Entrar")
                    }
                }
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(authViewModel.isLoading ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(authViewModel.isLoading)
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
