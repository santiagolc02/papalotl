//
//  PasaporteDigital.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 21/09/24.
//


import SwiftUI
import FirebaseFirestore
import Firebase

struct PasaporteDigital: View {
    @StateObject var viewModel = ActividadesViewModel()

    @State var listaZonas = ["Pertenezco", "Comunico", "Expreso", "Comprendo", "Soy"]
    @State var zonaSeleccionada = "Pertenezco"
    @State var colorZona = ZonaColors.pertenezco
    @State var transitioningColor = ZonaColors.pertenezco
    @State var transitionInProgress: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.actividadesCargadas {  // Solo mostramos las vistas cuando las actividades están cargadas
                VStack {
                    PasaporteDigitalPageCurlView(
                        pages: createPages(),
                        zonaSeleccionada: $zonaSeleccionada,
                        colorZona: $colorZona,
                        transitioningColor: $transitioningColor,
                        transitionInProgress: $transitionInProgress
                    )
                    .frame(height: 525)

                    // Indicadores de página (las bolitas)
                    pageIndicators
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .offset(y: -15)

                    Spacer()
                }
                .offset(y: 100)

                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(transitionInProgress ? transitioningColor : colorZona)
                        .animation(.easeInOut(duration: 0.4), value: transitioningColor)
                        .frame(height: 175)
                        .shadow(radius: 10)
                        .ignoresSafeArea(edges: .top)

                    Text("Pasaporte")
                        .font(FontHelper.apercuProBold(size: 40))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 42)
                        .padding(.top, 20)
                        .foregroundStyle(.white)
                }
                .frame(height: 150)
                .zIndex(1)
                .offset(y: -50)
                .ignoresSafeArea(edges: .top)
            } else {
                // Pantalla de carga mientras se obtienen las actividades
                VStack {
                    ProgressView("Cargando actividades...")
                        .progressViewStyle(CircularProgressViewStyle(tint: ZonaColors.pertenezco))
                        .scaleEffect(2.0)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            viewModel.loadActividades()
        }
    }

    // Genera las páginas para cada zona
    func createPages() -> [UIViewController] {
        let pages = [
            UIHostingController(rootView: ZonaContentView(zona: "Pertenezco", colorZona: ZonaColors.pertenezco, actividades: viewModel.actividadesPertenezco)),
            UIHostingController(rootView: ZonaContentView(zona: "Comunico", colorZona: ZonaColors.comunico, actividades: viewModel.actividadesComunico)),
            UIHostingController(rootView: ZonaContentView(zona: "Expreso", colorZona: ZonaColors.expreso, actividades: viewModel.actividadesExpreso)),
            UIHostingController(rootView: ZonaContentView(zona: "Comprendo", colorZona: ZonaColors.comprendo, actividades: viewModel.actividadesComprendo)),
            UIHostingController(rootView: ZonaContentView(zona: "Soy", colorZona: ZonaColors.soy, actividades: viewModel.actividadesSoy))
        ]
        return pages
    }

    // Indicadores personalizados de páginas (bolitas)
    private var pageIndicators: some View {
        HStack {
            ForEach(listaZonas, id: \.self) { zona in
                Circle()
                    .fill(zona == zonaSeleccionada ? colorZona : Color.gray)
                    .frame(width: 10, height: 10)
            }
        }
        .frame(maxWidth: .infinity)
    }
}




struct ZonaContentView: View {
    var zona: String
    var colorZona: Color
    var actividades: [String]

    var body: some View {
        VStack {
            NavigationLink(destination: ZonaView(zonaNombre: zona)) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorZona)
                    .frame(width: 325, height: 50)
                    .overlay(
                        Text(zona)
                            .font(FontHelper.apercuProBold(size: 25))
                            .foregroundColor(.white)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    Text("Actividades")
                        .font(FontHelper.apercuProBlack(size: 20))
                        .fontWeight(.bold)
                        .frame(width: 325, height: 25)

                    Divider()
                        .frame(width: 350, height: 1)
                        .background(Color.gray.opacity(0.1))

                    if actividades.isEmpty {
                        Text("No hay actividades para esta zona")
                            .font(FontHelper.apercuProLight(size: 17))
                    } else {
                        ForEach(actividades, id: \.self) { actividad in
                            actividadRow(for: actividad)
                        }
                    }
                }
                .padding(.top, 15)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.bottom, 30)
        .onAppear {
            print("Actividades para la zona \(zona): \(actividades)")
        }
    }

    private func actividadRow(for actividad: String) -> some View {
        HStack {
            Text(actividad)
                .font(FontHelper.apercuProLight(size: 17))
                .padding(.vertical, 30)
                .padding(.horizontal, 10)

            Spacer()

            Circle()
                .fill(colorZona)
                .frame(width: 50, height: 50)
        }
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 70)
                .padding(.horizontal, 10)
        )
    }
}



struct PasaporteDigitalPageCurlView: UIViewControllerRepresentable {
    var pages: [UIViewController]
    @Binding var zonaSeleccionada: String
    @Binding var colorZona: Color
    @Binding var transitioningColor: Color
    @Binding var transitionInProgress: Bool

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        // Aquí se puede manejar la actualización de las vistas cuando cambian los datos
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PasaporteDigitalPageCurlView

        init(_ parent: PasaporteDigitalPageCurlView) {
            self.parent = parent
        }

        // Página anterior
        func pageViewController(_ pageViewController: UIPageViewController,
                                viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.pages.firstIndex(of: viewController) else { return nil }
            let previousIndex = index - 1
            return previousIndex < 0 ? nil : parent.pages[previousIndex]
        }

        // Página siguiente
        func pageViewController(_ pageViewController: UIPageViewController,
                                viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.pages.firstIndex(of: viewController) else { return nil }
            let nextIndex = index + 1
            return nextIndex >= parent.pages.count ? nil : parent.pages[nextIndex]
        }

        // Cambia el color conforme a la transición
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            guard let pendingVC = pendingViewControllers.first,
                  let index = parent.pages.firstIndex(of: pendingVC) else { return }
            
            let zonas = ["Pertenezco", "Comunico", "Expreso", "Comprendo", "Soy"]
            let newColor = ZonaColors.colorForZona(zonas[index])

            parent.transitioningColor = newColor
            parent.transitionInProgress = true // Marca que la transición ha comenzado
        }

        // Cuando se completa o cancela la transición
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                                previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let viewController = pageViewController.viewControllers?.first,
               let index = parent.pages.firstIndex(of: viewController) {
                let zonas = ["Pertenezco", "Comunico", "Expreso", "Comprendo", "Soy"]
                parent.zonaSeleccionada = zonas[index]
                parent.colorZona = parent.transitioningColor
            }
            parent.transitionInProgress = false // Marca que la transición ha terminado
        }
    }
}

#Preview {
    PasaporteDigital()
}


















