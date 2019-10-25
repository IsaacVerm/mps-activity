var getParliament = require('./get-parliament-api');

getParliament.getMeetings(getParliament.domain, '2016', '5', '1053519').then(meetings => {
  const meeting = meetings.data.items[0];
  console.log(meeting);
});
