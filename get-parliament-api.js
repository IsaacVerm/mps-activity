var axios = require('axios');

module.exports = {
  domain: 'http://ws.vlpar.be/e/opendata',
  getCommissionsInLegislature: function(domain, legislature) {
    const url = domain + '/comm/legislatuur?legislatuur=' + legislature;
    return axios.get(url);
  },
  getMeetings: function(domain, year, month, commissionId) {
    const searchParams = {
      params: { year: year, month: month, type: 'comm', idComm: commissionId },
    };

    return axios.get(domain + '/verg/volledig/zoek', searchParams);
  },
  getCommissionMembers: function(domain, commissionId) {
    return axios.get(domain + '/comm/' + commissionId);
  },
  getElectionResults: function() {
    return axios.get('https://vlaanderenkiest.be/verkiezingen2019/#/parlement/02000/verkozenen');
  },
};
