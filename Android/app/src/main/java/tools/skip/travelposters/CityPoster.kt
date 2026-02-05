package tools.skip.travelposters

import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.ColorPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import coil3.request.ImageRequest
import travel.posters.model.City
import travel.posters.model.Weather
import kotlin.math.roundToInt

@Composable
fun CityPoster(city: City, isFavorite: () -> Boolean, setFavorite: (Boolean) -> Unit) {
    Box {
        val urlString = city.imageURL.toString()
        AsyncImage(
            model = ImageRequest.Builder(LocalContext.current)
                .data(urlString)
                .memoryCacheKey(urlString)
                .diskCacheKey(urlString)
                .build(),
            placeholder = ColorPainter(MaterialTheme.colorScheme.onBackground.copy(alpha = .2f)),
            contentDescription = city.name,
            contentScale = ContentScale.FillBounds,
            modifier = Modifier
                .aspectRatio(1f)
                .clip(RoundedCornerShape(20.dp))
        )

        Box(modifier = Modifier.matchParentSize()
            .clip(RoundedCornerShape(20.dp))
            .background(brush = Brush.verticalGradient(colors = listOf(Color.Transparent, Color.Transparent, Color.Black.copy(alpha = .4f))))
        )

        Column(modifier = Modifier
            .matchParentSize()
            .padding(8.dp)) {
            Spacer(modifier = Modifier.weight(1f))
            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                val isFavoriteState = rememberUpdatedState(isFavorite())
                Icon(imageVector = Icons.Filled.Star,
                    contentDescription = "Star",
                    tint = if (isFavoriteState.value) Color.Yellow else Color.White.copy(alpha = .5f),
                    modifier = Modifier.clickable {
                        setFavorite(!isFavoriteState.value)
                    }
                )
                Spacer(modifier = Modifier.weight(1f))
                Text(text = city.name,
                    style = MaterialTheme.typography.headlineMedium,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    modifier = Modifier.padding(8.dp)
                )
                Spacer(modifier = Modifier.weight(1f))
                Box {
                    val degrees = remember { mutableStateOf<Int?>(null) }
                    LaunchedEffect(city.id, degrees) {
                        try {
                            val c =
                                Weather.fetch(latitude = city.latitude, longitude = city.longitude).conditions.temperature
                            val f = c * (9.0 / 5.0) + 32.0
                            degrees.value = f.roundToInt()
                        } catch (exception: Exception) {
                            Log.e("TravelPosters", "Error fetching weather: $exception")
                        }
                    }
                    
                    // Use longer hidden text to maintain constant width when temp appears
                    Text(text = "999 °F", modifier = Modifier.alpha(0f))
                    if (degrees.value != null) {
                        Text(text = "${degrees.value} °F", color = Color.White)
                    }
                }
            }
        }
    }
}
