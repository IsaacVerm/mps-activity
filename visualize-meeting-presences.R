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
  group_by(personName) %>% 
  summarise(presences = n())

# visualize most active parliamentarians
mostActiveParliamentarians <- presencePerPerson

ggplot(data = presencePerPerson,
       aes(x = reorder(personName, presences), y = presences)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90))