# Rodrigo Almeida
# November 21 2016


source("helpers.R")  # have the helper functions avaiable

library(shiny)
library(magrittr)
library(formattable)
library(shinyjs)
library(dplyr)

cDatRaw <- getData()


shinyServer(function(input, output, session) {
	
	# =========== BUILDING THE INPUTS ===========
	
	# Create select box input for choosing visualization types
	output$visualizationCategoryUi <- renderUI({
		selectizeInput("categoryType", "",
									 levels(as.factor(cDatRaw$category)),
									 selected = NULL, multiple = TRUE,
									 options = list(placeholder = "Select Visualization category"))
	})	
	
	
	
	# ============== MANIPULATE THE DATA ================

	# The dataset to show/plot, which is the raw data after filtering based on
	# the user inputs
	cDat <- reactive({
		# Add dependency on the update button (only update when button is clicked)
		input$updateBtn	

	  # If the app isn't fully loaded yet, just return the raw data 
		if (!dataValues$appLoaded) {
			return(cDatRaw)
		  
		}
		data <- cDatRaw
		
		
		# Add all the filters to the data based on the user inputs
		# wrap in an isolate() so that the data won't update every time an input
		# is changed
		isolate({
			# Filter cancer types
			if (input$subsetType == "specific" & !is.null(input$categoryType)) {
				data %<>%
					filter(category %in% input$categoryType)
			}
		})
		data
	})
	
	# The data to show in a table, which is essentially the same data as above
	# with all the filters, but formatted differently:
	# - Format the numbers to look better in a table
	# - Change the data to wide/long format (the filtered data above is long)
	cDatTable <- reactive({
	  data <- cDat()
		
		if (!is.null(data)) {
		  data %<>% select(name:updating_frequency)		
		}
		  
		
		data
	})
	
	
	# The data to show in a table, which is essentially the same data as above
	# with all the filters, but formatted differently:
	# - Format the numbers to look better in a table
	# - Change the data to wide/long format (the filtered data above is long)
	cDatTableScore <- reactive({
	  
	  data <- cDat()
	  if (!is.null(data)) {
	    data %<>% select(name,score)
	  }
	  
	  data
	})
	
  
	cDatTableURL <- reactive({
	  data <- cDat()
	  if (!is.null(data)) {
	    data %<>% select(name,url)
	  }
	    
	   	
	  data
	})	
	
	# ============= TAB TO SHOW DATA IN TABLE ===========
	
	# Show the data in a table
	output$dataTable <- renderFormattable({
	  getGraficoTable(cDatTable())
	  })
	  
	# Show the data in a table
	output$dataTableURL <- renderFormattable({
	  getGraficoURL(cDatTableURL())
	})
	
	# Show the data in a table
	output$dataTableScore <- renderFormattable({
	  getGraficoScore(cDatTableScore())
	})	
	
	# Allow user to download the data, simply save as csv
	output$downloadData <- downloadHandler(
		filename = function() { 
			"rvismenu.csv"
		},
		
		content = function(file) {
			write.table(x = cDatTable(),
									file = file,
									quote = FALSE, sep = ",", row.names = FALSE)
		}
	)	
	
	
	
	# ========== LOADING THE APP ==========
	
	# We need to have a quasi-variable flag to indicate when the app is loaded
	dataValues <- reactiveValues(
		appLoaded = FALSE
	)
	
	# Wait for the years input to be rendered as a proxy to determine when the app
	# is loaded. Once loaded, call the javascript funtion to fix the plot area
	# (see www/helper-script.js for more information)
	observe({
		if (dataValues$appLoaded) {
			return(NULL)
		}
	  
	  if(!is.null(input$categoryType)) {
	    dataValues$appLoaded <- TRUE
	  }
	})
	
	# Show form content and hide loading message
	hide("loadingContent")
	show("allContent")
})
