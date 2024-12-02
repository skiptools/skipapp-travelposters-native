import SwiftUI
import TravelPostersModel

struct CityListView: View {
    @State var cityManager = CityManager.shared

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
                ForEach(cityManager.allCities) { city in
                    CityPosterView(city: city, isFavorite: favoriteBinding(for: city))
                }
            }
            .padding()
        }
    }

    func favoriteBinding(for city: City) -> Binding<Bool> {
        Binding(get: {
            cityManager.favoriteIDs.contains(city.id)
        }, set: { isFavorite in
            if isFavorite && !cityManager.favoriteIDs.contains(city.id) {
                cityManager.favoriteIDs.append(city.id)
            } else if !isFavorite {
                cityManager.favoriteIDs.removeAll(where: { $0 == city.id })
            }
        })
    }
}
