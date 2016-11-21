# Rodrigo Almeida

# Helper functions for the cancer-data shiny app

library(magrittr)
library(gsheet)
library(formattable)
library(dplyr)

DATA_DIR <- file.path("data")

# Read the data and get it ready for the app
getData <- function() {
  # Get the raw data
  cDatRaw <- as.data.frame(gsheet2tbl('docs.google.com/spreadsheets/d/11OPE1_YiA8mEtFLy20mJyO2SQEggiD8Qc-oFgwNa9AE'))
  
  cDatRaw
}

getURL <- function(df, nameParam) {
  filter(df, name == nameParam)$url
}

# Retorna grafico para visualizar lista de visualizacoes R
getGrafico <- function(df) {
  saida <-
    formattable(df, list(
      name = formatter("span", style = x ~ style(tooltiptext  = getURL(df,x))),
      relevance = formatter("span", style = x ~ ifelse( (x == "very high" || x == "high")   , 
                                                       style(color = "green", font.weight = "bold"), 
                                                       style(color = "red", font.weight = "bold"))),
      updating_frequency = formatter("span", style = x ~ ifelse(x == "constantly", 
                                                   style(color = "green", font.weight = "bold"), 
                                                   style(color = "red", font.weight = "bold"))),
      area(col = score) ~ normalize_bar("pink", 0.2),
      shiny_integration = formatter("span",
                             style = x ~ style(color = ifelse(x, "green", "red")),
                             x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
    ))

  saida
}



# Retorna grafico para visualizar lista de visualizacoes R
getGraficoTable <- function(df) {
  saida <-
    formattable(df, list(
      relevance = formatter("span", style = x ~ ifelse( (x == "very high" || x == "high"), 
                                                        style(color = "green", font.weight = "bold"), 
                                                        style(color = "red", font.weight = "bold"))),
      
      updating_frequency = formatter("span", style = x ~ ifelse(x == "constantly", 
                                                                style(color = "green", font.weight = "bold"), 
                                                                style(color = "red", font.weight = "bold")))
    ))
  
  saida
}


# Retorna grafico para visualizar lista de visualizacoes R
getGraficoURL <- function(df) {
  saida <-
    formattable(df, list(
      name = formatter("span", style = x ~ style(tooltiptext  = getURL(df,x)))
    ))
  
  saida
}


# Retorna grafico para visualizar lista de visualizacoes R
getGraficoScore <- function(df) {
  saida <-
    formattable(df, list(
      area(col = score) ~ normalize_bar("pink", 0.2)
    ))
  
  saida
}

getWideDataSet <- function(df) {
  
  #colnames(cDatRaw)
  #[1] "name"               "category"           "js_lib"             "relevance"          "licence"           
  #[6] "updating_frequency" "url"                "shiny_integration"  "score"       
  df[,c(-7)]
  
}

# Our data has 22 cancer types, so when plotting I wanted to have a good
# set of 22 unique colours
getPlotCols <- function() {
	c22 <- c("dodgerblue2","#E31A1C", # red
					 "green4",
					 "#6A3D9A", # purple
					 "#FF7F00", # orange
					 "black","gold1",
					 "skyblue2","#FB9A99", # lt pink
					 "palegreen2",
					 "#CAB2D6", # lt purple
					 "#FDBF6F", # lt orange
					 "gray70", "khaki2", "maroon", "orchid1", "deeppink1", "blue1",
					 "darkturquoise", "green1", "yellow4", "brown")
	c22
}
