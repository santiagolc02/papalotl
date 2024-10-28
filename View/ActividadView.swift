//
//  ActividadView.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 18/10/24.
//

import SwiftUI

struct ActividadView: View {
    
    @State var colorZona = ZonaColors.pertenezco
    @Environment(\.presentationMode) var presentationMode // Para regresar a la página anterior

    var body: some View {
        VStack {
            // El encabezado o título de la actividad
            Text("Actividad")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 100)
                .shadow(radius: 5)
            
            Spacer()
            
            // Descripción con ScrollView y botón
            ScrollView {
                VStack(spacing: 20) {
                    // Descripción de la actividad
                    Text("OASHDOIAHSODIHAOHDASHDOAHSDIOHASODHAOSD AQUI VA LA DESCRIPCION HIJOS DE PUTA")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 10)
                    
                    // Botón para regresar dentro del ScrollView
                    Button(action: {
                        // Acción para regresar a la página anterior
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Regresar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(colorZona)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20) // Asegura espacio adicional al final del ScrollView
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .shadow(radius: 10) // Agrega sombra para realzar el recuadro blanco
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que el ScrollView ocupe el espacio disponible

            Spacer()
        }
        .background(colorZona) // Color de fondo
        .ignoresSafeArea() // Para que el fondo cubra toda la pantalla, incluyendo las áreas seguras
    }
}

#Preview {
    ActividadView()
}


