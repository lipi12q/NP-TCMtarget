library(shiny)
library(shinydashboard)
library(dplyr)
library(reticulate)
library(WebGestaltR)
source("helper_function.R",encoding = "UTF-8")

ui<-dashboardPage(
  
  dashboardHeader(title = em(h3(strong('NP-TCMtarget'))),
                  titleWidth = 300),
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     menuItem(strong("Homepage",style = "font-size: 16px;"), tabName = 'homepage', icon = icon('home')),
                     menuItem(strong('DETP',style = "font-size: 16px;"), tabName = 'datasubmit', icon = icon('arrow-circle-up')),
                     menuItem(strong('DBTP',style = "font-size: 16px;"), tabName = 'datasubmit1', icon = icon('arrow-circle-up')),
                     menuItem(strong('DTMP',style = "font-size: 16px;"), tabName = 'datasubmit2', icon = icon('arrow-circle-up')),
                     menuItem(strong('Results',style = "font-size: 16px;"), tabName = 'dataresults',icon = icon('file')),
                     menuItem(strong('User guide',style = "font-size: 16px;"), tabName = 'userguide', icon = icon('book'))
                   )),
  dashboardBody(
    
    tabItems(    
      tabItem(tabName = 'homepage',
              fluidPage(
                box(
                  # title = h3(strong('Transcriptome-based Multi-scale Network Pharmacological Platform')),
                  width = 200,
                  h1(strong('Network pharmacology based TCM direct and indirect target prediction'), align = "center"),
                  br(),
                  br(),
                  # h2("Specific gene module pair"),
                  p("NP-TCMtarget is a network pharmacology platform for exploring mechanisms of action of TCM at the molecular target level. The core conception of NP-TCMtarget is to untangle the intricate relationship between TCM drugs and targets, 
                    identify direct targets that directly bind with TCM components to produce biological effects and indirect targets that mediate the effects of direct targets in the biological molecular network, and finally explore the path of “herbal components-direct targets-indirect targets-biological effects”."),                  
                ),
                
                
                box( width = 200,
                    br(),              
                     img(src="figure0.jpg",style = "display: block; margin: 0 auto;", height = 190, width = 644
                     ),
                    br(),
                     p("Drug target classification: Direct targets are those that bind to the drug and are responsible for the biological effects of the drug. Indirect targets are those that mediate the biological effects of the drug but not bind to the drug. By interact with its direct targets or sequentially modulate its indirect targets through cellular signal transduction, the drug plays its pharmacological action, such as changing the expression of some genes or changing some phenotypes.")),
                
                box( width = 200,
                    br(),
                     img(src="figure.jpg",style = "display: block; margin: 0 auto;",height = 620,width = 542
                     ),),
                box(
                  width = 200,
                  h3(strong('Contact us')),
                  p('Prof. Li Peng'),
                  p('Address: Shanxi Agricultural University, Taigu 030801, Jinzhong, China'),
                  p('E-mail: lip@sxau.edu.cn')
                )
              )
      ),
      tabItem(tabName = 'datasubmit',
              fluidRow(
                box(
                  title = 'Input',
                  status = 'primary',
                  fileInput("file1", "Uploading transcriptional profile data",
                            multiple = TRUE,
                            accept = c("text/csv",
                                       "text/comma-separated-values,text/plain",
                                       ".csv")),
                  helpText("The upload data should be a csv file of gene list 
                             with metrics (e.g. differntial values), the first column is gene name and the other columns are values. More details can be found in the user guide."),
                  # width = 10,
                  solidHeader = TRUE
                  
                ),
                
                box(
                  title = 'DETP analysis',
                  status = 'primary',
                  # h3("Multi-scale analysis"),
                  actionButton("Target_gene_action", label = "DETP"),
                  solidHeader = TRUE
                )
                
              ),
              
              fluidRow( 
                box(
                  title = 'Input data',
                  status = 'primary',
                  tableOutput("data"),
                  width = 10
                )
              )
      ),
      tabItem(tabName = 'datasubmit1',
              fluidRow(
                box(title = "Input",
                    status = "primary",
                    fileInput("file2","Uploading SMILES information of drugs",
                              multiple = T,
                              accept = c("text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")),
                    helpText("The uploaded file should be a csv file containing the SMILES information of drugs. For specific details, please refer to the user guide."),
                    solidHeader =T
                ),
                box(
                  title = 'DBTP analysis',
                  status = 'primary',
                  actionButton("smile_action",label = "DBTP"),
                  solidHeader = TRUE
                ),
                
              ),
              
              fluidRow( 
                box(
                  title = 'Input data',
                  status = 'primary',
                  tableOutput("data1"),
                  width = 16
                )
              )
      ),
      tabItem(tabName = 'datasubmit2',
              fluidRow(
                box(title = "Input",
                    status = "primary",
                    fileInput("file3","Uploading effect targets",
                              multiple = T,
                              accept = c("text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")),
                    helpText("The uploaded file should contain effect targets that have been filtered after DETP calculations. For specific details, please refer to the user guide."),
                    solidHeader =T
                ),
                box(
                  title = 'enrichDatabase',
                  status = 'primary',
                  selectInput("variable", "Variable:",
                              c("KEGG" = "pathway_KEGG",
                                "Reactome" = "pathway_Reactome",
                                "Gene Ontology" = "geneontology_Biological_Process"
                                )),
                  solidHeader = TRUE
                )                
              ),
              fluidRow( 
                box(title = "Input",
                    status = "primary",
                    fileInput("file4","Uploading binding targets",
                              multiple = T,
                              accept = c("text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")),
                    helpText("The uploaded file should contain binding targets that have been filtered after DBTP calculations. For specific details, please refer to the user guide."),
                    solidHeader =T
                ),
                box(
                  title = 'DTMP analysis',
                  status = 'primary',
                  
                  actionButton("path_analyse",label = "DTMP"),
                  solidHeader = TRUE
                )
              )
              
      ),
      tabItem(tabName = 'dataresults',
              fluidPage(
                tabsetPanel(
                  
                  tabPanel("DETP",
                           box(
                             width = 200,
                             downloadButton("downloadData1", "Download")
                           ),
                           box(
                             width = 200,
                             tableOutput("targetdata")
                           )
                  ),
                  
                  tabPanel("DBTP",
                           box(width = 200,
                               downloadButton("downloadData", "Download")),
                           box(width = 200,
                               tableOutput(outputId = "combinedata")
                           )),
                  tabPanel("DTMP",
                           box(width = 200,
                               downloadButton("downloadData2", "Download")),
                           box(width = 200,div(style = "overflow-y: scroll; height: 700px;",
                                               tableOutput(outputId = "pathway_link")
                           )
                           ))
                  
                )
              )
              
              # box(
              #   title = h3(strong('Transcriptome-based Multi-scale Network Pharmacological Platform')),
              #   width = 200,
              # 
              #   tableOutput("resultdata")
              #  
              # ),
              # box(
              #   title = h3(strong('Transcriptome-based Multi-scale Network Pharmacological Platform')),
              #   width = 200,
              #   
              #   tableOutput("resultdata")
              #   
              # )
              # )
      ),
      tabItem(tabName = 'userguide',
              
              fluidPage(
                box(
                  width = 200,
                  h1(strong("User guide"), align = "center"),      
                  
                  p("NP-TCMtarget includes three main modules: drug effect target prediction based on the drug induced gene expression data (DETP), drug binding target prediction using the deep learning model (DBTP), and drug target mapping on signaling pathways (DTMP).",style = "font-size: 15px;"),
                  
                  
                  h2("Target classification"),
                  
                  p("To elucidate the complexity of the interactions between drug and biological targets, we divide the relevant targets for the effects of drug into two categories: direct and indirect targets. Direct targets are those that directly bind with the drug to produce biological effects. Indirect targets are the subsequent targets influenced by the direct targets in the biological molecular network. Consequently, direct targets should be the intersection of binding targets (targets that structurally bind with the drug) and effect targets (targets that mediate the biological effects of the drug). Indirect targets are the remaining targets in the effect targets after excluding the direct targets.",style = "font-size: 15px;"),
                                   
                  img(src="figure0.jpg", style = "display: block; margin: 0 auto;",height = 190, width = 644),
                  br(),                                  
                  img(src="example2.jpg", style = "display: block; margin: 0 auto;",height = 160, width = 347),
                  
                  h2("Drug effect target prediction"),              
                                    
                  p("The aim of DETP is to predict drug effect targets based on the gene expression data. Specifically, DETP has built a library of target specific signatures for 8,233 targets derived from four types of gene expression data induced by four types of perturbations: compound, shRNA, CRISPR and OE. Then using gene expression data induced by drugs or diseases as query, DETP can evaluate the effects of drugs on targets by measuring the correlation between the drug/disease inducible gene expression profiles and target signatures using the association algorithm derived from GSEA. 
DETP estimates the impact of the drug or disease on each target by the resultant normalized effect target score (NETS) and the corresponding false discovery rate (FDR), which are calculated based on the correlation between the gene expression profiles and the catalog of target signatures. Generally, those targets with FDR ≤ 0.05 are regarded as potential effect targets of the query drug or disease. More importantly, the sign (positive or negative) of NETS values reflect different action modes on the target. If the drug and disease have opposite NETS values for the same targets, the drug has the potential to treat the disease by these targets. Therefore, by comparing the effect targets of the drug and the disease, we can obtain the therapeutic targets that may play beneficial effects in the drug treatment for the disease. When utilizing DETP, users are only required to upload some differential metrics (e.g., the Signal2Noise or fold change values between drug-treated vs. control samples).
",style = "font-size: 15px;"),
                  
                  h2("Drug binding target prediction"),
                  
                  p("DBTP has constructed a deep learning drug-target interaction prediction model based on the DeepPurpose framework and the drug-target interaction dataset from DrugBank, which can be utilized to predict the binding probability between chemical ingredients of herbs and targets. The predicted targets with binding scores above a threshold value are regarded as potential binding targets of herbal ingredients. Generally, those targets with binding score ≥ 0.90 are regarded as potential binding targets of the herbal ingredients. We can compare effect targets to binding targets of herbs and obtain direct targets of herbs which are the intersection of effect targets and binding targets. The remaining effect targets are seen as indirect targets of herbs. In DBTP, users need only upload the SMILES information of the drug.",style = "font-size: 15px;"),

                  h2("Drug target mapping on signaling pathways"),

                  p("DTMP enriches the effect targets into their corresponding biological signaling pathways and distinguishes between direct and indirect targets within the pathways. Various biological networks such as protein-protein interaction networks, gene coexpression networks, gene function networks, and molecular signaling pathway networks can be utilized to map all targets to their respective networks, allowing for the exploration of signaling pathways of herbal targets and laying the foundation for the study of the molecular mechanism. As various known biological networks are applied in different fields without a clear distinction of superiority or inferiority, the choice of the appropriate molecular network can be flexible according to one’s own research background and research objectives. By default, DTMP employs the widely recognized KEGG molecular pathway network for gene enrichment analysis.",style = "font-size: 15px;"),

                  h2("One case: exploring molecular mechanisms of XiaoKeAn against type 2 diabetes"),
                  
                  p("This section aims to employ NP-TCMtarget, leveraging transcriptomic data and chemical information of XiaoKeAn, to elucidate the mechanism of XiaoKeAn in treating type 2 diabetes at the molecular level.",style = "font-size: 15px;"),

                  img(src = "example3.jpg",style = "display: block; margin: 0 auto;", height = 600, width = 604),
                  
                  p("First, following the instruction of NP-TCMtarget, we collected the transcriptional data from the microarray experiment deposited in GEO (GSE accession: GSE62087). The experiment includes three groups: the normal control group (C57BL/6J mice), the disease model group (KKAy mice) and the corresponding XiaoKeAn treatment group. The differential gene profiles induced by the diabetes model and XiaoKeAn treatment were calculated and submitted to the DETP module to predict effect targets.",style = "font-size: 15px;"),

                  img(src = "example4.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),

                  p("Differential transcriptional profiles between diseases and xka",align = "center",style = "font-size: 14px;"),                 
                  br(),
                  img(src = "example5.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),
                  p("Differential transcriptional profiles between sham and diseases",align = "center",style = "font-size: 14px;"),
                  
                  p("The predicted results can be found in the page of Results:",style = "font-size: 15px;"),
                  img(src = "example19.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),
                  p("The effect targets of xka",align = "center",style = "font-size: 14px;"),
                  br(),
                  img(src = "example67.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),
                  p("The effect targets of model",align = "center",style = "font-size: 14px;"),
                  br(),
                  p("Based on the predicted effect targets for the disease model and XKA treatment, we can compare the two groups and observed a negative correlation between the disease model and XiaoKeAn treatment based on the NETS values for all targets.",style = "font-size: 15px;"),
                  img(src = "example7.jpg",style = "display: block; margin: 0 auto;",height = 230,width = 249),
                  p("More importantly, the absolute value of NETS reflects the magnitude of the drug/disease’s effects on a target, with a higher absolute value indicating a stronger impact. If the NETS values for the drug and disease on a specific target are opposite, it suggests opposing effects of the drug and disease on that target. By comparing the NETS values of the effect targets that are significantly associated with the diabetes model and XiaoKeAn treatment, we identified these targets that were significantly affected by the diabetes model but could be reversed by the XiaoKeAn treatment (indicated by opposing signs in NETS values; FDR ≤ 0.05). ",style = "font-size: 15px;"),
                  img(src = "example18.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 402),                  
                  p("If we only focused these targets, we observed that there is a strong negative correlation between the disease model and XiaoKeAn treatment if we only focus on these targets (PCC = -0.98). These results suggest that these targets can be potential therapeutic targets for XiaoKeAn in the treatment of diabetes mellitus.",style = "font-size: 15px;"),

                  img(src = "example10.jpg",style = "display: block; margin: 0 auto;",height = 230,width = 249),

                  p("Second, chemical components of XiaoKeAn were gathered. Utilizing the SMILE information of all these components, the DBTP module was employed to predict binding targets of XiaoKeAn ingredients.",style = "font-size: 15px;"),

                  img(src = "example111.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),                  
                  p("The predicted results can be found in the page of Results:",style = "font-size: 15px;"),

                  img(src = "example12.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536),
                  br(),
                  p("We can chose a threshold of binding score (e.g. Binding score ≥ 0.90) to obtain potential binding scores of herbal ingredients. Compare these binding target of XiaoKeAn and its effect targets for treating diabetes, we can obtain direct targets and indirect targets of XiaoKeAn for treating diabetes. These targets can further be mapped to biological pathways to elucidate the molecular mechanisms of XiaoKeAn in diabetes treatment.",style = "font-size: 15px;"),



                  p("Finally, we can analyze predicted targets using DTMP. By default, DTMP employs the widely recognized KEGG molecular pathway network for gene enrichment analysis. Users simply need to upload the therapeutic targets obtained through DETP and the binding targets acquired via DBTP. The analysis results are displayed on the Results page, making it convenient for users to review and download.",style = "font-size: 15px;"),

                  img(src = "example13.jpg",style = "display: block; margin: 0 auto;",height = 300,width = 536)

                  
                )
              )
              
      )
      
    )
    
  ),
  
  skin = 'blue',
  #jindutiao weizhi
  tags$head(
    tags$style(
      HTML(".shiny-notification {
           position:fixed;
           top: calc(30%);
           left: calc(30%);
}"
      )
    )
  )
  
) 


server<-function(input, output,session) {
  datainput <- reactive({
    req(input$file1)
    read.csv(input$file1$datapath, row.names = 1) 
    
  })
  
  
  output$data <- renderTable({
    
    return(head(datainput(),50))
    
  },rownames = TRUE)
  
  datainput1 <- reactive({
    req(input$file2)
    read.csv(input$file2$datapath, row.names = NULL) 
    
  })
  
  output$data1 <- renderTable({
    
    return(head(datainput1(),50))
    
  })
  datainput2 <- reactive({
    req(input$file3)
    read.csv(input$file3$datapath, header = TRUE) 
    
  })
  
  datainput3 <- reactive({
    req(input$file4)
    read.csv(input$file4$datapath, header = TRUE) 
    
  })
  
  
  
  observeEvent(input$Target_gene_action,{
    progress <- 
      Progress$new(
        session,
        min = 1,
        max = 10
        # ,
        # style = "old"
      )
    on.exit(progress$close())
    progress$set(
      message = 'Calculation in progress, this may take some minutes,you can jump to "result page" for waiting...'
    )
    for(i in 1:5){
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    dataoutput <- fun_target(querydata=datainput())
    output$targetdata <- renderTable({
      return(dataoutput[[1]])
    })
    
    for(i in 6:10){
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    output$downloadData1 <- downloadHandler(
      filename = "DH_effect_target.csv",
      content = function(file) {
        write.csv(dataoutput[[1]], file, row.names = FALSE)
      }
    )
    
  })
  
  observeEvent(input$path_analyse,{
    progress <- 
      Progress$new(
        session,
        min = 1,
        max = 10
        # ,
        # style = "old"
      )
    on.exit(progress$close())
    progress$set(
      message = 'Calculation in progress, this may take some minutes,you can jump to "result page" for waiting...'
    )
    for(i in 1:5){
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    values <- as.character(unlist(datainput2())) 
    common_values <- intersect(datainput2()[,1], datainput3()[,1])
    effective_remaining <- datainput2()[!(datainput2()[,1] %in% common_values), ]
    enrichResult <- WebGestaltR(enrichMethod="ORA", organism="hsapiens",
                                enrichDatabase=input$variable, interestGene = values,
                                interestGeneType="genesymbol", referenceSet = "genome_protein-coding",
                                isOutput=FALSE,fdrThr = 0.05) 
    split_enrich = list()  
    enrich_direct = list()  
    enrich_indirect = list()  
    for (i in 1:length(enrichResult[,1])){
      split_enrich[[i]] = strsplit(enrichResult$userId[i], ";")[[1]]
      enrich_direct[[i]] = split_enrich[[i]][split_enrich[[i]] %in% common_values]
      enrich_indirect[[i]] = split_enrich[[i]][split_enrich[[i]] %in% effective_remaining]
    }
    Direct_target_set=c() 
    InDirect_target_set=c() 
    for(i in 1:length(enrichResult[,1])){
      Direct_target_set[i] = paste(enrich_direct[[i]],collapse = ";")
      InDirect_target_set[i] = paste(enrich_indirect[[i]],collapse = ";")
    }
    enrichResult$direct_target <- Direct_target_set   
    enrichResult$indirect_target <- InDirect_target_set
    output$pathway_link <- renderTable({
      return(enrichResult)
    })
    
    for(i in 6:10){
      progress$set(value = i)
      Sys.sleep(0.5)
    }
    output$downloadData2 <- downloadHandler(
      filename = "DTMP.csv",
      content = function(file) {
        write.csv(enrichResult, file, row.names = FALSE)
      }
    )
    
  })  
  observeEvent(input$smile_action,{
    progress<-Progress$new(
      session,
      min = 1,
      max=10
    )
    on.exit(progress$close())
    progress$set(
      message='Calculation in progress, this may take some minutes,Please wait patiently...'
    )
    for(i in 1:5){
      progress$set(value=i)
      Sys.sleep(0.5)
    }
    py_data <- r_to_py(datainput1())
    py$py_data <- py_data
    source_python("DT_predict.py")
    
    predict_result <- py$y_predict_result
    output$combinedata <- renderTable(head(predict_result),50)
    for(i in 6:10){
      progress$set(value=i)
      Sys.sleep(0.5)
    }
    output$downloadData <- downloadHandler(
      filename = "DH_direct_target.csv",
      content = function(file) {
        write.csv(predict_result, file, row.names = FALSE)
      }
    )
  })
}
# }
# Create Shiny app ----
shinyApp(ui, server)
