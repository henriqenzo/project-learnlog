//
//  AuthViewModel.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String = ""
    @Published var isLoading = false

    func login(email: String, pass: String) {
        self.isLoading = true
        self.errorMessage = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let url = URL(string: "http://localhost:3000/api/login") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = ["email": email, "senha": pass]
            request.httpBody = try? JSONEncoder().encode(body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false

                    if let error = error {
                        self.errorMessage = "Erro de conexão: \(error.localizedDescription)"
                        return
                    }

                    guard let data = data else { return }

                    do {
                        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                        if response.success, let user = response.user {
                            self.currentUser = user
                            self.isAuthenticated = true
                        } else {
                            self.errorMessage = response.message ?? "Erro desconhecido"
                        }
                    } catch {
                        self.errorMessage = "Erro ao ler resposta."
                        print(error)
                    }
                }
            }.resume()
        }
    }

    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
    }
}
