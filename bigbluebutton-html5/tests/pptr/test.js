const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.goto('http://127.0.0.1');
  await page.screenshot({ path: 'localhost.png' });

  await browser.close();
})();
