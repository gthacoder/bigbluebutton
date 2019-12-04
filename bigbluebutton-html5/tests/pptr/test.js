const puppeteer = require('puppeteer');

let browser;
let page;

before(async () => {
  browser = await puppeteer.launch({
    args: ['--no-sandbox'],
  });
  page = await browser.newPage();
})

describe('Test', () => {
  it('works', async () => {
    await page.goto('http://127.0.0.1');
  });
});

after(async () => {
  await browser.close()
});

/*(async () => {
  const browser = await puppeteer.launch({
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.goto('http://127.0.0.1');
  await page.screenshot({ path: 'localhost.png' });

  await browser.close();
})();*/
