################################################################################
### Name:    potoolsExample.R 
### Purpose: install potools R package and provide a simple example of using it
### Author:  Sarah Lauser
###
### Major revision history:
### 2023-03-30 SL Created this script
################################################################################

library(potools)

check_cracked_messages()



pkg <- file.path(system.file(package = 'potools'), 'pkg')
cat(pkg)

# copy to a temporary location to be able to read/write/update below
tmp_pkg <- file.path(tempdir(), "pkg")
dir.create(tmp_pkg)
file.copy(pkg, dirname(tmp_pkg), recursive = TRUE)

# first, extract message data
message_data = get_message_data(tmp_pkg)

# now, diagnose the messages for any "cracked" ones
check_cracked_messages(message_data)

# cleanup
unlink(tmp_pkg, recursive = TRUE)
rm(pkg, tmp_pkg, message_data)

pot_list <- read.csv(url("https://raw.githubusercontent.com/r-devel/r-svn/master/po/POTFILES"))



r-devel/r-svn/po/POTFILES