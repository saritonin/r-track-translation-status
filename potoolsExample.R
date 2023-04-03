################################################################################
### Name:    potoolsExample.R 
### Purpose: install potools R package and provide a simple example of using it
### Author:  Sarah Lauser
###
### Major revision history:
### 2023-03-30 SL Created this script
################################################################################
library(glue)
library(data.table)
library(potools)
library(here)

source(file.path(here::here(),'copy_of_get_po_messages.R'))

# set the path to the directory where the source for the package lives
pkg <- file.path(system.file(package = 'potools'), 'pkg')

#cat(pkg)

# copy to a temporary location to be able to read/write/update below
tmp_pkg <- file.path(tempdir(), "pkg")
dir.create(tmp_pkg)
file.copy(pkg, dirname(tmp_pkg), recursive = TRUE)

# first, extract message data
message_data <- get_message_data(tmp_pkg)

# find total number of messages marked for translation
# A stands for the number of messages (all)
# T stands for the number of translated messages.
# U stands for the number of untranslated messages.
# F is the number of fuzzy messages.
msgCountA_R <- nrow(message_data[message_data$is_marked_for_translation & message_data$message_source == 'R',])
msgCountA_R <- ifelse(is.null(msgCountA_R),0,msgCountA_R)
msgCountA_src <- nrow(message_data[message_data$is_marked_for_translation & message_data$message_source == 'src',])
msgCountA_src <- ifelse(is.null(msgCountA_src),0,msgCountA_src)
msgCountA <- msgCountA_R + msgCountA_src

if (msgCountA == 0) {
  message("Nothing found to translate")
}

# do some translation to build test files
# translate_package(tmp_pkg, "de", diagnostics = NULL, verbose = TRUE)

# check the existing po files for given languages
# easier would be to add a function to the pkg that does this based on the 
# private functions already in the package.
# as is, I've copied the get_po_messages function
language_list <- c("de", "it") # test using target languages of German and Italian
tmp_podir <- file.path(tmp_pkg, "po")
all_lang_file_data <- NULL
lang_file_status <- data.frame(language_code=character(),
                               language_name=character(),
                               lang_file_name=character(),
                               lang_file_path=character(),
                               countA=integer(),
                               countT=integer(),
                               countF=integer(),
                               stringsAsFactors=FALSE)

for (language_code in language_list) {
  file_names <- c(glue("R-{language_code}.po"), glue("{language_code}.po"))
  for (lang_file_name in file_names) {
    message_source = ifelse((lang_file_name == glue("R-{language_code}.po")),'R','src')
    lang_file <- file.path(tmp_podir,lang_file_name)
    if (file.exists(lang_file)) {
      lang_file_data <- get_po_messages(lang_file)
      lang_file_data$language_code <- language_code
      lang_file_data$file <- lang_file_name
      all_lang_file_data <<- rbind(all_lang_file_data, lang_file_data)
    }
    
    #TODO: get the language names programatically. for now, hardcode
    language_name <- ifelse((language_code == "de"),"German","Italian")
    
    #TODO: get the matched and fuzzy counts. for now, just fake it
    matched_messages <- ifelse((language_code == "de" & message_source == 'R'),2,
                               ifelse((language_code == "it" & message_source == 'R'),1,0))
    fuzzy_messages <- ifelse((language_code == "de" & message_source == 'R'),1,0)
    
    new_row <- list(language_code = language_code,
                    language_name = language_name,
                    message_source = message_source,
                    file_name = lang_file_name,
                    countA = ifelse((message_source == 'R'),msgCountA_R,msgCountA_src), 
                    countT = matched_messages,
                    countF = fuzzy_messages)
    
    lang_file_status <<- rbind(lang_file_status, new_row)
  }

}

# do some final calculations on the variables
lang_file_status$countU <- lang_file_status$countA - lang_file_status$countT
lang_file_status$pctDone <- round(lang_file_status$countT*100/lang_file_status$countA,2)
lang_file_status$pctUnfuzzy <- round((lang_file_status$countT-lang_file_status$countF)*100/lang_file_status$countA,2)

if (!dir.exists(file.path(here::here(),'data'))) {
  dir.create(file.path(here::here(),'data'))
}

write.csv(lang_file_status, file = file.path(here::here(),'data/lang_file_status.csv'),
          row.names = FALSE)


# cleanup
unlink(tmp_pkg, recursive = TRUE)
rm(pkg, tmp_pkg, message_data)
