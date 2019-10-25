function writeMeetingToCsv(meeting) {
  const createCsvWriter = require('csv-writer').createObjectCsvWriter;
  const csvWriter = createCsvWriter({
    path: 'meetings.csv',
    header: [{ id: 'meetingId', title: 'meetingId' }, { id: 'person', title: 'person' }],
  });

  const meetingId = extractMeetingId(meeting);
  const personsPresent = extractPersonsPresent(meeting);

  const records = [];
  personsPresent.forEach(person => {
    records.push({ meetingId: meetingId, person: person });
  });

  csvWriter.writeRecords(records).then(() => {
    console.log(`meeting with id ${meetingId} written to meetings.csv`);
  });
}
