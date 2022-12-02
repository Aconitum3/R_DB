library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

conn <- dbConnect(
  drv,
  host = "db",
  port = 5432,
  user = "root",
  password = "root",
  dbname = "db"
)

dbGetQuery(conn, "SELECT * FROM mytable")