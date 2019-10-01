const chai = require('chai');
const sha1 = require('sha1');

const WAIT_TIME = 10000;

const generateRandomMeetingId = function () {
  return `random-${Math.floor(1000000 + 9000000 * Math.random())}`;
};

class Utils {
  configureViewport() {
    browser.setViewportSize({
      width: 1366,
      height: 768,
    });
  }

  createMeeting() {
    const meetingId = generateRandomMeetingId();
    const query = `name=${meetingId}&meetingID=${meetingId}&attendeePW=ap`
      + '&moderatorPW=mp&joinViaHtml5=true&welcome=Welcome';
    const checksum = sha1(`create${query}${process.env.TESTING_SECRET}`);
    const url = `${process.env.TESTING_SERVER}create?${query}&checksum=${checksum}`;

    browser.url(url);
    browser.waitForExist('body', WAIT_TIME);
    chai.expect($('body').getText()).to.include('<returncode>SUCCESS</returncode>');

    return meetingId;
  }

  joinMeeting(meetingId, fullName, pw, inNewWindow) {
    const query = `fullName=${fullName}&joinViaHtml5=true`
      + `&meetingID=${meetingId}&password=${pw}`;
    const checksum = sha1(`join${query}${process.env.TESTING_SECRET}`);
    const url = `${process.env.TESTING_SERVER}join?${query}&checksum=${checksum}`;
    if (inNewWindow) {
      browser.newWindow(url);
    } else {
      browser.url(url);
    }
  }
}

module.exports = new Utils();
