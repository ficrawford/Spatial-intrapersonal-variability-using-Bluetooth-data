# Spatial-intrapersonal-variability-using-Bluetooth-data
Code and toy data relating to a paper currently under review in Networks and Spatial Economics.

The first file which should be run is 'BT_datasubset_spatialclust.R', which clusters trip trajectories using 
sequence alignment to calculate distances between sensor observations.  The purpose is to reduce the spatial dimensionality of the trip sequences.  The input data required are in:
- BT_Wigan_subsetanondata2.csv and
- Wigan_BT_distances_miles_sensnums.csv
The former is the trips made by a sample of 25 MAC addresses observed regularly over a 2 month period.  
It contains 2,859 trips.  The other file contains on road distances between each pair of Bluetooth 
sensors.  Note that the matrix is not symmetrical.

The first file requires the specification of the number of clusters to use, based on the summary statistics 
which are output.  For this small example, I have specified 25 clusters, but this can be changed.  This does 
not match the number of clusters in the published work as that included a much larger number of MAC addresses 
over a much longer period of time.  At the end of this code, one can output the file containing trip 
data together with the assigned spatial clusters (BT_toy_TripsPlusClusts25.csv).  The data obtained if 25 clusters are used are contained in a file with this name in the folder.

The remaining two sets of code can be run in any order as both use the output of the spatial clustering process as an input.
BT_datasubset_HHI.R - calculates the normalised Herfindahl-Hirschman Index for each MAC address
BT_datasubset_MBA.R - undertakes association rule mining on the trips made frequently by each MAC address
