//
//  ZonaView.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 18/10/24.
//

import SwiftUI
import FirebaseFirestore

struct ZonaView: View {
    @Environment(\.presentationMode) var presentationMode // Para regresar a la página anterior
    @State var zonaNombre = "Expreso" // Nombre de la zona seleccionada
    @State var zonaDescripcion = "" // Campo para la descripción de la zona
    @State var colorZona = ZonaColors.pertenezco // Color predeterminado (puedes actualizar si tienes un campo de color)
    @State var imagenZona = "pertenezco"
    @State var iconoZona = "pertenezcologo" // Icono inicial
    @State var quoteZona = "" // Campo para el quote de la zona
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.clear) // Fondo transparente para el rectángulo
                    .frame(height: 200) // Altura ajustable según el diseño
                
                    .background(
                        Image("pertenezco")
                            .resizable()
                            .scaledToFill() // Asegura que la imagen cubra el espacio disponible
                            .clipped() // Recorta el contenido de la imagen
                    )
                    .overlay(
                        Color.black.opacity(0.6) // Superposición negra con opacidad
                    )
                    .cornerRadius(25)
                    .ignoresSafeArea(edges: .top) // Ignorar el área segura superior
                    .shadow(radius: 10)
                
                // Contenido blanco (icono y texto) dentro del rectángulo verde
                HStack(spacing: 10) {
                    // Texto dentro de la zona
                    Text(zonaNombre)
                        .font(FontHelper.apercuProBold(size: 40))
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .shadow(radius: 10)
                    
                }
                .padding(.horizontal, 20) // Añade espacio lateral
                .padding(.top, 100) // Ajusta el espaciado superior según el diseño
            }
            
            Spacer()
            
            // Descripción con scroll
            ScrollView {
                
                HStack{
                    Image(iconoZona) // Usa el logo de la zona
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .padding()
                        .offset(x: 20)
                    
                    Text("\(quoteZona)") // Quote de la zona
                        .padding(.horizontal, 20)
                        .font(FontHelper.apercuMonoBold(size: 20))
                }
                
                VStack(spacing: 20) {
                    // Descripción de la actividad
                    Text(zonaDescripcion) // Descripción completa de la zona
                        .font(FontHelper.apercuProRegular(size: 18))
                        .padding()
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .frame(maxHeight: .infinity)
            
            // Botón para regresar
            Button(action: {
                // Acción para regresar a la página anterior
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Regresar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(colorZona) // Usamos el color de la zona
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 50)
        }
        .background(Color(red: 255/255, green: 254/255, blue: 249/255)) // Fondo de pantalla
        .ignoresSafeArea() // Para que el fondo cubra toda la pantalla
        .onAppear {
            loadZonaData() // Carga los datos de Firebase cuando la vista aparece
            cambiarIconoZona() // Llama a la función para actualizar el icono en la vista
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Función para cargar datos desde Firebase
    func loadZonaData() {
        let db = Firestore.firestore()
        
        // Busca el documento de la zona por su nombre (ej. "Pertenezco")
        db.collection("zona").document(zonaNombre).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.zonaNombre = data?["nombreZona"] as? String ?? "Sin nombre"
                self.zonaDescripcion = data?["descripcionZona"] as? String ?? "Sin descripción"
                self.quoteZona = data?["quoteZona"] as? String ?? "Sin quote"
                cambiarIconoZona() // Actualiza el icono después de cargar los datos
            } else {
                print("El documento no existe: \(error?.localizedDescription ?? "Error desconocido")")
            }
        }
    }
    
    // Función para cambiar el icono según la zona
    func cambiarIconoZona(){
        if zonaNombre == "Pertenezco" {
            iconoZona = "pertenezcologo"
        } else if zonaNombre == "Soy" {
            iconoZona = "soy"
        }
        else if zonaNombre == "Comunico" {
            iconoZona = "comunico"
        }
        else if zonaNombre == "Expreso" {
            iconoZona = "expreso"
        }
        else if zonaNombre == "Comprendo" {
            iconoZona = "comprendo"
        }
    }
}

#Preview {
    ZonaView()
}






