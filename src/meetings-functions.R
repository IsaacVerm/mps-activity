library(tidyverse)
library(lubridate)

onlyObligatoryMeetings <- function(meetings, members) {
  semi_join(meetings, members, by = c("personFirstName", "personLastName", "commissionId"))
}

countPresences <- function(meetings) {
  meetings %>% 
    group_by(personId, personFirstName, personLastName, partyName) %>% # want to keep first and last name 
    summarise(presences = n())
}

# only keep those members having done an entire legislature 2014-2019
onlyMembersFullLegislature <- function(meetings) {
  members_entire_legislature <- meetings %>% 
    group_by(year(start), personId) %>% 
    sample_n(1) %>% 
    select(personId) %>%
    group_by(personId) %>% 
    summarise(yearsActive = n()) %>% 
    filter(yearsActive == 6) # 6 years is entire legislature
  
  meetings %>%
    semi_join(members_entire_legislature, by = "personId")
}

addPersonName <- function(meetings) {
  meetings %>% 
    unite("personName", personFirstName:personLastName, remove = FALSE, sep = " ")
}


  