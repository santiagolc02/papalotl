//
//  Account.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 21/09/24.
//

import SwiftUI
import FirebaseAuth

struct Account: View {
    @Binding var isLoggedIn: Bool // Para cambiar el estado de login

    var body: some View {
        VStack {
            Text("Cuenta")
                .font(.largeTitle)
                .padding()

            // Botón de cerrar sesión
            Button(action: {
                logOutUser()
            }) {
                Text("Cerrar sesión")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
    }

    // Función para cerrar sesión
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            // Regresar a la página de login
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error al cerrar sesión: %@", signOutError)
        }
    }
}

#Preview {
    Account(isLoggedIn: .constant(true)) // Ejemplo de cómo previsualizar con el binding
}

