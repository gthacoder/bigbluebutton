const Page = require('./page');

const pageObject = new Page();

class LandingPage extends Page {
  get meetingNameInputSelector() {
    return 'input[name=meetingname]';
  }

  get meetingNameInputElement() {
    return $(this.meetingNameInputSelector);
  }

  // ////////

  get usernameInputSelector() {
    return 'input[name=username]';
  }

  get usernameInputElement() {
    return $(this.usernameInputSelector);
  }

  // ////////

  joinWithButtonClick() {
    this.joinButtonElement.click();
  }

  joinWithEnterKey() {
    pageObject.pressEnter();
  }

  // ////////

  get joinButtonSelector() {
    return 'input[type=submit]';
  }

  get joinButtonElement() {
    return $(this.joinButtonSelector);
  }
}

module.exports = new LandingPage();
