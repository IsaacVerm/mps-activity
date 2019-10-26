const puppeteer = require('puppeteer');
var csv = require('./write-to-csv');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://vlaanderenkiest.be/verkiezingen2019/#/parlement/02000/verkozenen');

  const names = await page.evaluate(() =>
    Array.from(document.querySelectorAll('.candidate-table tr td:nth-child(3)'), element =>
      element.textContent.trim(),
    ),
  );

  const votes = await page.evaluate(() =>
    Array.from(
      document.querySelectorAll('.candidate-table tr td:nth-child(4)'),
      element => element.textContent,
    ),
  );

  const electionResultRecords = csv.createElectionResultRecords(names, votes);
  console.log(electionResultRecords);
  csv.writeElectionResultsToCsv(electionResultRecords);

  browser.close();
})();
