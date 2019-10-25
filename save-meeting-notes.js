var get = require('./get-parliament-api');
var extract = require('./extract');

get.getMeetings(get.domain, '2016', '5', '1053519').then(meetings => {
  const meeting = meetings.data.items[0];
  console.log('persons present');
  console.log(extract.extractPersonsPresentDetails(meeting));
  console.log('meeting details');
  console.log(extract.extractMeetingDetails(meeting));
});
