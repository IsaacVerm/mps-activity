library(tidyverse)
library(lubridate)

# load
meetings <- read_csv(file = "data/commission-meetings.csv",
                     col_names = c("meetingId",
                                   "commissionName",
                                   "commissionId",
                                   "start",
                                   "end",
                                   "description",
                                   "personId",
                                   "personFirstName",
                                   "personLastName",
                                   "partyName",
                                   "partyId",
                                   "gender"))

members <- read_csv(file = "data/commission-members.csv",
                    col_names = c("personFirstName", "personLastName", "personId", "commissionId"))

election_results <- read_csv(file = "data/election-results.csv",
                             col_names = c("personName", "votes"))

source("src/meetings-functions.R")
source("src/presences-functions.R")

# presences vs votes
presences <- meetings %>% 
  onlyObligatoryMeetings(members) %>% 
  countPresences() %>% 
  addElectionResults(election_results)

plotPresencesVotes(presences)

# how come some members have no or nearly no presences?
nearly_no_presences <- presences %>% filter(presences < 20)
joke_schauvliege <- meetings %>% filter(personFirstName == "Joke" & personLastName == "Schauvliege")

# visualize relation again but this time only for members which were present during entire legislature
presences_entire_legislature <- meetings %>%
  onlyObligatoryMeetings(members) %>% 
  onlyMembersFullLegislature() %>%
  countPresences() %>% 
  addElectionResults(election_results)

plotPresencesVotes(presences_entire_legislature)

# add the names of the 5 members of parliament which get the best votes for presences
# and the 5 members which get the least

presences_entire_legislature <- presences_entire_legislature %>% 
  addRatioVotesPresences() 

most_votes_for_presences <- presences_entire_legislature %>%
  ungroup() %>%
  arrange(desc(ratio)) %>%
  slice(1:10)

least_votes_for_presences <- presences_entire_legislature %>%
  ungroup() %>%
  arrange(ratio) %>%
  slice(1:10)

ggplot(data = presences_entire_legislature,
       aes(x = presences,y = votes)) +
  geom_point() +
  geom_text(data = most_votes_for_presences,
            label = most_votes_for_presences$personLastName,
            check_overlap = TRUE,
            hjust = "top",
            vjust = "top",
            size = 4) +
  geom_text(data = least_votes_for_presences,
            label = least_votes_for_presences$personLastName,
            check_overlap = TRUE,
            hjust = "top",
            vjust = "top",
            size = 4)
  

