suppressPackageStartupMessages({
  library(dplyr)
  source(here::here("api","predict.R"))
  options(scipen = 99)
})

model <- readRDS(here::here('api','data','model.rds'))
irisData <- readRDS(here::here('api','data','iris_data.rds'))

#* @param id fill the ID Data
#* @get /predict
#* @serializer unboxedJSON
function(id, res){
  cat (paste0("\nProses id : ",id, "\n"))
  
  hasil <- try(get_species(id, irisData, model))
  
  if(inherits(hasil, "try-error")){
    res$status <- 400
    response <-list()
    response$id <- id
    response$error <- attr(hasil, "condition")$message
    return(response)
  } else {
    res$status <- 200
    
    response <- list()
    response$id <- id
    response$output <- hasil %>% mutate_all(as.character) %>% as.list()
  }
  
  
  return(response)
}
