const chai = require('chai');
const clipboardy = require('clipboardy');
const ModalPage = require('../pageobjects/modal.page');
const ChatPage = require('../pageobjects/chat.page');
const Utils = require('../utils');

const WAIT_TIME = 10000;
const message = 'Hello';

describe('Chat', () => {
  beforeEach(() => {
    Utils.configureViewport();
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 30000;
  });

  it('user should be able to send a public chat messageand another user should be able to read it',
    () => {
      const meetingId = Utils.createMeeting();

      // moderator1 joining
      Utils.joinMeeting(meetingId, 'moderator1', 'mp', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator1 sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      const message1 = 'public message from moderator1';
      ChatPage.sendChatMessage(message1);

      // moderator2 joining
      Utils.joinMeeting(meetingId, 'moderator2', 'mp', true);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator2 reading the public chat
      chai.expect(browser.getHTML(ChatPage.publicChatSelector)).to.include(message1);
    });

  it('user should be able to send a private chat message and another user should see that there is a new message',
    () => {
      const meetingId = Utils.createMeeting();

      // moderator1 joining
      Utils.joinMeeting(meetingId, 'moderator1', 'mp', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      const window1 = browser.windowHandle();

      // moderator2 joining
      Utils.joinMeeting(meetingId, 'moderator2', 'mp', true);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator2 sending a private chat message to moderator1
      browser.waitForExist(ChatPage.userListItemNotCurrentSelector, WAIT_TIME);
      ChatPage.userListItemNotCurrentElement.click();
      browser.waitForExist(ChatPage.startPrivateChatSelector, WAIT_TIME);
      ChatPage.startPrivateChatElement.click();
      const message1 = 'private message from moderator2';
      ChatPage.sendChatMessage(message1);

      chai.expect(browser.getHTML(ChatPage.chatTitleSelector)).to.include('moderator1');

      // switching to moderator1
      browser.window(window1.value);

      $('[data-test=chatButton] [aria-label="1 New Message"]').isExisting();
    });

  it('moderator should be able to save chat',
    () => {
      const meetingId = Utils.createMeeting();

      // moderator joining
      Utils.joinMeeting(meetingId, 'moderator', 'mp', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      ChatPage.sendChatMessage(message);

      // moderator saving chat
      browser.waitForExist(ChatPage.chatDropdownTriggerSelector, WAIT_TIME);
      ChatPage.triggerChatDropdown();
      browser.waitForExist(ChatPage.saveChatButtonSelector, WAIT_TIME);
      ChatPage.saveChat();
    });

  it('attendee should be able to save chat',
    () => {
      const meetingId = Utils.createMeeting();

      // attendee joining
      Utils.joinMeeting(meetingId, 'attendee', 'ap', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // attendee sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      ChatPage.sendChatMessage(message);

      // attendee saving chat
      browser.waitForExist(ChatPage.chatDropdownTriggerSelector, WAIT_TIME);
      ChatPage.triggerChatDropdown();
      browser.waitForExist(ChatPage.saveChatButtonSelector, WAIT_TIME);
      ChatPage.saveChat();
    });

  it('moderator should be able to copy chat',
    () => {
      const meetingId = Utils.createMeeting();
      const username = 'moderator';

      // moderator joining
      Utils.joinMeeting(meetingId, username, 'mp', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      ChatPage.sendChatMessage(message);

      // moderator copying chat
      browser.waitForExist(ChatPage.chatDropdownTriggerSelector, WAIT_TIME);
      ChatPage.triggerChatDropdown();
      browser.waitForExist(ChatPage.copyChatButtonSelector, WAIT_TIME);
      ChatPage.copyChat();

      // copied chat content
      const copiedChat = clipboardy.readSync();
      chai.expect(copiedChat).to.include(`${username} : ${message}`);
    });

  it('attendee should be able to copy chat',
    () => {
      const meetingId = Utils.createMeeting();
      const username = 'attendee';

      // attendee joining
      Utils.joinMeeting(meetingId, username, 'ap', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // attendee sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      ChatPage.sendChatMessage(message);

      // attendee copying chat
      browser.waitForExist(ChatPage.chatDropdownTriggerSelector, WAIT_TIME);
      ChatPage.triggerChatDropdown();
      browser.waitForExist(ChatPage.copyChatButtonSelector, WAIT_TIME);
      ChatPage.copyChat();

      // copied chat content
      const copiedChat = clipboardy.readSync();
      chai.expect(copiedChat).to.include(`${username} : ${message}`);
    });

  it('moderator should be able to clear chat',
    () => {
      const meetingId = Utils.createMeeting();

      // moderator joining
      Utils.joinMeeting(meetingId, 'moderator', 'mp', false);
      browser.waitForExist(ModalPage.modalCloseSelector, WAIT_TIME);
      ModalPage.closeAudioModal();

      // moderator sending a public chat message
      browser.waitForExist(ChatPage.chatMessageInputSelector, WAIT_TIME);
      ChatPage.sendChatMessage(message);

      // moderator clearing chat
      browser.waitForExist(ChatPage.chatDropdownTriggerSelector, WAIT_TIME);
      ChatPage.triggerChatDropdown();
      browser.waitForExist(ChatPage.clearChatButtonSelector, WAIT_TIME);
      ChatPage.clearChat();
    });
});
