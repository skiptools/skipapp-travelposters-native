package tools.skip.travelposters

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import travel.posters.model.CityManager

@Composable
fun CityList(padding: PaddingValues) {
    val cityManager = CityManager.shared
    LazyVerticalGrid(columns = GridCells.Adaptive(minSize = 300.dp),
        contentPadding = padding,
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        for (city in cityManager.allCities) {
            item {
                CityPoster(city, isFavorite = { cityManager.favoriteIDs.contains(city.id) }, setFavorite = { isFavorite ->
                    val favoriteIDs = cityManager.favoriteIDs.toMutableList()
                    if (isFavorite && !favoriteIDs.contains(city.id)) {
                        favoriteIDs.add(city.id)
                        cityManager.favoriteIDs = favoriteIDs
                    } else if (!isFavorite) {
                        favoriteIDs.remove(city.id)
                        cityManager.favoriteIDs = favoriteIDs
                    }
                })
            }
        }
    }
}