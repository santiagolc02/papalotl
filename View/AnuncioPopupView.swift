//
//  AnuncioPopupView.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 22/10/24.
//

import SwiftUI

struct AnuncioPopupView: View {
    var anuncio: Anuncio
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Fondo translúcido para dar el efecto de superposición
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            // Contenido del popup
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text(anuncio.titulo)
                            .font(FontHelper.apercuProBold(size: 30))
                            .padding(.top, 20)
                        
                        Text(anuncio.descripcion)
                            .font(FontHelper.apercuProRegular(size: 18))
                            .padding(.horizontal)
                        
                        Button(action: {
                            isPresented = false // Cerrar el popup
                        }) {
                            Text("Cerrar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(ZonaColors.pertenezco)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .frame(width: 350, height: 450)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    AnuncioPopupView(anuncio: Anuncio(id: "1", titulo: "Prueba", descripcion: "Descripción de prueba"), isPresented: .constant(true))
}
