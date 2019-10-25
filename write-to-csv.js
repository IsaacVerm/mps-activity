function createMeetingsArray(personDetails, meetingDetails) {
  const records = [];
  personsPresent.forEach(person => {
    records.push({ meetingId: meetingId, person: person });
  });
}

function writeMeetingToCsv(meetingsArray) {
  const createCsvWriter = require('csv-writer').createObjectCsvWriter;
  const csvWriter = createCsvWriter({
    path: 'meetings.csv',
    header: [{ id: 'meetingId', title: 'meetingId' }, { id: 'person', title: 'person' }],
  });

  csvWriter.writeRecords(records).then(() => {
    console.log(`meeting with id ${meetingId} written to meetings.csv`);
  });
}
