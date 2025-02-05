# split command to split files on specific line number and keep file extension
# n is number of lines
# additional-suffix= is what the file extension is
# if don't put newfilename... will be default 001 002 etc.

split -l n --additional-suffix=.txt inputfilename.txt newfilename.txt
