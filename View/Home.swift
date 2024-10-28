//
//  Home.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 21/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Home: View {
    
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State var colorZona = ZonaColors.pertenezco
    
    @State private var anuncios: [Anuncio] = []
    
    @State private var selectedAnuncio: Anuncio? = nil
    @State private var isShowingPopup = false
    
    var body: some View {
        ZStack {
            // Vista principal de Home
            VStack {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.clear)
                        .frame(height: 200)
                        .background(
                            Image("spacebanner")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        )
                        .ignoresSafeArea(edges: .top)
                        .cornerRadius(25)
                        .offset(y: -90)
                        .shadow(radius: 5)
                    
                    HStack {
                        Text("¡Bienvenido!")
                            .font(FontHelper.apercuProBold(size: 30))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 30)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                                .frame(width: 120, height: 120)
                                .padding()
                                .shadow(radius: 7, x: 0, y: 2)
                            
                            Image("pandita")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                        }
                        .offset(x: 20)
                        
                        Text("Hola, \(userName)")
                            .font(FontHelper.apercuProBold(size: 20))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 60)
                    }
                    .padding()
                    .padding(.top)
                }
                
                ScrollView(.vertical) {
                    VStack(spacing: 5) {
                        
                        Text("Anuncios")
                            .font(FontHelper.apercuProLight(size: 20))
                        Divider()
                            .padding(.horizontal, 30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                // Mostrar un RoundedRectangle por cada anuncio
                                ForEach(anuncios) { anuncio in
                                    Button(action: {
                                        self.selectedAnuncio = anuncio
                                        self.isShowingPopup = true // Mostrar el popup
                                    }) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(ZonaColors.pertenezco.opacity(0.2))
                                            .frame(width: 250, height: 225)
                                            .background(
                                                    Image("anuncio1")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 250, height: 225)
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .clipped()
                                                )
                                            .overlay(
                                                Image("gradient_black")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 250, height: 225)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                    .clipped()
                                                    .opacity(0.9)
                                            )
                                        
                                            /*
                                            .overlay(
                                                    Rectangle() .fill(Color.cyan) .frame(height: 50) // ajustar height
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .clipped()
                                                    .padding(.bottom, 0), alignment: .bottom
                                                )
                                            */
                                            .overlay(
                                                VStack(alignment: .leading) {
                                                    Spacer()
                                                    HStack {
                                                        Text(anuncio.titulo)
                                                            .font(FontHelper.apercuProRegular(size: 20))
                                                            .foregroundColor(.white)
                                                        Spacer()
                                                    }
                                                    
                                                }
                                                .padding()
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(height: 250) // Ajusta la altura según sea necesario
                        
                        // Contenido adicional
                        VStack(spacing: 20) {
                            Text("¿Qué área del museo te representa mejor?")
                                .font(FontHelper.apercuProLight(size: 18))

                            NavigationLink(destination: QuizView()) {
                                Text("¡Ir al quiz!")
                                    .font(FontHelper.apercuMonoBold(size: 18))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(ZonaColors.pertenezco)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                        
                        
                    }
                    .padding(.top, 20) // Separación con el contenido superior
                    
                }
                .offset(y: -40)
            }
            
            // Fondo opaco detrás del popup que cubre toda la pantalla, incluida la Tab Bar
            if isShowingPopup {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all) // Asegura que cubre todo, sin dejar márgenes
                    .transition(.opacity) // Transición suave
                    .zIndex(2) // Asegúrate de que esté sobre todo
            }
            
            // Si isShowingPopup es verdadero, mostramos el popup
            if isShowingPopup, let anuncio = selectedAnuncio {
                AnuncioPopupView(anuncio: anuncio, isPresented: $isShowingPopup)
                    .transition(.opacity) // Transición para aparecer y desaparecer
                    .zIndex(3) // Aseguramos que esté sobre la vista de Home y el fondo opaco
            }
        }
        .onAppear {
            loadUserData()
            loadAnuncios() // Cargar anuncios de Firestore
        }
    }
    
    // Función para cargar los datos del usuario autenticado
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "Correo no disponible"
            userName = user.displayName ?? "Nombre no disponible"
        } else {
            userEmail = "No hay un usuario autenticado"
            userName = "Invitado"
        }
    }
    
    // Función para cargar los anuncios desde Firestore
    func loadAnuncios() {
        let db = Firestore.firestore()
        db.collection("anuncios").getDocuments { snapshot, error in
            if let error = error {
                print("Error al cargar los anuncios: \(error)")
            } else {
                anuncios = snapshot?.documents.compactMap { document -> Anuncio? in
                    let data = document.data()
                    let id = document.documentID
                    let titulo = data["tituloAnuncio"] as? String ?? "Sin título"
                    let descripcion = data["descripcionAnuncio"] as? String ?? "Sin descripción"
                    return Anuncio(id: id, titulo: titulo, descripcion: descripcion)
                } ?? []
            }
        }
    }
}

// Modelo de Anuncio
struct Anuncio: Identifiable {
    var id: String
    var titulo: String
    var descripcion: String
}

#Preview {
    ContentView()
}




