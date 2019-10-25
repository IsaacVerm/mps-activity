function extractPersonsPresent(meeting) {
  const indexPresent = 0;
  return meeting.vergadering.aanwezigheid[indexPresent].persoon.map(person => {
    return person.voornaam + ' ' + person.naam;
  });
}

function extractMeetingId(meeting) {
  return meeting.vergadering.id;
}
