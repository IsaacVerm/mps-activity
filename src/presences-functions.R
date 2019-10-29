library(tidyverse)

addElectionResults <- function(presences, election_results) {
  presences %>% 
    mutate(personName = tolower(paste(personLastName, personFirstName, sep = " "))) %>% 
    left_join(election_results %>% mutate(personName = tolower(personName)), by = "personName") %>% 
    mutate(votes = votes * 1000)
}

addRatioVotesPresences <- function (presences) {
  presences %>% 
    mutate(ratio = votes / presences)
}

plotPresencesVotes <- function(presences) {
  ggplot(data = presences,
         aes(x = presences, y = votes)) +
    geom_point()
}


