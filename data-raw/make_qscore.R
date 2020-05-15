library(dplyr)
library(dbplyr)
library(RSQLite)

con <- DBI::dbConnect(RSQLite::SQLite(), "data-raw/info.db")

dbListTables(con)
