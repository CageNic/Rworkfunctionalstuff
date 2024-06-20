This is a base R inner join that matches on ids in both
However, if the right file has duplicates (and the left does not)... it creates duplicates on the left to legislate for mapping the right side

# Create origin dataframe(

producers <- data.frame(   
    surname =  c("Spielberg","Scorsese","Hitchcock","Tarantino","Polanski"),    
    nationality = c("US","US","UK","US","Poland"),    
    stringsAsFactors=FALSE)

# Create destination dataframe
movies <- data.frame(    
    surname = c("Spielberg",
		"Scorsese",
                "Hitchcock",
              	"Hitchcock",
                "Spielberg",
                "Tarantino",
                "Polanski"),    
    title = c("Super 8",
    		"Taxi Driver",
    		"Psycho",
    		"North by Northwest",
    		"Catch Me If You Can",
    		"Reservoir Dogs","Chinatown"),                
     		stringsAsFactors=FALSE)

# Merge two datasets
m1 <- merge(producers, movies, by.x = "surname")
m1
dim(m1)
Output:

surname		nationality		title
1 Hitchcock		UK		Psycho
2 Hitchcock		UK		North by Northwest
3 Polanski		Poland		Chinatown
4 Scorsese		US		Taxi Driver
5 Spielberg		US		Super 8
6 Spielberg		US		Catch Me If You Can
7 Tarantino		US		Reservoir Dogs
