library(shinythemes)

ui <- fluidPage(theme = shinytheme("cyborg"),
  mainPanel(
    titlePanel("One Stop Center for Principal Component Analysis(PCA)"),
        
        tabsetPanel(
          
          tabPanel("Introduction",
                   
                   h1("WHAT IS PRINCIPAL COMPONENT ANALYSIS?"),
                   p("Principal Component Analysis, or PCA, is a dimensionality-reduction method that is often used to reduce the dimensionality of large data sets, by transforming a large set of variables into a smaller one that still contains most of the information in the large set.
                     Reducing the number of variables of a data set naturally comes at the expense of accuracy, but the trick in dimensionality reduction is to trade a little accuracy for simplicity. Because smaller data sets are easier to explore and visualize and make analyzing data much easier and faster for machine learning algorithms without extraneous variables to process.
                     So to sum up, the idea of PCA is simple — reduce the number of variables of a data set, while preserving as much information as possible."
                     ,style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                   h3("Main Idea behind PCA:"),
                   p("Variance synonymous with amount of information, more variance ==> more info.PCA determines principal components (or high variance components) and projects data to a new subspace which is in the direction of these components.",
                     style="color:black;background-color:lavender;padding:15px;border-radius:10px"),
                   p("Eigen vectors of the covariance matrix represent the directions in which data varies the most.
                     Eigen values tell us the amount of variance in each of these directions.
                     A d-dimensional dataset corresponds to at most d eigen values/vectors (some may repeat). "
                     
                     ,style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px")
                   
                   
                   
          ), # end  tab 
          tabPanel("Data input", 
                   p("Before uploading your data, check that it is clean, especially ensure that the the numeric variables contain only the digits 0-9 or NA (to indicate missing data)."),
                   p("Rows that contain one or more NAs will be excluded from the PCA."),
                   p("Columns that contain a mixture of numbers and text will not be included in the computation of the PCA results."),
                   p("Have a look at the ", a("iris.csv", href = "https://raw.githubusercontent.com/benmarwick/Interactive_PCA_Explorer/master/iris.csv"),  " file included with this app to see what a clean CSV file looks like."),
                   tags$hr(),
                   p("Select the options that match your CSV file, then upload your file:"),
            
                
                   radioButtons(inputId = 'header',  
                                label = 'Header',
                                choices = c('Columns have headers'='Yes',
                                            'Columns do not have headers'='No'), 
                                selected = 'Yes'),
          
                   radioButtons('sep', 'Separator',
                                c(Comma=',',
                                  Semicolon=';',
                                  Tab='\t'),
                                ','),
          
                   radioButtons('quote', 'Quote',
                                c(None='',
                                  'Double Quote'='"',
                                  'Single Quote'="'"),
                                '"'),
                   
                   tags$hr(),
                   
                   fileInput('file1', 'Choose a CSV file to upload:',
                             accept = c(
                               'text/csv',
                               'text/comma-separated-values',
                               'text/tab-separated-values',
                               'text/plain',
                               '.csv',
                               '.tsv'
                             )),
                   p("After uploading your CSV file, click on the 'Inspect the data' tab")
                   
                 ), # end file  tab
          
         
          
          
          tabPanel("Correlation Plots",
                   uiOutput("choose_columns_biplot"),
                   tags$hr(),
                   p("This plot may take a few moments to appear when analysing large datasets. You may want to exclude highly correlated variables from the PCA."),
                   
                   plotOutput("corr_plot"),
                   tags$hr(),
                   p("Summary of correlations"),
                   tableOutput("corr_tables")
          ), # end  tab
          
         # tabPanel("Diagnostics",
                   
                   #p("Among SPSS users, these tests are considered to provide some guidelines on the suitability of the data for a principal components analysis. However, they may be safely ignored in favour of common sense. Variables with zero variance are excluded."),
                   #tags$hr(),
                   #p("Here is the output of Bartlett's sphericity test. Bartlett's test of sphericity tests whether the data comes from multivariate normal distribution with zero covariances. If p > 0.05 then PCA may not be very informative"),
                   #verbatimTextOutput("bartlett"),
                   #tags$hr(),
                   #p("Here is the output of the Kaiser-Meyer-Olkin (KMO) index test. The overall measure varies between 0 and 1, and values closer to 1 are better. A value of 0.6 is a suggested minimum. "),
                   #verbatimTextOutput("kmo")
                   
                   
                   
          #), # end  tab
          
          tabPanel("Compute PCA",
                   
                   p("Choose the columns of your data to include in the PCA."),
                   p("Only columns containing numeric data are shown here because PCA doesn't work with non-numeric data."),
                   p("The PCA is automatically re-computed each time you change your selection."),
                   p("Observations (ie. rows) are automatically removed if they contain any missing values."),
                   p("Variables with zero variance have been automatically removed because they're not useful in a PCA."),
                   uiOutput("choose_columns_pca"),
                   tags$hr(),
                   p("Select options for the PCA computation (we are using the prcomp function here)"),
                   radioButtons(inputId = 'center',  
                                label = 'Center',
                                choices = c('Shift variables to be zero centered'='Yes',
                                            'Do not shift variables'='No'), 
                                selected = 'Yes'),
                   
                   radioButtons('scale.', 'Scale',
                                choices = c('Scale variables to have unit variance'='Yes',
                                            'Do not scale variables'='No'), 
                                selected = 'Yes')
                   
          ), # end  tab
          

      
          tabPanel("PC Plots",
                   h2("Scree plot"),
                   p("The scree plot shows the variances of each PC, and the cumulative variance explained by each PC (in %) "),
                   plotOutput("plot2", height = "300px"),
                   tags$hr(),
                   h2("PC plot: zoom and select points"),
                   p("Select the grouping variable."),
                   p("Only variables where the number of unique values is less than 10% of the total number of observations are shown here (because seeing groups with 1-2 observations is usually not very useful)."),
                   uiOutput("the_grouping_variable"),
                   tags$hr(),
                   p("Select the PCs to plot"),
                   uiOutput("the_pcs_to_plot_x"),
                   uiOutput("the_pcs_to_plot_y"),
                   tags$hr(),
                   
                   p("Click and drag on the first plot below to zoom into a region on the plot. Or you can go directly to the second plot below to select points to get more information about them."),
                   p("Then select points on zoomed plot below to get more information about the points."),
                   p("You can click on the 'Compute PCA' tab at any time to change the variables included in the PCA, and then come back to this tab and the plots will automatically update."),
                   plotOutput ("z_plot1", height = 400,
                               brush = brushOpts(
                                 id = "z_plot1Brush",
                                 resetOnNew = TRUE)),
                   tags$hr(),
                   
                   p("Click and drag on the plot below to select points, and inspect the table of selected points below"),

                   plotOutput("z_plot2", height = 400,
                              brush = brushOpts(
                                id = "plot_brush_after_zoom",
                                resetOnNew = TRUE)),
                   tags$hr(),
                   p("Details of the brushed points"),
                   tableOutput("brush_info_after_zoom")
          ), # end  tab 
          

          
          tabPanel("PCA output",
                   verbatimTextOutput("pca_details")
                   
          )
          
          
          ))) 