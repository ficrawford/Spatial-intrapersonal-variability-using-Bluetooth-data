library(ggplot2)
library(reshape2)
library(chron)
library(plyr)
library(dplyr)
library(scales)

# read in data including trips plus the spatial cluster for each
trips_with_clusts <- read.csv("BT_toy_TripsPlusClusts25.csv", header=T, sep = ",")

# summarise the number of trips in each cluster for each MAC address
cluster_summary <- dcast(trips_with_clusts, new_id ~ clusts, length)

#############################################################################
### calc HHI   ###
clusts_only <- cluster_summary %>%
  select(-new_id)

cluster_summary$total <- rowSums(clusts_only)
cluster_summary$maxclustval <- apply(clusts_only, 1, max)
cluster_summary$maxclustname <- colnames(clusts_only)[apply(clusts_only,1,which.max)]

cluster_summary$jointmax <- rowSums(clusts_only == cluster_summary$maxclustval)

cluster_summary$num_clusts <- rowSums(clusts_only > 0)


clusts_only2 <- clusts_only/cluster_summary$total
clusts_only3 <- clusts_only2*clusts_only2 

N1 <- ncol(clusts_only)
cluster_summary$herhirsch <- rowSums(clusts_only3)
cluster_summary$herhirschNORM <- (cluster_summary$herhirsch - (1/N1))/(1-(1/N1))


ggplot(cluster_summary, aes(x=num_clusts, y=herhirschNORM))+ geom_point()
