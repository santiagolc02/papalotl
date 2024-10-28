import SwiftUI
import FirebaseAuth

struct Login: View {
    @Binding var isLoggedIn: Bool
    @Binding var showSignup: Bool
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack {
            // Fondo con imagen y degradado
            backgroundView
            
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                
                logoView
                
                Text("Login")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Inicia sesión para continuar")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .fontWeight(.semibold)
                
                inputFields
                
                loginButton
                
                Spacer()
                
                signupLink
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Entendido")))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // Vista de fondo con imagen y degradado
    private var backgroundView: some View {
        ZStack {
            Image("loginbackground")
                .resizable()
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.125), Color.white.opacity(0.25)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 10)
        }
    }
    
    // Logo de la aplicación
    private var logoView: some View {
        Group {
            if let uiImage = UIImage(named: "papalotelogo") {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 120, height: 140)
                    .padding(.bottom, 60)
                    .padding(.leading, 120)
            } else {
                Text("Imagen no encontrada")
            }
        }
    }
    
    // Campos de entrada para correo y contraseña
    private var inputFields: some View {
        VStack(spacing: 25) {
            CustomTF(sfIcon: "at", hint: "Correo Electrónico", value: $emailID)
            CustomTF(sfIcon: "lock", hint: "Contraseña", isPassword: true, value: $password)
            Button("Olvidé mi contraseña") {
                // Implementar lógica de recuperación de contraseña aquí
            }
            .font(.callout)
            .fontWeight(.heavy)
            .tint(.brown)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    // Botón de inicio de sesión
    private var loginButton: some View {
        GradientButton(title: "Login", icon: "arrowshape.right.circle") {
            loginUser()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(emailID.isEmpty || password.isEmpty)
    }
    
    // Enlace para registro
    private var signupLink: some View {
        HStack(spacing: 6) {
            Text("¿No tienes una cuenta?")
                .foregroundStyle(.gray)
            Button("Regístrate") {
                showSignup.toggle()
            }
            .fontWeight(.bold)
            .tint(.brown)
        }
        .font(.callout)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // Función para hacer el login en Firebase
    private func loginUser() {
        Auth.auth().signIn(withEmail: emailID, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            } else {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    ContentView()
}

