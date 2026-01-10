#############################
# dplyr inner join examined #
#############################

# join on only keys that match in both files
# anything that doesn't match is not included

library(dplyr)

data_1 <- data.frame(ID_1 = c(1, 2, 3, 4, 5, 6),
                     LINKAGE = c('yes', 'yes', 'no', 'yes', 'no', 'yes'),
	             BITS    = c('foo', 'bar', 'baz', 'foobar', NA, NA))

data_2 <- data.frame(ID_2 = c(1, 2, 3, 4, 1234567890, 0987654321),
	             OTHER_STUFF = c('hello', 'ciao', 'bonjour', 'gday', 'bok', 'alright'),
	             THINGS = c('not', 'a','lot', 'of', 'stuff', 'here'))


#-----------------------------------------------------#
# set the IDs to characters as there are long numbers #
# too long for integers                               #
# ----------------------------------------------------#

data_1$ID <- as.character(data_1$ID)
data_2$ID <- as.character(data_2$ID)

data_1 %>%
	inner_join(data_2, by = "ID")

############
# produces #
############
#   ID LINKAGE   BITS OTHER_STUFF THINGS
# 1  1     yes    foo       hello    not
# 2  2     yes    bar        ciao      a
# 3  3      no    baz     bonjour    lot
# 4  4     yes foobar        gday     of


# same result - only other way around

data_2 %>%
	inner_join(data_1, by = "ID")

############
# produces #
############

#   ID OTHER_STUFF THINGS LINKAGE   BITS
# 1  1       hello    not     yes    foo
# 2  2        ciao      a     yes    bar
# 3  3     bonjour    lot      no    baz
# 4  4        gday     of     yes foobar

# keep = TRUE to have both ID columns appear in output


data_2 %>%
	inner_join(data_1, by = "ID", keep = TRUE)

############
# produces #
############

#   ID.x OTHER_STUFF THINGS ID.y LINKAGE   BITS
# 1    1       hello    not    1     yes    foo
# 2    2        ciao      a    2     yes    bar
# 3    3     bonjour    lot    3      no    baz
# 4    4        gday     of    4     yes foobar

#############################################
# only having specific columns in the merge #
#############################################

# join column (key) must be in the select statement

# THINGS column not included

data_1 %>%
  inner_join(select(data_2, OTHER_STUFF, ID), by = "ID")

############
# produces #
############

#   ID LINKAGE   BITS OTHER_STUFF
# 1  1     yes    foo       hello
# 2  2     yes    bar        ciao
# 3  3      no    baz     bonjour
# 4  4     yes foobar        gday
