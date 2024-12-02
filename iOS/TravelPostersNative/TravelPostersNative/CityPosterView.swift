import SwiftUI
import TravelPostersModel

struct CityPosterView: View {
    let city: City
    @Binding var isFavorite: Bool
    @State var degrees: Int? = nil

    var body: some View {
        ZStack {
            AsyncImage(url: city.imageURL) { image in
                image.resizable().clipped()
            } placeholder: {
                Rectangle()
                    .fill(.primary.opacity(0.2))
            }
            .aspectRatio(1, contentMode: .fill)

            Rectangle()
                .fill(.linearGradient(colors: [.clear, .black.opacity(0.4)], startPoint: .center, endPoint: .bottom))

            VStack {
                Spacer()
                HStack {
                    Button(action: { isFavorite = !isFavorite }) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(isFavorite ? .yellow : .white.opacity(0.5))
                    }
                    Spacer()
                    Text(city.name).font(.title).bold()
                    Spacer()
                    ZStack {
                        // Use longer hidden text to maintain constant width when temp appears
                        Text("999 °F")
                            .opacity(0)
                        if let degrees {
                            Text("\(degrees) °F")
                        }
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
        }
        .cornerRadius(20)
        .task {
            do {
                let c = try await Weather.fetch(latitude: city.latitude, longitude: city.longitude).conditions.temperature
                let f = c * (9.0 / 5.0) + 32.0
                self.degrees = Int(f.rounded())
            } catch {
                print("Error fetching weather: \(error)")
            }
        }
    }
}
