module.exports = {
  extractCommissionIds: function(commissions) {
    const commissionIds = commissions.data.items.map(commission =>
      commission.commissie.id.toString(),
    );
    return commissionIds;
  },
  extractPersonsPresentDetails: function(meeting) {
    const indexPresent = 0;
    return meeting.vergadering.aanwezigheid[indexPresent].persoon.map(person => {
      return {
        firstName: person.voornaam,
        lastName: person.naam,
        id: person.id,
        partyName: person.fractie.naam,
        partyId: person.fractie.id,
        gender: person.aanspreking,
      };
    });
  },
  extractMeetingDetails: function(meeting) {
    return {
      id: meeting.vergadering.id,
      commissionName: meeting.vergadering.commissie[0].afkorting,
      commissionId: meeting.vergadering.commissie[0].id,
      start: meeting.vergadering.datumbegin,
      end: meeting.vergadering.datumeinde,
      description: meeting.vergadering['omschrijving-kort'],
    };
  },
};
