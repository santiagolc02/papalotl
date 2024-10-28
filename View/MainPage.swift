//
//  MainPage.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 20/09/24.
//

import SwiftUI
import UIKit

struct MainPage: View {
    
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    @State var colorPred = ZonaColors.pertenezco
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                ZStack {
                    switch selectedTab {
                    case 0:
                        Home()
                    case 1:
                        Map()
                    case 2:
                        PasaporteDigital()
                    case 3:
                        Account(isLoggedIn: $isLoggedIn)
                    default:
                        Home()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85) // Ocupa el 85% de la pantalla
                
               
                ZStack {

                    CustomTabBarBackground(color: colorPred)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .shadow(radius: 5) // Aplica la sombra aquí
                        .edgesIgnoringSafeArea(.bottom) // Para cubrir el área inferior
                        .offset(y: 20) // Ajusta este valor para mover la barra más cerca del fondo

                    HStack {
                        Button(action: {
                            selectedTab = 0
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedTab == 0 ? .black : .gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = 1
                        }) {
                            Image(systemName: "map")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedTab == 1 ? .black : .gray)
                        }
                        
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            selectedTab = 2
                        }) {
                            Image(systemName: "magazine")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedTab == 2 ? .black : .gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = 3
                        }) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedTab == 3 ? .black : .gray)
                        }
                    }
                    .padding(.horizontal, 40) // Espaciado dentro de la barra
                    .offset(y: 20) // Mueve los íconos hacia abajo junto con la barra de navegación
                    
                    Button(action: {
                        selectedTab = 4 // Puedes asignar esta acción a otra funcionalidad
                    }) {
                        Image(systemName: "sensor.tag.radiowaves.forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(20)
                            .clipShape(Circle())
                    }
                    .offset(y: -30) // Eleva el botón sobre la barra de navegación
                }
                .frame(maxWidth: .infinity, maxHeight: 90)
                .edgesIgnoringSafeArea(.bottom) // Asegura que la barra de navegación cubra toda el área inferior
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom) // Asegura que el `VStack` cubra toda el área inferior
        }
        .background(Color.white.edgesIgnoringSafeArea(.all)) // Fondo blanco que cubre todo
    }
}

struct CustomTabBarBackground: View {
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let cutoutRadius: CGFloat = 40 // Radio del hueco en la barra de navegación
                
                // Dibujar el fondo con un hueco redondeado en el centro (que será blanco)
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width / 2 - cutoutRadius, y: 0))
                path.addArc(
                    center: CGPoint(x: width / 2, y: 0),
                    radius: cutoutRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

#Preview {
    ContentView()
}







