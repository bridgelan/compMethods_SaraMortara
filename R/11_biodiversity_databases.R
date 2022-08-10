# 11_biodiversity_databases.R
# Professor Andrea Sanchez-Tapia
# 2022-07-27
# <https://scientific-computing.netlify.app/11_biodiversity_databases.html>


# INSTALLING PACKAGES ==========================================================
install.packages("rgbif", dependencies = TRUE)
install.packages("Taxonstand", dependencies = TRUE)
install.packages("CoordinateCleaner", dependencies = TRUE)
install.packages("maps", dependencies = TRUE)
install.packages("taxize", dependencies = TRUE)


# LOADING PACKAGES =============================================================
library(rgbif)
library(Taxonstand)
library(CoordinateCleaner)
library(maps)
library(dplyr)
library(tmap)
library(sf)

# GETTING THE DATA =======================================================
# occ_search busca por ocorrencias de GBIF relacionada
# as palavras chave passadas por argumento
# GBIF eh a sigla para "Global Biodiversity Information Facility"
# um banco de dados de biodiversidade internacional.
# No dia 2022-08-07, no site
# <https://www.gbif.org/occurrence/
# search?q=Myrsine%20coriacea&occurrence_status=present>,
# havia "285,587 results" para "Myrsine coriaceae".
# Os nomes de colunas das entradas GBIF
# seguem o standard DarwinCore (<https://dwc.tdwg.org/>).

species <- "Myrsine coriacea"
occs <- rgbif::occ_search(scientificName = species,
                          limit = 100000,
                          basisOfRecord = "PRESERVED_SPECIMEN")
names(occs)
glimpse(occs)

# occ_search$data contem informacoes sobre
# cada report de de uma especie
myrsine.data <- occs$data
names(myrsine.data)

# EXPORTING RAW DATA ===========================================================
# vamos salvar a tabela no seu formato inicial
# em "data/raw/"
dir.create("data/raw/", recursive = TRUE)
write.csv(myrsine.data,
          "data/raw/myrsine_data.csv",
          row.names = FALSE)



# CHECKING SPECIES TAXONOMY ====================================================
# perceba que uma mesma especie pode possuir
# varios sinonimos, vindo de informacao historica
sort(unique(myrsine.data$scientificName))
# a coluna taxonomicStatus mostra se um report
# foi feito com o nome mais recentemente aceito
# ou se ainda consta versoes antigas do nome da especie
table(myrsine.data$scientificName, myrsine.data$taxonomicStatus)

# vamos verificar se os nomes contidos nas entradas do GBIF
# estao atualizados para a ultima versao
# primeiro, geremos uma lista dos nomes unicos presentes no nosso dataset
species.names <- unique(myrsine.data$scientificName)

# agora, vamos verificar se os nomes das especies estao atualizados
# atraves do pacote Taxonstand,
# que retira os dados a partir do banco "The Plant List"
# <http://www.theplantlist.org/>.
# A funcao TPL retornara um dataframe informando
# se os nomes estao desatualizados
# (i.e., se nao estao com o nome atual da especie)
# ou se os nomes apresentam conflitos de identificacao
tax.check <- Taxonstand::TPL(species.names)

# Agora, estamos criando um novo data.frame
# com os nomes de especie devidamente corrigidos
new.tax <- data.frame(scientificName = species.names,
                      genus.new.TPL = tax.check$New.Genus,
                      species.new.TPL = tax.check$New.Species,
                      status.TPL = tax.check$Taxonomic.status,
                      scientificName.new.TPL = paste(tax.check$New.Genus,
                                                     tax.check$New.Species))

# agora podemos fundir o novo dataset com o antigo, atualizando os nomes
myrsine.new.tax <- merge(myrsine.data,
                         new.tax,
                         by = "scientificName")

# eh possivel checar se
# o novo e o antigo dataset tem o mesmo tamanho
# usando nrow()
nrow(myrsine.data)
nrow(myrsine.new.tax)

# EXPORTING DATA AFTER TAXONOMY CHECK ==========================================

dir.create("data/processed/", recursive = TRUE)
write.csv(myrsine.new.tax,
          "data/processed/data_taxonomy_check.csv",
          row.names = FALSE)

# CHECKING SPECIES COORDINATES =================================================
# Eh possivel inspecionar visualmente
# os dados de coordenada da especie.
# Perceba que a planta se distribui pela America do Sul e Central,
# mas ha pontos isolados no oceano Atlantico (o que parece ser um erro)
# o argumento "asp = 1"
plot(decimalLatitude ~ decimalLongitude,
     data = myrsine.data,
     asp = 1)
# quando se insere apenas as virgulas,
# eh o mesmo que aceitar os valores default da funcao
# nesse caso, eh
# database="World", regions = ".", exact = FALSE
map(, , , add = TRUE)


# entao, vamos comecar removendo os pontos
# em que uma das coordenadas eh igual a NA
# O numero cai bruscamente
# Esse processo eh exigido para que
# se use o pacote "CoordinateCleaner"
myrsine.coord <- myrsine.data[!is.na(myrsine.data$decimalLatitude)
                              & !is.na(myrsine.data$decimalLongitude),]

