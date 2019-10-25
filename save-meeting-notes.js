var get = require('./get-parliament-api');
var extract = require('./extract');
var csv = require('./write-to-csv');

const years = ['2014', '2015', '2016', '2017', '2018', '2019'];
const months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

get.getCommissionsInLegislature(get.domain, '2014-2019').then(commissionsResponse => {
  const commissionIds = extract.extractCommissionIds(commissionsResponse);
  commissionIds.forEach(commissionId => {
    years.forEach(year => {
      months.forEach(month => {
        get.getMeetings(get.domain, year, month, commissionId).then(meetingsResponse => {
          // get meetings
          const meetings = meetingsResponse.data.items;

          meetings.forEach(meeting => {
            // extract persons present and meeting details
            const personsPresentDetails = extract.extractPersonsPresentDetails(meeting);
            const meetingDetails = extract.extractMeetingDetails(meeting);

            // create records to save
            const meetingRecords = csv.createMeetingRecords(personsPresentDetails, meetingDetails);

            // save records to file
            csv.writeMeetingsToCsv(meetingRecords);
          });
        });
      });
    });
  });
});
