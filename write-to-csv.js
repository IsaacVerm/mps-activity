const createCsvWriter = require('csv-writer').createObjectCsvWriter;

module.exports = {
  createMeetingRecords: function(personsPresentDetails, meetingDetails) {
    const meetingRecords = [];
    personsPresentDetails.forEach(person => {
      meetingRecords.push({
        meetingId: meetingDetails.id,
        commissionName: meetingDetails.commissionName,
        commissionId: meetingDetails.commissionId,
        start: meetingDetails.start,
        end: meetingDetails.end,
        description: meetingDetails.description,
        personId: person.id,
        personFirstName: person.firstName,
        personLastName: person.lastName,
        partyName: person.partyName,
        partyId: person.partyId,
        gender: person.gender,
      });
    });
    return meetingRecords;
  },
  createMemberRecords: function(commissionMemberDetails, commissionId) {
    return [
      {
        memberFirstName: commissionMemberDetails.firstName,
        memberLastName: commissionMemberDetails.lastName,
        memberId: commissionMemberDetails.id,
        commissionId: commissionId,
      },
    ];
  },
  writeMeetingsToCsv: function(meetingRecords) {
    const csvWriter = createCsvWriter({
      path: 'commission-meetings.csv',
      header: [
        { id: 'meetingId', title: 'meetingId' },
        { id: 'commissionName', title: 'commissionName' },
        { id: 'commissionId', title: 'commissionId' },
        { id: 'start', title: 'start' },
        { id: 'end', title: 'end' },
        { id: 'description', title: 'description' },
        { id: 'personId', title: 'personId' },
        { id: 'personFirstName', title: 'personFirstName' },
        { id: 'personLastName', title: 'personLastName' },
        { id: 'partyName', title: 'partyName' },
        { id: 'partyId', title: 'partyId' },
        { id: 'gender', title: 'gender' },
      ],
      append: true,
    });

    csvWriter.writeRecords(meetingRecords).then(() => {
      console.log(
        `meeting with id ${meetingRecords[0].meetingId} written to commission-meetings.csv`,
      );
    });
  },
  writeCommissionMemberToCsv: function(memberRecords) {
    const csvWriter = createCsvWriter({
      path: 'commission-members.csv',
      header: ['memberFirstName', 'memberLastName', 'memberId', 'commissionId'],
      append: true,
    });

    csvWriter.writeRecords(memberRecords).then(() => {
      console.log(`member with id ${memberRecords[0].memberId} written to commission-members.csv`);
    });
  },
};
