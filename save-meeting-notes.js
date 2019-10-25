var get = require('./get-parliament-api');
var extract = require('./extract');
var csv = require('./write-to-csv');

get.getMeetings(get.domain, '2016', '5', '1053519').then(meetingsResponse => {
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
