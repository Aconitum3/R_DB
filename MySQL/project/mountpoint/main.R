library(RMySQL)

drv <- dbDriver("MySQL")

conn <- dbConnect(
  drv,
  host = "db",
  port = 3306,
  user = "root",
  password = "root",
  dbname = "db"
)

dbGetQuery(conn, "SELECT * FROM mytable LIMIT 10")