var get = require('./get-parliament-api');
var extract = require('./extract');
var csv = require('./write-to-csv');

get.getCommissionsInLegislature(get.domain, '2014-2019').then(commissionsResponse => {
  const commissionIds = extract.extractCommissionIds(commissionsResponse);
  commissionIds.forEach(commissionId => {
    get.getCommissionMembers(get.domain, commissionId).then(commissionMembersResponse => {
      commissionMembersResponse.data.functie.forEach(typeOfMember => {
        if (typeOfMember.naam == 'plaatsvervangend lid') {
          console.log('member is only acting');
        }

        typeOfMember.lid.forEach(member => {
          const commissionMemberDetails = extract.extractCommissionMemberDetails(member);
          const memberRecords = csv.createMemberRecords(commissionMemberDetails, commissionId);
          csv.writeCommissionMemberToCsv(memberRecords);
        });
      });
    });
  });
});
