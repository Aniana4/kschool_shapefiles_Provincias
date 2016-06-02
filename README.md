#Ejercicio usando shapefiles y ggmap con provincias y datos de esperanza de vida
```r
install.packages("rgdal")
library(rgdal)
```
*Leemos el fichero de tipo shapefiles Provincias_ETR89_30N*
Dicho fichero lo he cargado de:
www.arcgis.com/home/item.html?id=83d81d9336c745fd839465beab885ab7
```r
provin <- readOGR(dsn = "Provincias", "Provincias_ETRS89_30N")
class(provin)
```
**leemos el excel Esperanza_de_vida.xls por provincias**
Descargado del ine

```r
EspeVida <- loadWorkbook('Esperanza_de_vida.xls', create = TRUE) 
EspeVida <- readWorksheet(EspeVida, sheet = 'tabla-1485')

slotNames(provin)
provin

head(provin@data)
head(EspeVida)
```
*Necesito una variable Codigo, que viene concatenado a la provincia, por lo tanto lo extraigo*
```r
EspeVida$Codigo <- substr(EspeVida$Provincia,1,2)
head(EspeVida)
```

*Uno los datos de la esperanza de vida, con los datos de las provincias*
```r
provin@data
Vida <- merge(provin@data,EspeVida)
provin@data$Vida <- Vida$EsperanzaVida
provin@data
```
*Vemos los graficos*
```r
plot(provin, col=provin$Vida)
spplot(provin, "Vida", colorRampPalette="blue")
provin
```
*Combino ggmap con shapefiles*
*Trata de combinar _shapefiles_ con `ggmap`*
```r
library(ggmap)
library(ggplot2)
library(maptools)
library(rgdal)
map <- get_map("spain", zoom=4, source="google",maptype = "roadmap")
mapa <- ggmap(map)
mapa

saphefile <- readOGR(dsn = "Provincias", "Provincias_ETRS89_30N")

sphefile1 <- spTransform(saphefile,CRS("+proj=longlat + datum=WGS84") )

saphefile2 <- fortify(sphefile1)
```
*Veo el mapa y lo guardo*
```r
png("PlotShapewithggmap.png")
mapa+geom_polygon(aes(x=long,y=lat,group=group),fill='grey',color='green',data=saphefile2,alpha=0)
dev.off()
```
