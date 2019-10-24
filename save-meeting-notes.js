var axios = require('axios');

// setup
const domain = 'http://ws.vlpar.be/e/opendata';
const legislature = '2014-2019';
const years = ['2014', '2015', '2016', '2017', '2018', '2019'];
const months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

// functions
function getCommissionsInLegislature(domain, legislature) {
  const url = domain + '/comm/legislatuur?legislatuur=' + legislature;
  return axios.get(url);
}

function extractCommissionIds(commissions) {
  const commissionIds = commissions.data.items.map(commission =>
    commission.commissie.id.toString(),
  );
  return commissionIds;
}

function getMeetings(domain, year, month, commissionId) {
  const searchParams = { params: { year: year, month: month, type: 'comm', idComm: commissionId } };

  return axios.get(domain + '/verg/volledig/zoek', searchParams);
}

function extractMeetingId(meeting) {
  return meeting.vergadering.id;
}

function extractPersonsPresent(meeting) {
  const indexPresent = 0;
  return meeting.vergadering.aanwezigheid[indexPresent].persoon.map(person => {
    return person.voornaam + ' ' + person.naam;
  });
}

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

  csvWriter
    .writeRecords(records) // returns a promise
    .then(() => {
      console.log('...Done');
    });
}

getMeetings(domain, '2016', '5', '1053519').then(meetings => {
  const meeting = meetings.data.items[0];
  writeMeetingToCsv(meeting);
});

// test
// getCommissionsInLegislature(domain, legislature).then(function(commissions) {
//   const commissionIds = extractCommissionIds(commissions);

//   years.forEach(year => {
//     months.forEach(month => {
//       commissionIds.forEach(commissionId => {
//         getMeetings(domain, year, month, commissionId).then(meetings => {
//           meetings.data.items.forEach(meeting => {
//             console.log(extractMeetingId(meeting));
//           });
//         });
//       });
//     });
//   });
// });
