# 10_spatial_tools_with_r.R
# Professor Andrea Sanchez-Tapia
# 2022-07-26
# <https://scientific-computing.netlify.app/10_spatial_tools_with_r.html>




# INSTALLING NECESSARY PACKAGES ===================================
# Additional installation info on:
# <https://r-spatial.github.io/sf/>

install.packages("sf")
install.packages("ggplot2")
install.packages("tmap")
# outros pacotes uteis para lidar com arquivos .sf
# em R sao o "rnaturalearth" e o "rnaturalearthhires"
install.packages("rnaturalearth")
install.packages("remotes")
# remotes::install_github() permite que se instale
# pacotes diretamente de repositorios GitHub
remotes::install_github("ropensci/rnaturalearthhires")
library(raster)



# LOADING LIBRARIES ==============================================
library("sf")
library("ggplot2")
library("tmap")
library("dplyr")
library("raster")
library("rnaturalearth")
library("rnaturalearthhires")



# DEALING WITH .sf FILES ==========================================
# World eh um data.frame do tipo "sf"
# cujo geometry type eh do tipo MULTIPOLYGON
data(World)

# plotting
tm_shape(World) +
  tm_borders()

# evaluating .sf data properties
head(World[1:2,1:4])
names(World)
class(World)
dplyr::glimpse(World)
# coluna contendo as coordenadas dos poligonos
World$geometry
class(World$geometry)

# st_coordinates parece extrair os pontos iniciais e finais
# de cada linha do poligono
plot(sf::st_coordinates(World))

# st_drop_geometry transforma o "sf" object em um data.frame
# sem a coluna "geometry"
no_geom <- sf::st_drop_geometry(World)
attributes(no_geom)

# st_bbox retorna o bounding box do data.frame "sf"
# (i.e., os limites do mapa)
st_bbox(World)

# .sf files sao como data.frames ou tibbles comuns:
# voce pode filtrar, fazer subsetting, merging, joining,
# e criar novas entradas no dataset
# p.ex., vamos plotar apenas paises da America do Sul
# funcao unique() mostra quais sao os valores unicos
# encontrados em um vetor
unique(World$continent)

# O operador "%>%" tem funcao de piping em R
# Basicamente, o operador ordena que
# o objeto gerado antes do operador
# seja incluso como o primeiro argumento
# da funcao executada depois do operador
World %>%
  dplyr::filter(continent=="South America") %>%
  tmap::tm_shape() +
  tmap::tm_borders()

# Eh possivel criar novas colunas no dataset,
# cujo valor dependa do valor de colunas referencia
# ja presentes no dataset
# p.ex., eh possivel associar cores diferentes a linhas diferentes
# para colorir o mapa
# perceba que mutate serve para gerar colunas novas
# baseadas no valor de outras
World %>%
  dplyr::mutate(our_countries = if_else(iso_a3 %in% c("COL","BRA", "MEX"),
                                 "red",
                                 "grey")) %>%
  tmap::tm_shape() +
  tmap::tm_borders() +
  tmap::tm_fill(col = "our_countries") +
  tmap::tm_add_legend("fill",
                "Countries",
                col = "red")



# CONVERTING .shapefile OLD FORMATS =============================
# An old type of shapefile that will be deprecated soon
# is the ".sp" file
# To convert them to a "sf" file,
# you can use the "sf::st_as_sf()" function



# RNATURALEARTH PACKAGE ========================================
# rnaturalearth::ne_states permite que se plote
# apenas os polygons # referentes a estados administrativos
# de um pais
# Aparentemente, rnaturalearth discrimina
# polygons por levels administrativos:
# states parecem ser o level 1.
bra <- rnaturalearth::ne_states(country = "brazil",
                                returnclass = "sf")
plot(bra)

# para salvar um shapefile especifico
# (p.ex., um subset de interesse de um shapefile ja existente),
# pode se usar a funcao sf::st_write()
dir.create(path = "data/shapefiles",
           recursive = TRUE)
sf::st_write(obj = bra,
             dsn = "data/shapefiles/bra.shp")
# os arquivos criados sao quatro:
# .dbf - contem dados sobre cada polygon presente no shapefile
# .prj - contem dados sobre o coordinate reference system do mapa
# .shp - binario
# .shx - binario

# para reler um arquivo .sf
bra2 <- sf::read_sf(dsn = "data/shapefiles/bra.shp")



# DEALING WITH RASTER FILES =====================================
# Raster files sao arquivos de mapeamento
# que consistem em um espaco continuo
# dividido em cell grids
# O layer contendo os valores de interesse
# da um valor para cada celula do grid
# Eh possivel determinar um valor de resolucao
# para a celula, e os valores de cada celula nessa
# nova resolucao serao o resultado de uma operacao
# calculada pelo proprio raster
dir.create(path = "data/raster", recursive = TRUE)
tmax_data <- raster::getData(name = "worldclim",
                             var = "tmax",
                             res = 10,
                             path = "data/raster/",
                             int64_as_string = FALSE)
plot(tmax_data[[3]])

# evaluating raster data properties
dim(tmax_data)
extent(tmax_data)
res(tmax_data)




# TO OBTAIN ADDITIONAL INFO =============================================
# the vignettes of "sf" package
# tutorials in "rspatialdata" package
# CRAN TaskViews about spatial data
