const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.goto('localhost');
  await page.screenshot({ path: 'localhost.png' });

  await browser.close();
})();
