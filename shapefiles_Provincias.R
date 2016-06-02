#install.packages("rgdal")
library(rgdal)
provin <- readOGR(dsn = "Provincias", "Provincias_ETRS89_30N")
class(provin)

#Excel con la esperanza de vida por provincias
EspeVida <- loadWorkbook('Esperanza_de_vida.xls', create = TRUE) 
EspeVida

EspeVida <- readWorksheet(EspeVida, sheet = 'tabla-1485')
EspeVida

# Un objeto de la clase S4 tiene _slots_, que son, abusando del lenguaje, las _variables_ 
# del objeto.

slotNames(provin)
provin
# Típicamente, la más importante es `data`.

head(provin@data)
head(EspeVida)

EspeVida$Codigo <- substr(EspeVida$Provincia,1,2)
head(EspeVida)
#plot(provin)

provin@data
Vida <- merge(provin@data,EspeVida)
provin@data$Vida <- Vida$EsperanzaVida
provin@data

plot(provin, col=provin$Vida)
spplot(provin, "Vida", colorRampPalette="blue")
provin

##### Ejercicio (avanzado) 
# Trata de combinar _shapefiles_ con `ggmap`
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

png("PlotShapewithggmap.png")
mapa+geom_polygon(aes(x=long,y=lat,group=group),fill='grey',color='green',data=saphefile2,alpha=0)
dev.off()
