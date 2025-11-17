//
//  LearnLogApp.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

@main
struct LearnLogApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                CourseListView()
                    .environmentObject(authViewModel) 
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
