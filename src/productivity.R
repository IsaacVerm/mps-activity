library(tidyverse)

# load
source("src/read-functions.R")
source("src/meetings-functions.R")
source("src/presences-functions.R")

meetings <- readMeetings()
members <- readMembers()
election_results <- readElectionResults()

# wrangle
presences <- meetings %>%
  addPersonName() %>% 
  onlyMembersFullLegislature() %>% 
  countPresences()

# members of parliament most present
top_20_presences <- presences %>% 
  ungroup() %>% 
  arrange(desc(presences)) %>% 
  top_n(20)

plotPresencesByParty(top_20_presences, "top 20 members of parliament most present")
ggsave("plot/top-20-most-presences.png")

# members of parliament least present
bottom_20_presences <- presences %>% 
  ungroup() %>% 
  arrange(presences) %>% 
  top_n(-20)

plotPresencesByParty(bottom_20_presences, "top 20 members of parliament least present")
ggsave("plot/top-20-least-presences.png")
  
# average number of presences by party
avg_presences_by_party <- presences %>% 
  group_by(partyName) %>%
  summarise(avgPresences = round(mean(presences), digits = 0))

ggplot(data = avg_presences_by_party,
       aes(x = reorder(partyName, desc(avgPresences)), y = avgPresences)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "party",
       y = "average number of presences by MP",
       title = "average number of presences by party")
ggsave("plot/avg-presences-by-party.png")
  