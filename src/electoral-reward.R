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

# filter out meetings where commission members didn't have to be present
meetings <- semi_join(meetings, members, by = c("personFirstName", "personLastName", "commissionId"))

# number of presences by member
calculateTotalPresences <- function(meetings) {
  meetings %>% 
    group_by(personId, personFirstName, personLastName) %>% # want to keep first and last name 
    summarise(totalPresences = n())
}

total_presences_by_member <- calculateTotalPresences(meetings)

# join election results to total presences
joinElectionResults <- function(total_presences, election_results) {
  total_presences %>% 
    mutate(personName = tolower(paste(personLastName, personFirstName, sep = " "))) %>% 
    left_join(election_results %>% mutate(personName = tolower(personName)), by = "personName") %>% 
    mutate(votes = votes * 1000)
}

total_presences_by_member <- joinElectionResults(total_presences_by_member, election_results)

# visualize relation presences and votes
plotPresencesVotes <- function(total_presences) {
  ggplot(data = total_presences,
         aes(x = totalPresences, y = votes)) +
    geom_point()
}

plotPresencesVotes(total_presences_by_member)

# how come some members have no or nearly no presences?
nearly_no_presences <- total_presences_by_member %>% filter(totalPresences < 20)
joke_schauvliege <- meetings %>% filter(personFirstName == "Joke" & personLastName == "Schauvliege")

# visualize relation again but this time only for members which were present during entire legislature
members_entire_legislature <- meetings %>% 
  group_by(year(start), personId) %>% 
  sample_n(1) %>% 
  select(personId) %>%
  group_by(personId) %>% 
  summarise(yearsActive = n()) %>% 
  filter(yearsActive == 6) # 6 years is entire legislature

meetings_entire_legislature <- meetings %>%
  semi_join(members_entire_legislature, by = "personId")

meetings_entire_legislature %>% 
  calculateTotalPresences() %>%
  joinElectionResults(election_results) %>% 
  plotPresencesVotes()

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
  
