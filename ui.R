# Rodrigo Almeida - rodrigo.almeida@gmail.com
# Novembro de 2016

# This is the ui portion of a shiny app shows cancer data in the United States

library(shiny)
library(shinyjs)
library(formattable)

share <- list(
  title = "RVisMenu - Menu of Visualizations for R Solutions",
  url = "http://daattali.com/shiny/cancer-data/",
  ## TODO: Mudar a imagem de apresentacao do app
  image = "http://daattali.com/shiny/img/cancer.png",
  description = "Presents some packages to visualize data to R solutions",
  twitter_user = "lojadedados"
)



fluidPage(
  useShinyjs(),
  title = "RVisMenu - Menu de Visualizacoes para Solucoes em R",
  
  # add custom JS and CSS
  singleton(
    tags$head(
      includeScript(file.path('www', 'google-analytics.js')),
      includeScript(file.path('www', 'message-handler.js')),
      includeScript(file.path('www', 'helper-script.js')),
      includeCSS(file.path('www', 'style.css')),
      ## Mudar o icone do App
      #tags$link(rel = "shortcut icon", type="image/x-icon", href="http://daattali.com/shiny/img/favicon.ico"),
      # Facebook OpenGraph tags
      tags$meta(property = "og:title", content = share$title),
      tags$meta(property = "og:type", content = "website"),
      tags$meta(property = "og:url", content = share$url),
      tags$meta(property = "og:image", content = share$image),
      tags$meta(property = "og:description", content = share$description),
    
      # Twitter summary cards
      tags$meta(name = "twitter:card", content = "summary"),
      tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
      tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
      tags$meta(name = "twitter:title", content = share$title),
      tags$meta(name = "twitter:description", content = share$description),
      tags$meta(name = "twitter:image", content = share$image)
    )
  ),
  tags$a(
    href = "https://github.com/lojadedados/rvismenu",
    tags$img(style = "position: absolute; top: 0; right: 0; border: 0;",
             src = "github-green-right.png",
             alt = "Fork me on GitHub")
  ),
	
	# enclose the header in its own section to style it nicer
	div(id = "headerSection",
		h1("RVisMenu - R Visualizations"),
	
		# author info
		span(
      style = "font-size: 1.2em",
#			span("Developed by "),
#			a("Rodrigo Almeida (rodrigo.almeida@gmail.com)", href = "https://lojadedados.github.io/"),
#			HTML("&bull;"),
			span("Code"),
			a("on GitHub", href = "https://github.com/lojadedados/rvismenu"),
                        HTML("&bull;"),
                        a("More apps", href = "https://github.com/lojadedados"), "by Loja de Dados",
			br(),
      span("A subset of the available R Visualization Packages. Feel free to contribute and suggest another R Vis packages."),
      br(),
			span("Novembro, 2016")
		)
	),
	
	# show a loading message initially
	div(
		id = "loadingContent",
		h2("Loading...")
	),	
	
	# all content goes here, and is hidden initially until the page fully loads
	hidden(div(id = "allContent",
		
		# sidebar - filters for the data
		sidebarLayout(
			sidebarPanel(
				h3("Filter R Visualizations Packages", style = "margin-top: 0;"),

				# show all the cancers or just specific types?
				selectInput(
					"subsetType", "",
					c("Show all Category" = "all",
						"Select specific category" = "specific"),
					selected = "all"),
				
				# which visualization category to show
				conditionalPanel(
					"input.subsetType == 'specific'",
					uiOutput("visualizationCategoryUi")
				), br(),
				

				# button to update the data
				shiny::hr(),
				actionButton("updateBtn", "Update Data"),

				br(),br(),br(),
				downloadButton("downloadData", "Download table"),
				br(), br(),				
				
				# footer - where the data was obtained
				br(), br(), br(), br(),
				p("This Shiny App was Developed by ",
					a("Loja de Dados",
						href = "https://lojadedados.github.io/",
						target = "_blank")),
				a(img(src = "LOGOPNG.png", alt = "Loja de Dados"),
					href = "https://lojadedados.github.io/",
					target = "_blank")
			),
			
			# main panel has two tabs - one to show the data, one to plot it
			mainPanel(wellPanel(
				tabsetPanel(
					id = "resultsTab", type = "tabs",
					
					# tab showing the data in table format
					tabPanel(
						title = "Overall", id = "tableTab",
					

						br(),
						
						##tableOutput("dataTable")
            formattableOutput("dataTable")
					),
					# Another tab with more info
					tabPanel(
					  title = "URL", id = "tableURL",
					  
					  br(),
					  br(),
					  
					  ##tableOutput("dataTable")
					  formattableOutput("dataTableURL")
					),	
          #last tab with scores
					tabPanel(
					  title = "Score", id = "tableScore",
					  br(),
					  br(),
					  ##tableOutput("dataTable")
					  formattableOutput("dataTableScore")
					)					
										
				)
			))
		)
	))
)
