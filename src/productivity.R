library(tidyverse)

# read
meetings <- read_csv(file = "meetings.csv",
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

# mangle
meetings <- meetings %>% 
  unite("personName", personFirstName:personLastName, remove = FALSE, sep = " ")

# number of meetings present per person
presencePerPerson <- meetings %>% 
  group_by(personName, partyName) %>% 
  summarise(presences = n()) 

# visualize most active parliamentarians
mostActiveParliamentarians <- presencePerPerson %>% 
  arrange(desc(presences)) %>% 
  top_n(20)

ggplot(data = mostActiveParliamentarians,
       aes(x = reorder(personName, presences), y = presences)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "parlementslid", y = "aantal aanwezigheden", title = "Aanwezigheden legislatuur 2014-2019")
  
# average number of presences by party
presenceByParty <- presencePerPerson %>% 
  group_by(partyName) %>%
  summarise(avgNrOfPresences = round(mean(presences), digits = 0))

ggplot(data = presenceByParty,
       aes(x = reorder(partyName, avgNrOfPresences), y = avgNrOfPresences)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "partij", y = "gemiddeld aantal aanwezigheden per parlementslid", title = "Gemiddeld aantal aanwezigheden volgens partij")
  