# feito isso, podemos verificar automaticamente as coordenadas
# o parametro value = "clean" faz com
# que sejam retornadas apenas as coordenadas
# que nao parecem suspeitas
# (ou seja, as entradas sem flagging)
# O problema eh que isso nao eh reprodutivel
geo.clean <- CoordinateCleaner::clean_coordinates(x = myrsine.coord,
                                                  lon = "decimalLongitude",
                                                  lat = "decimalLatitude",
                                                  species = "species",
                                                  value = "clean")

# eh possivel identificar que algumas entradas apresentaram alteracoes
table(myrsine.coord$country)
table(geo.clean$country)

# podemos agora inspecionar visualmente as diferencas
# perceba que as entradas suspeitas
# nos oceanos Indico e Atlantico somem
par(mfrow = c(1, 2))
plot(decimalLatitude ~ decimalLongitude,
     data = myrsine.data,
     asp = 1)
map(, , , add = TRUE)
plot(decimalLatitude ~ decimalLongitude,
     data = geo.clean,
     asp = 1)
map(, , , add = TRUE)
par(mfrow = c(1, 1))


# por conta da ausencia de reprodutibilidade no
# parametro value = "clean",
# o dataset processado que salvaremos
# devera incluir as entradas mesmo com flags
# Para tanto, o parametro correto eh
# value = "spatialvalid"
myrsine.new.geo <- CoordinateCleaner::clean_coordinates(x = myrsine.coord,
                                     lon = "decimalLongitude",
                                     lat = "decimalLatitude",
                                     species = "species",
                                     value = "spatialvalid")


#perceba que agora o dataset inclui
# as entradas dadas como falsas
table(myrsine.new.geo$.summary)
tail(names(myrsine.new.geo))


# agora podemos realizar o merging
# com o antigo dataset myrsine.data
dim(myrsine.data)
dim(myrsine.new.geo)
myrsine.new.geo2 <- merge(myrsine.data,
                          myrsine.new.geo,
                          all.x = TRUE,
                          by = "key")
dim(myrsine.new.geo2)
dplyr::full_join(myrsine.data, myrsine.new.geo)

# vamos realizar a inspecao visual
# do dataset antigo e o novo (limpo)
plot(decimalLatitude ~ decimalLongitude,
     data = myrsine.new.geo2,
     asp = 1,
     col = if_else(myrsine.new.geo2$.summary,
                   "green",
                   "red"))
maps::map(, , , add = TRUE)

# EXPORTING DATA AFTER COORDINATE CHECK ========================================
write.csv(myrsine.new.geo2,
          "data/processed/myrsine_coordinate_check.csv",
          row.names = FALSE)


# SAVE THE DATASET AS SHAPEFILE ================================================
myrsine.final <- dplyr::left_join(myrsine.coord,
                                  myrsine.new.geo2)
nrow(myrsine.final)

# gerando objeto "sf"
# perceba que as coordenadas de myrsine.final
# estao nas colunas decimalLatitude e decimalLongitude
# E lembre-se que as coordenadas em arquivos sf
# aparecem na coluna "geometry"
myrsine_sf <- sf::st_as_sf(myrsine.final,
                           coords = c("decimalLongitude",
                                      "decimalLatitude"))

# verificando qual CRS esta associado ao objeto
sf::st_crs(myrsine_sf)
# determinando o CRS a ser utilizado
myrsine_sf <- sf::st_set_crs(myrsine_sf,
                         4326)
sf::st_crs(myrsine_sf)

# gravando no disco
dir.create("data/shapefiles",
           recursive = TRUE)

# a funcao seguinte esta dando erro
# o problema eh que alguns dados codificados
# estao sendo lidos como headers de coluna, p.ex.,
# [517] "X.3aee7756.565e.4dc5.b22c.f997fbd7105c..y"
# Eh um problema que vem desde myrsine_data
# Aparentemente, essa coluna contem caracteres nao gravaveis
# em um shapefile

# Deleting layer `myrsine' using driver `ESRI Shapefile'
# Writing layer `myrsine' to data source
# `data/shapefiles/myrsine.shp' using driver `ESRI Shapefile'
# Writing 1888 features with 531 fields and geometry type Point.
# Unknown field name `X_4b08_7504_424_9349_63860197_': updating a layer with improper field name(s)?
#   Error in CPL_write_ogr(obj, dsn, layer, driver, as.character(dataset_options),  :
#                            Write error
#                          Além disso: Warning message:
#                            In abbreviate_shapefile_names(obj) :
#                            Field names abbreviated for ESRI Shapefile driver

sf::st_write(myrsine_sf,
         dsn = "data/shapefiles/myrsine.shp",
         append = FALSE)

# PLOT WITH TMAP ===============================================================
data(World)

SAm_map <- World %>%
  dplyr::filter(continent %in% c("South America", "North America")) %>%
  tmap::tm_shape() +
  tmap::tm_borders()


SAm_map +
  tmap::tm_shape(myrsine_sf) +
  tmap::tm_bubbles(size = 0.2,
                   col = ".summary")

# INTERACTIVE MODE IN TMAP =====================================================

tmap_mode("view")
World %>%
  filter(continent %in% c("South America", "North America")) %>%
  tm_shape() +
  tm_borders() +
  tm_shape(myrsine_sf) +
  tm_bubbles(size = 0.2)
