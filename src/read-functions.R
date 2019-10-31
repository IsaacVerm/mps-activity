library(tidyverse)

readMeetings <- function() {
  read_csv(file = "data/commission-meetings.csv",
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
}

readMembers <- function() {
  read_csv(file = "data/commission-members.csv",
           col_names = c("personFirstName", "personLastName", "personId", "commissionId"))
}

readElectionResults <- function() {
  read_csv(file = "data/election-results.csv",
           col_names = c("personName", "votes"))
}