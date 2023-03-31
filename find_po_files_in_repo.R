library(httr)
library(jsonlite)

# library(gh)
# https://raw.githubusercontent.com/r-devel/r-svn/master/po/POTFILES
# 
# my_repos <- gh("GET /users/r-devel")
# 
# 
# 
# 
# cat(readLines(repos))
# 
# library(curl)
# 
# ?curl
# 
# ??json
# 
# 
# repos <- fromJSON("https://api.github.com/users/r-devel/repos")
# 
# 

# 
# # Replace <TOKEN> with your personal access token
# headers <- c("Authorization" = paste("Bearer", "<TOKEN>"))
# 
# # Replace <OWNER> and <REPO> with the owner and name of the repository you want to search
# owner <- "r-devel"
# repo <- "r-svn"
# url <- paste0("https://api.github.com/repos/",owner,"/",repo,"/search/code")
# cat(url)
# 
# https://api.github.com/search/issues?repository_id=255592249&q=windows
# 
# # Specify the search query to look for files with the ".po" extension
# params <- list(q = "po")
# 
# # Make the API request
# response <- GET(url, query = params)
# 
# 
# response$url
# 
# # Extract the filenames of the matching files from the response
# 
# 
# filenames <- sapply(response$content, function(x) fromJSON(x)$name)
# 
# # Print the filenames of the matching files
# print(filenames)
# 
# 
# 
# curl -H 'Accept: application/vnd.github.text-match+json' \
# 'https://api.github.com/search/issues?repository_id=255592249&q=windows+label:bug \
# +language:python+state:open&sort=created&order=asc'
# 
# 
# 
# repoList
# 
# repos <- GET("https://api.github.com/users/r-devel")


#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
# get list of repositories for user
ghUser <- "r-devel"
ghRepo <- "r-svn"
ghBaseURL <- "https://api.github.com"

# do searches based on various criteria
# baseSearchURL <- "https://api.github.com/search/code"

# filename:*.po 
queryParam1  <- paste0("q=repo%3A",ghUser,"%2F",ghRepo,"+filename%3A%2Apo")
urlString1 <- paste0(ghBaseURL,"/search/code?",queryParam1)
searchMatches1 <- fromJSON(urlString1)
searchMatches1$total_count
matchResults1 <- searchMatches1$items

# filename:*.pot
queryParam2  <- paste0("q=repo%3A",ghUser,"%2F",ghRepo,"+filename%3A%2Apo")
urlString2 <- paste0(ghBaseURL,"/search/code?",queryParam2)
searchMatches2 <- fromJSON(urlString2)
searchMatches2$total_count
matchResults2 <- searchMatches2$items

# urlString
# https://api.github.com/search/code?q=repo%3Ar-devel%2Fr-svn%20filename%3A%2Apo

# maybe also try language="Gettext+Catalog"
queryParam3  <- paste0("q=repo%3A",ghUser,"%2F",ghRepo,'+language%3A"Gettext+Catalog"')
urlString3 <- paste0(ghBaseURL,"/search/code?",queryParam3)
searchMatches3 <- fromJSON(urlString3)
searchMatches3$total_count
matchResults3 <- searchMatches3$items
