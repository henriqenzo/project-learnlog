//
//  ProfileView.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.top, 40)
            
            if let user = authViewModel.currentUser {
                Text(user.name)
                    .font(.title2)
                    .bold()
                
                Text(user.email)
                    .foregroundColor(.secondary)
                
                Text(user.role)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(user.role == "ADMIN" ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                    .foregroundColor(user.role == "ADMIN" ? .red : .blue)
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Button(action: {
                authViewModel.logout()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .bold()
                    Text("Sair")
                        .bold()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .cornerRadius(10)
            }
        }
        .navigationTitle("Meu Perfil")
        .padding(24)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
