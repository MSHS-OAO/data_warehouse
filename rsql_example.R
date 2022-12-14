library(DBI)
library(odbc)
library(glue)
library(dbplyr)
library(dplyr)

#Explain the difference betwween Rworkbench and local including speed
dsn <- "OAO Cloud DB" #Explain that this will be different for everyone
conn <- dbConnect(odbc(), dsn)

table <- "MV_DM_PATIENT_ACCESS"
date_1 <- "2022-11-01"
date_2 <- "2022-11-01"

## Glue is more felxible we can create insert statments
query <- glue("SELECT DERIVED_STATUS_DESC , CONTACT_DATE FROM \"{table}\" WHERE DERIVED_STATUS_DESC  = 'Canceled' AND
              CONTACT_DATE BETWEEN TO_DATE('{date_1} 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
                        AND TO_DATE('{date_2} 23:59:59', 'YYYY-MM-DD HH24:MI:SS')")

##https://dbi.r-dbi.org/reference/
data_dbi <- dbGetQuery(conn, query)


##https://dbplyr.tidyverse.org/reference/index.html
access_tbl <- tbl(conn, table)
format <- "YYYY-MM-DD HH24:MI:SS"
date_1_dbplyr <- paste0(date_1, " 00:00:00")
date_2_dbplyr <- paste0(date_2, " 23:59:59")
data_dbplyr <- access_tbl %>% filter(DERIVED_STATUS_DESC == "Canceled", 
                                     TO_DATE(date_1_dbplyr, format) <= CONTACT_DATE,
                                     TO_DATE(date_2_dbplyr, format) >= CONTACT_DATE
                                     ) %>% 
                                      select(DERIVED_STATUS_DESC, CONTACT_DATE) %>%
                                      collect()

