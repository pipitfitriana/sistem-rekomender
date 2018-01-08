install.packages("recommenderlab") 
library(datasets)
library(recommenderlab) # package being evaluated 
library(ggplot2) # For plots

data(MovieLense)
MovieLense

image(sample(MovieLense, 500), main = "Raw ratings")

qplot(getRatings(MovieLense), binwidth = 1, 
main = "Histogram of ratings", xlab = "Rating")

summary(getRatings(MovieLense)) # Skewed to the right

qplot(rowCounts(MovieLense), binwidth = 10,
main = "Movies Rated on average", xlab = "# of users", ylab = "# of movies rated") 

# Seems people get tired of rating movies at a logarithmic pace. But most rate some.
recommenderRegistry$get_entries(dataType = "realRatingMatrix") 


scheme <- evaluationScheme(MovieLense, method = "split", train= .9, k = 1, given = 10, goodRating = 4) 
scheme

algorithms <- list("random items" = list(name="RANDOM", param=list(normalize = "Z-score")),"popular items" = list(name="POPULAR", param=list(normalize = "Z-score")),"user-based CF" = list(name="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=50, minRating=3)))

# run algorithms, predict next n movies
results <- evaluate (scheme, algorithms, n=c(1,3,5,10,15,20)) 
plot(results, annotate = 1:4, legend="topleft")

plot(results, "prec/rec", annotate=3)