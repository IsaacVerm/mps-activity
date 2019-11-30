library(tidyverse)

addElectionResults <- function(presences, election_results) {
  presences %>% 
    ungroup() %>% 
    mutate(personName = tolower(paste(personLastName, personFirstName, sep = " "))) %>% 
    left_join(election_results %>% mutate(personName = tolower(personName)), by = "personName") %>% 
    mutate(votes = votes * 1000)
}

addRatioVotesPresences <- function (presences) {
  presences %>% 
    mutate(ratio = votes / presences)
}

plotPresencesByParty <- function(presences, title) {
  ggplot(data = presences,
         aes(x = reorder(personLastName, desc(presences)), y = presences)) +
    geom_col(aes(fill = partyName)) +
    theme(axis.text.x = element_text(angle = 90)) +
    labs(x = "member of parliament",
         y = "number of presences",
         title = title,
         fill = "party") +
    scale_fill_manual(values = c("Groen" = "green4",
                                 "N-VA" = "saddlebrown",
                                 "CD&V" = "orange",
                                 "sp·a" = "red2",
                                 "UF" = "violet",
                                 "Open Vld" = "blue2",
                                 "Onafhankelijke" = "gray70",
                                 "Vlaams Belang" = "black"))
}

plotPresencesVotes <- function(presences) {
  ggplot(data = presences,
         aes(x = presences, y = votes)) +
    geom_point()
}


