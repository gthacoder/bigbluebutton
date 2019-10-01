const Page = require('./page');

class ChatPage extends Page {
  get chatMessageInputSelector() {
    return '#message-input';
  }

  get chatMessageInputElement() {
    return $(this.chatMessageInputSelector);
  }

  sendChatMessage(message) {
    this.chatMessageInputElement.setValue(message);
    this.sendMessageButtonElement.click();
  }

  // ////////

  get publicChatSelector() {
    return '[data-test=publicChat]';
  }

  get publicChatElement() {
    return $(this.publicChatSelector);
  }

  // ////////

  get userListItemNotCurrentSelector() {
    return '[data-test=userListItemNotCurrent]';
  }

  get userListItemNotCurrentElement() {
    return $(this.userListItemNotCurrentSelector);
  }

  // ////////

  get startPrivateChatSelector() {
    return '[data-test=activeChat]';
  }

  get startPrivateChatElement() {
    return $(this.startPrivateChatSelector);
  }

  // ////////

  get chatTitleSelector() {
    return '[data-test=chatTitle]';
  }

  get chatTitleElement() {
    return $(this.chatTitleSelector);
  }

  // ////////

  get chatDropdownTriggerSelector() {
    return '[data-test=chatDropdownTrigger]';
  }

  get chatDropdownTriggerElement() {
    return $(this.chatDropdownTriggerSelector);
  }

  triggerChatDropdown() {
    this.chatDropdownTriggerElement.click();
  }

  // ////////

  get clearChatButtonSelector() {
    return '[data-test=chatClear]';
  }

  get clearChatButtonElement() {
    return $(this.clearChatButtonSelector);
  }

  clearChat() {
    this.clearChatButtonElement.click();
  }

  // ////////

  get saveChatButtonSelector() {
    return '[data-test=chatSave]';
  }

  get saveChatButtonElement() {
    return $(this.saveChatButtonSelector);
  }

  saveChat() {
    this.saveChatButtonElement.click();
  }

  // ////////

  get copyChatButtonSelector() {
    return '[data-test=chatCopy]';
  }

  get copyChatButtonElement() {
    return $(this.copyChatButtonSelector);
  }

  copyChat() {
    this.copyChatButtonElement.click();
  }

  // ////////

  get sendMessageButtonSelector() {
    return '[data-test=sendMessageButton]';
  }

  get sendMessageButtonElement() {
    return $(this.sendMessageButtonSelector);
  }
}

module.exports = new ChatPage();
