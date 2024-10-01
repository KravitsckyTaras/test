import SwiftUI

// Структура для представлення секції з полями
struct InputFieldSection: Identifiable, Codable {
    var id = UUID() // Генеруємо новий UUID при ініціалізації
    var fields: [String]
    var selectedExerciseName: String?
    var selectedImage: String?
}

// Структура для представлення вправ
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct DetailView: View {
    @Binding var selectedExerciseName: String?
    @Binding var selectedImage: String?

    @Environment(\.presentationMode) var presentationMode

    let exercises: [Exercise] = [
        Exercise(name: "Присідання", imageName: "1"),
        Exercise(name: "Випади", imageName: "2"),
        Exercise(name: "Підтягування", imageName: "3"),
        Exercise(name: "Віджимання", imageName: "1"),
        Exercise(name: "Прес", imageName: "2"),
        Exercise(name: "Жим лежачи", imageName: "3"),
        Exercise(name: "Тяга", imageName: "1"),
        Exercise(name: "Станова тяга", imageName: "2"),
        Exercise(name: "Мертва тяга", imageName: "3"),
        Exercise(name: "Біцепс", imageName: "1"),
        Exercise(name: "Трицепс", imageName: "2"),
        Exercise(name: "Планка", imageName: "3")
    ]

    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(exercises) { exercise in
                    VStack {
                        Button(action: {
                            selectedExerciseName = exercise.name
                            selectedImage = exercise.imageName
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(exercise.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        }
                        Text(exercise.name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(width: 100)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Вправи")
    }
}

struct ContentView: View {
    @State private var inputFields: [InputFieldSection] = []
    @State private var showingSaveAlert = false
    @State private var showingLoadAlert = false

    var body: some View {
        
        NavigationView {
            ZStack {
                Image("listBumagy")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    ScrollView {
                        VStack {
                            ForEach($inputFields) { $section in
                                VStack {
                                    Text(section.selectedExerciseName ?? "Вправа")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.black.opacity(0.2))
                                        .shadow(radius: 5)
                                    
                                    HStack {
                                        VStack(spacing: 10) {
                                            HStack(spacing: 10) {
                                                ForEach(0..<4, id: \.self) { index in
                                                    TextField("Вага", text: Binding(
                                                        get: { section.fields.indices.count > index ? section.fields[index] : "" },
                                                        set: { newValue in
                                                            if section.fields.indices.count > index {
                                                                section.fields[index] = newValue
                                                            } else {
                                                                section.fields.append(newValue)
                                                            }
                                                        }
                                                    ))
                                                    .frame(width: 60, height: 40)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(8)
                                                    .keyboardType(.decimalPad)
                                                    .shadow(radius: 5)
                                                }
                                            }
                                            HStack(spacing: 10) {
                                                ForEach(0..<4, id: \.self) { index in
                                                    TextField("Повтореня", text: Binding(
                                                        get: { section.fields.indices.count > (index + 4) ? section.fields[index + 4] : "" },
                                                        set: { newValue in
                                                            if section.fields.indices.count > (index + 4) {
                                                                section.fields[index + 4] = newValue
                                                            } else {
                                                                section.fields.append(newValue)
                                                            }
                                                        }
                                                    ))
                                                    .frame(width: 60, height: 40)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(8)
                                                    .keyboardType(.decimalPad)
                                                    .shadow(radius: 5)
                                                }
                                            }
                                        }
                                        NavigationLink(destination: DetailView(selectedExerciseName: $section.selectedExerciseName, selectedImage: $section.selectedImage)) {
                                            if let imageName = section.selectedImage {
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .background(Color.gray.opacity(0.2))
                                                    .cornerRadius(8)
                                                    .shadow(radius: 5)
                                            } else {
                                                Image("0")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .background(Color.gray.opacity(0.2))
                                                    .cornerRadius(8)
                                                    .shadow(radius: 5)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            HStack {
                                
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.black)
                                    .padding(.top, 50)
                                    .onTapGesture {
                                        inputFields.append(InputFieldSection(fields: Array(repeating: "", count: 8), selectedExerciseName: nil, selectedImage: nil))
                                    }
                                
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.red)
                                    .padding(.top, 50)
                                    .onTapGesture {
                                        if !inputFields.isEmpty {
                                            inputFields.removeLast()
                                        }
                                    }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        ZStack(alignment: .leading) {
                            // Фон, який покриває всю ширину екрану з додатковими 100 пікселями
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.2)) // Колір фону тулбару
                                .frame(width: UIScreen.main.bounds.width + 100, height: 44) // Ширина фону більша на 100 пікселів
                                .edgesIgnoringSafeArea(.top) // Ігнорування безпечної зони

                            // Контент тулбару
                            HStack(spacing: 15) { // Між іконками буде 20 пікселів
                                NavigationLink(destination: ContentView()) {
                                    Image(systemName: "house") // Іконка для переходу на домашню сторінку
                                        .font(.headline)
                                        .foregroundColor(.black) // Чорний колір іконки
                                }
                                Button(action: {
                                    showingSaveAlert = true // Показати алерт для вибору дня збереження
                                }) {
                                    Image(systemName: "square.and.arrow.down") // Іконка для збереження
                                        .font(.headline)
                                        .foregroundColor(.black) // Чорний колір іконки
                                }
                                .alert("Виберіть день для збереження", isPresented: $showingSaveAlert) {
                                    Button("День 1") { saveData(for: "День 1") }
                                    Button("День 2") { saveData(for: "День 2") }
                                    Button("День 3") { saveData(for: "День 3") }
                                    Button("День 4") { saveData(for: "День 4") }
                                    Button("День 5") { saveData(for: "День 5") }
                                    Button("День 6") { saveData(for: "День 6") }
                                    Button("День 7") { saveData(for: "День 7") }
                                    Button("Скасувати", role: .cancel) {}
                                }
                                
                                Button(action: {
                                    showingLoadAlert = true // Показати алерт для вибору дня завантаження
                                }) {
                                    Image(systemName: "arrow.down.circle") // Іконка для завантаження
                                        .font(.headline)
                                        .foregroundColor(.black) // Чорний колір іконки
                                }
                                .alert("Виберіть день для завантаження", isPresented: $showingLoadAlert) {
                                    Button("День 1") { loadData(for: "День 1") }
                                    Button("День 2") { loadData(for: "День 2") }
                                    Button("День 3") { loadData(for: "День 3") }
                                    Button("День 4") { loadData(for: "День 4") }
                                    Button("День 5") { loadData(for: "День 5") }
                                    Button("День 6") { loadData(for: "День 6") }
                                    Button("День 7") { loadData(for: "День 7") }
                                    Button("Скасувати", role: .cancel) {}
                                }
                            }
                            .padding(.leading, 60) // Відступ у 10 пікселів від лівого бортику екрана
                        }
                    }
                }

                    
                

            }
        }
    }

    func saveData(for day: String) {
        if let encoded = try? JSONEncoder().encode(inputFields) {
            UserDefaults.standard.set(encoded, forKey: day)
        }
    }

    func loadData(for day: String) {
        if let data = UserDefaults.standard.data(forKey: day),
           let decoded = try? JSONDecoder().decode([InputFieldSection].self, from: data) {
            inputFields = decoded
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
