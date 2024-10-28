//
//  QuizZona.swift
//  PapalotePrueba
//
//  Created by Acker Enif Saldaña Polanco on 22/10/24.
//

import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
}

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var progress: CGFloat = 0.0
    @State private var selectedOption: String? = nil
    @State private var selectedColors: [String] = [] // Para almacenar los colores seleccionados
    @State private var showResult = false // Para mostrar la pantalla de resultados
    @State private var selectedImage: String? = nil // Para almacenar el nombre de la imagen seleccionada
    @State private var animateImage = false // Estado para animar la imagen
    @State private var typingZoneText = "" // Para el efecto typing del nombre de la zona
    @State private var typingText = "" // Para el efecto typing del texto de la descripción
    @State private var fullZoneText = "" // Texto completo para el nombre de la zona
    @State private var fullDescription = "" // Texto completo para la descripción
    @State private var typingIndex = 0 // Índice para la animación de typing
    
    // Colores definidos en el orden solicitado
    let buttonColors: [Color] = [
        Color(red: 0/255, green: 170/255, blue: 228/255),  // Celeste
        Color.purple,   // Morado
        Color.orange,   // Naranja
        Color.red,      // Rojo
        Color.green,    // Verde
        Color.blue      // Azul
    ]
    
    let colorNames = ["Celeste", "Morado", "Naranja", "Rojo", "Verde", "Azul"]
    
    // Preguntas del Quiz
    let questions = [
            QuizQuestion(question: "De estos colores ¿cuál es el que más te gusta?", options: ["Celeste", "Morado", "Naranja", "Rojo", "Verde", "Azul"]),
            QuizQuestion(question: "¿Qué género de película prefieres más?", options: ["Ciencia Ficción", "Fantasía", "Acción", "Comedia", "Animadas", "Cualquier género está bien"]),
            QuizQuestion(question: "¿Qué le dirías a tu niño interior?", options: [
                "Comprenderte a ti mismo es el primer paso para comprender a los demás",
                "Gracias por esta aventura, ahora me toca vivir una nueva",
                "La flor que florece en la adversidad es la más rara y hermosa de todas",
                "Sabes que en caso de no tener música de fondo, tú puedes crear la tuya",
                "Tienes una voz única, y el mundo necesita escucharla",
                "No todas las decisiones tienen que ser perfectas, a veces lo que importa es intentarlo"
            ]),
            QuizQuestion(question: "¿Con qué frase te identificas más?", options: [
                "Lo que conocemos es una gota, lo que no conocemos es un océano (Isaac Newton)",
                "La vida es un lienzo en blanco, y debes lanzar sobre él toda la pintura que puedas. (Danny Kaye)",
                "Eres lo que haces, no lo que dices que harás (Carl Jung)",
                "Cuando cambiamos la forma en que nos comunicamos, cambiamos la sociedad (Clay Shirky)",
                "Todas las personas mayores fueron al principio niños, aunque pocas lo recuerdan. (Antoine de Saint-Exupéry)",
                "Mira profundamente en la naturaleza y entonces comprenderás todo mejor (Albert Einstein)"
            ]),
            QuizQuestion(question: "¿Qué pasatiempo prefieres?", options: [
                "Experimentar cosas nuevas",
                "Convivir en familia",
                "Disfrutar de la naturaleza",
                "Escuchar música",
                "Ver redes sociales",
                "Ir de compras"
            ]),
            QuizQuestion(question: "¿Cuál es tu género musical favorito?", options: [
                "Rock", "Pop", "Clásica", "Regional Mexicano", "Disfruto todos", "Electrónica"
            ]),
            QuizQuestion(question: "¿Cuál tema te gusta más?", options: [
                "Educación Física", "Biología", "Español", "Química", "Arte", "Matemáticas"
            ])
        ]
    
    var body: some View {
        VStack {
            if showResult {
                resultView
            } else {
                quizView
            }
        }
        .padding()
    }
    
    // Vista para las preguntas del Quiz
    var quizView: some View {
        VStack {
            Text(questions[currentQuestionIndex].question)
                .font(FontHelper.apercuProBold(size: 25))
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal)
            
            // Barra de progreso fija justo debajo de la pregunta
            ProgressView(value: progress, total: 1.0)
                .padding(.horizontal)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .animation(.linear(duration: 0.5), value: progress)
            
            Spacer()
            
            VStack {
                ForEach(questions[currentQuestionIndex].options.indices, id: \.self) { index in
                    Button(action: {
                        handleOptionSelection(index: index)
                    }) {
                        Text(questions[currentQuestionIndex].options[index])
                            .padding()
                            .font(FontHelper.apercuProRegular(size: 18))
                            .frame(maxWidth: .infinity)
                            .background(buttonColors[index % buttonColors.count])
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            }
            
            Spacer()
        }
    }
    
    // Vista para los resultados
    var resultView: some View {
        VStack {
            Spacer()
            
            if let selectedImage = selectedImage {
                Image(selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(y: animateImage ? 0 : 100)
                    .opacity(animateImage ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.5)) {
                            animateImage = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            startTypingZoneText()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            startTypingAnimation()
                        }
                    }
            }
            
            // Nombre de la zona con efecto typing
            Text(typingZoneText)
                .font(FontHelper.apercuProBold(size: 30))
                .bold()
                .padding(.top, 20)
                .frame(height: 30)
            
            // Descripción con efecto typing
            Text(typingText)
                .font(FontHelper.apercuProRegular(size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 200)
            
            Spacer()
        }
    }
    
    // Manejar la selección de opción y avanzar
    func handleOptionSelection(index: Int) {
        selectedColors.append(colorNames[index])
        nextQuestion()
    }
    
    // Avanzar a la siguiente pregunta
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            progress = CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count)
        } else {
            showResult = true
            determineImage()
        }
    }
    
    // Determinar el nombre de la zona según el color más seleccionado
    func determineZoneName() -> String {
        let colorCount = selectedColors.reduce(into: [:]) { counts, color in
            counts[color, default: 0] += 1
        }
        
        let mostFrequentColor = colorCount.max { a, b in a.value < b.value }?.key ?? "Indeterminado"
        
        switch mostFrequentColor {
        case "Azul": return "Comunico"
        case "Verde": return "Pertenezco"
        case "Celeste": return "Pequeños"
        case "Rojo": return "Soy"
        case "Morado": return "Comprendo"
        case "Naranja": return "Expreso"
        default: return "Indeterminado"
        }
    }
    
    // Determinar la descripción de la zona
    func determineZoneDescription() -> String {
        let colorCount = selectedColors.reduce(into: [:]) { counts, color in
            counts[color, default: 0] += 1
        }
        
        let mostFrequentColor = colorCount.max { a, b in a.value < b.value }?.key ?? "Indeterminado"
        
        switch mostFrequentColor {
        case "Azul":
            return "Para ti el diálogo es lo más importante. Eres bastante fuerte con tus emociones y no dudas en alzar la voz cuando algo no te parece justo."
        case "Verde":
            return "Tienes una profunda conexión con la naturaleza. Eres una persona tranquila, pero serías capaz de explorar el mundo."
        case "Celeste":
            return "Tienes una alma de niño, jamás dejas de asombrarte. Para ti el explorar el mundo es una fuente de felicidad."
        case "Rojo":
            return "No le temes al deber ni a los retos más complicados. Eres alguien honesto que busca mejorar con cada error que comete."
        case "Morado":
            return "Aparentas una personalidad seria pero en realidad eres alguien interesante que siempre tiene algo bueno por decir."
        case "Naranja":
            return "Eres una persona muy creativa, amas todo tipo de arte y fluyes con cada una de ellas."
        default:
            return "Indeterminado"
        }
    }
    
    // Determinar la imagen según la zona
    func determineImage() {
        let colorCount = selectedColors.reduce(into: [:]) { counts, color in
            counts[color, default: 0] += 1
        }
        
        let mostFrequentColor = colorCount.max { a, b in a.value < b.value }?.key ?? "Indeterminado"
        
        switch mostFrequentColor {
        case "Azul": selectedImage = "comunico"
        case "Rojo": selectedImage = "soy"
        case "Verde": selectedImage = "pertenezcologo"
        case "Celeste": selectedImage = "pequeños"
        case "Morado": selectedImage = "comprendo"
        case "Naranja": selectedImage = "expreso"
        default: selectedImage = "indeterminado"
        }
        
        fullDescription = determineZoneDescription()
        fullZoneText = determineZoneName()
    }
    
    // Iniciar la animación de typing para la zona
    func startTypingZoneText() {
        typingZoneText = ""
        typingIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if typingIndex < fullZoneText.count {
                let index = fullZoneText.index(fullZoneText.startIndex, offsetBy: typingIndex)
                typingZoneText += String(fullZoneText[index])
                typingIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    // Iniciar la animación de typing para la descripción
    func startTypingAnimation() {
        typingText = ""
        typingIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if typingIndex < fullDescription.count {
                let index = fullDescription.index(fullDescription.startIndex, offsetBy: typingIndex)
                typingText += String(fullDescription[index])
                typingIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}















