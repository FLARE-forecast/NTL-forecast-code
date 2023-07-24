library(tidyverse)
library(lubridate)

lake_directory <- here::here()
config_set_name <- "default"
forecast_site <- c("splk")
configure_run_file <- paste0("configure_run_",forecast_site,".yml")
config <- FLAREr::set_configuration(configure_run_file,lake_directory, config_set_name = config_set_name)

config_obs <- FLAREr::initialize_obs_processing(lake_directory, 
                                                observation_yml = paste0("observation_processing_",forecast_site,".yml"), 
                                                config_set_name = config_set_name)

dir.create(file.path(lake_directory, "targets", config$location$site_id), showWarnings = FALSE)

cleaned_insitu_file <- read_csv("https://raw.githubusercontent.com/pschramm93/NTL_flare/main/D%3A/admin/Desktop/sp_daily.csv",
                   col_names = c("drop","datetime","depth","observation","site_id","variable")) %>% 
  select(-drop) %>% 
  mutate(site_id = forecast_site)

write_csv(cleaned_insitu_file,file.path(lake_directory,"targets", 
                                config$location$site_id,
                                paste0(config$location$site_id,"-targets-insitu.csv")))
