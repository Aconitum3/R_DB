library(RSQLite)

drv <- dbDriver("SQLite")

conn <- dbConnect(SQLite(),  "/mydb")

dbGetQuery(conn, "SELECT * FROM mytable")