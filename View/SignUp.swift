//
//  SignUp.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 20/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUp: View {
    @Binding var showSignup: Bool
    @Binding var isLoggedIn: Bool
    @State private var name: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            backgroundView

            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                
                logoView
                
                Text("Regístrate")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("¡Regístrate para disfrutar al máximo de Papalote Museo del Niño!")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .fontWeight(.semibold)
                
                inputFields

                registerButton
                
                Spacer()

                loginLink
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Entendido")))
            }

            if isLoading {
                loadingView
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // Vista de fondo con imagen y degradado
    private var backgroundView: some View {
        ZStack {
            Image("loginbackground")
                .resizable()
                .rotationEffect(.degrees(180))
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.green.opacity(0.25)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 10)
        }
    }

    // Logo de la aplicación
    private var logoView: some View {
        Group {
            if let uiImagee = UIImage(named: "papalotelogo") {
                Image(uiImage: uiImagee)
                    .resizable()
                    .frame(width: 120, height: 140)
                    .padding(.bottom, 60)
                    .padding(.leading, 120)
            } else {
                Text("Imagen no encontrada")
            }
        }
    }

    // Campos de entrada para el registro
    private var inputFields: some View {
        VStack(spacing: 25) {
            CustomTF(sfIcon: "person", hint: "Nombre Completo", value: $name)
            CustomTF(sfIcon: "at", hint: "Correo Electrónico", value: $emailID)
            CustomTF(sfIcon: "lock", hint: "Contraseña", isPassword: true, value: $password)
            CustomTF(sfIcon: "lock", hint: "Confirmar Contraseña", isPassword: true, value: $confirmPassword)
            
            Button("Olvidé mi contraseña") {
                // Implementar lógica de recuperación de contraseña
            }
            .font(.callout)
            .fontWeight(.heavy)
            .tint(.brown)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    // Botón de registro
    private var registerButton: some View {
        GradientButton(title: "Regístrate", icon: "arrowshape.right.circle") {
            if password == confirmPassword {
                signUpUser()
            } else {
                errorMessage = "Las contraseñas no coinciden"
                showAlert.toggle()
            }
        }
        .disabled(name.isEmpty || emailID.isEmpty || password.isEmpty || confirmPassword.isEmpty)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    // Enlace para iniciar sesión si ya tienes una cuenta
    private var loginLink: some View {
        HStack(spacing: 6) {
            Text("¿Ya tienes cuenta?")
                .foregroundStyle(.gray)
            Button("Inicia Sesión") {
                showSignup.toggle()
            }
            .fontWeight(.bold)
            .tint(.brown)
        }
        .font(.callout)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // Vista de carga mientras se registra el usuario
    private var loadingView: some View {
        VStack {
            ProgressView("Registrando...")
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
    }

    // Función para registrar al usuario
    private func signUpUser() {
        errorMessage = ""
        showAlert = false
        isLoading = true
        
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: emailID, password: trimmedPassword) { authResult, error in
            if let error = error {
                handleError(error: error)
                isLoading = false
                return
            }
            
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        errorMessage = "Error al guardar el nombre: \(error.localizedDescription)"
                        showAlert = true
                        isLoading = false
                    } else {
                        saveUserToFirestore(userID: user.uid)
                        DispatchQueue.main.async {
                            isLoggedIn = true
                            isLoading = false
                        }
                    }
                }
            }
        }
    }

    // Guardar datos del usuario en Firestore
    private func saveUserToFirestore(userID: String) {
        Firestore.firestore().collection("usuarios").document(userID).setData([
            "name": name,
            "email": emailID,
            "uid": userID
        ]) { error in
            if let error = error {
                errorMessage = "Error al guardar los datos: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    // Manejo de errores
    private func handleError(error: Error) {
        let authError = error as NSError
        if let errorCode = AuthErrorCode(rawValue: authError.code) {
            switch errorCode {
            case .emailAlreadyInUse:
                errorMessage = "Este correo electrónico ya está en uso. Por favor, utiliza otro."
            case .invalidEmail:
                errorMessage = "El correo electrónico no es válido. Por favor, verifica."
            case .weakPassword:
                errorMessage = "La contraseña es demasiado débil. Debe tener al menos 6 caracteres."
            default:
                errorMessage = error.localizedDescription
            }
        }
        showAlert = true
        isLoading = false
    }
}

#Preview {
    ContentView()
}






