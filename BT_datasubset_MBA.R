#################################################################################################
####          Market Basket Analysis of BT spatial clusters    ####

library(plyr)
library(ggplot2)
library(mclust)
library(reshape2)
library(chron)
library(dplyr)
library(scales)

library(arules)
library(arulesViz)


trips_with_clusts <- read.csv("BT_toy_TripsPlusClusts25.csv", header=T, sep = ",")

# summarise the number of trips in each cluster for each MAC address
person_seqs <- dcast(trips_with_clusts, new_id ~ clusts, length)

person_seqs_long <- melt(person_seqs, id.vars = "new_id")


###### we only want to include clusters people use 'regularly'
###      for this toy example, regularly => at least 4 times in the 2 month period

person_seqs_long2 <- subset(person_seqs_long, value >=4)
person_seqs_long_sorted <- person_seqs_long2[order(person_seqs_long2$new_id),]


#  put data in 'transaction' format as required for association rule fns
clust_list <- ddply(person_seqs_long_sorted,c("new_id"),
                  function(df1)paste0("X",df1$variable,
                                     collapse = ", "))

items <- strsplit(as.character(clust_list$V1), ", ")

tr <- as(items, "transactions")

tr
summary(tr)
# plot number of people using each spatial cluster regularly
itemFrequencyPlot(tr, topN=20, type='absolute')

########################################################################
###   Undertake the association rule mining   ####
# adjust support and confidence as required:
rules <- apriori(tr, parameter = list(supp=0.3, conf=0.8, maxlen = 25))

rules <- sort(rules, by='confidence', decreasing = TRUE)
summary(rules)

inspect(rules[1:10])

topRules <- rules[1:10]

dev.off()
plot(rules, method="graph")
plot(rules, method="grouped matrix")

