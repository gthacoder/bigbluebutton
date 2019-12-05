const puppeteer = require('puppeteer');

let browser;
let page;

before(async () => {
  browser = await puppeteer.launch({
    args: ['--no-sandbox'],
  });
  page = await browser.newPage();
});

describe('Test', () => {
  it('works', async () => {
    await page.goto('http://127.0.0.1');
  });
});

after(async () => {
  await browser.close();
});
