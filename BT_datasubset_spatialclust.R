library(mclust)
library(reshape2)
library(chron)
library(plyr)
library(dplyr)
library(scales)
library(TraMineR)
library(WeightedCluster)

all_trips1 <- read.csv("BT_Wigan_subsetanondata2.csv", 
                       header=T, sep = ",",
                       stringsAsFactors = F)


## just get all sequences (in order), without any other identifiers
all_seq1 <- subset(all_trips1,select = -c(new_id, trip_num))


### get similarity scores:

### unique sequences only required for calculating distances  ###
all_seq1_uni <- unique(all_seq1)
all_seq2_uni <- seqdef(all_seq1_uni)

dist_data <- read.csv("Wigan_BT_distances_miles_sensnums.csv", 
                      row.names = 1,
                      header=T, sep = ",")

dist_data2 <- as.matrix(dist_data)

# list of sensor specific indels (sensor 1:8)
indel_v <- c(1.41,1.38,1.70,1.47,1.28,1.70,1.42,1.10)


## calc distances between sequences
all_seq_dists_uni <- seqdist(all_seq2_uni, "OM", sm= dist_data2, 
                             norm="auto", indel=indel_v)
all_seq_dists_uni2 <- as.data.frame(all_seq_dists_uni)



# ### calc weights, i.e. freq of each sequence
weights1 <- ddply(all_seq1,c(colnames(all_seq1)), nrow)

weights1 <- weights1 %>% 
  rename(freq1 = V1)

# testing hierarchical clustering to see how many clusters to use
clusterward2 <- hclust(as.dist(all_seq_dists_uni),
                       method = "ward.D2",
                       members=weights1$freq1)

wardRange <- as.clustrange(clusterward2, diss = all_seq_dists_uni,
                           weights = weights1$freq1, ncluster = 150)
summary(wardRange, max.rank = 2)
plot(wardRange, stat = c("ASWw", "HG", "PBC", "HC"))
plot(wardRange, stat = c("all"))


#####################################################################
### once the number of clusters have been selected... ###


###### now look at, for example, 25 clusts
clusts <- cutree(clusterward2, k = 25)
clust_data1 <- cbind(all_seq2_uni,clusts)


## Then merge back into full data
clust_data1[clust_data1=="%"]<-NA

all_data <- merge(all_trips1, clust_data1, 
                  by=c("all_orign", "s1", "s2", "s3", "s4", "s5","s6"),
                  all=T)

write.csv(all_data,file="BT_toy_TripsPlusClusts25.csv", row.names = F)










