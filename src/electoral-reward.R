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
nearly_no_presences <- total_presences_by_member %>% filter(totalPresences < 20)
joke_schauvliege <- meetings %>% filter(personFirstName == "Joke" & personLastName == "Schauvliege")

# visualize relation again but this time only for members which were present during entire legislature
presences_entire_legislature <- meetings %>%
  onlyObligatoryMeetings(members) %>% 
  onlyMembersFullLegislature() %>%
  countPresences() %>% 
  addElectionResults(election_results)

plotPresencesVotes(presences_entire_legislature)

# add the names of the 10 members of parliament where ratio votes/presences is most skewed
addRatioVotesPresences <- function (total_presences) {
  total_presences %>% 
    mutate(ratio = votes / totalPresences)
}

presences_full_leg <- total_presences_by_member %>%
  addRatioVotesPresences() 

ggplot(data = presences_full_leg,
       aes(x = totalPresences, y = votes)) +
  geom_point() +
  geom_point(data = presences_full_leg %>% filter)
  
