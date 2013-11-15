#!/usr/bin/python
import sys
import json
import keypair
from time import sleep

sys.path.append(keypair.distroRoot + '/ipc/python');
sys.path.append(keypair.distroRoot + '/interfaces/skype/python');

username = 'ushbot';
password = '53l9aDpjribz5mOb0q0t';
loggedIn = False;

try:
  import Skype;
except ImportError:
  raise SystemExit('Program requires Skype and skypekit modules')

def OnMessage(self, message, changesInboxTimestamp, supersedesHistoryMessage, conversation):
  if message.author != username:
    #print(message.author_displayname + ': ' + message.body_xml);
    #conversation.PostText('Automated reply.', False);
    json_string = json.dumps({
      'user': message.author,
      'message': message.body_xml,
      'room': conversation.identity,
    })
    #print json_string
    sys.stdout.write(json_string + '\n')
    sys.stdout.flush()

Skype.Skype.OnMessage = OnMessage;

try:
  MySkype = Skype.GetSkype(keypair.keyFileName);
  MySkype.Start();
except Exception:
  raise SystemExit('Unable to create Skype instance')

#----------------------------------------------------------------------------------
# Defining our own Account property change callback and assigning it to the
# SkyLib.Account class.

def AccountOnChange (self, property_name):
  global loggedIn;
  if property_name == 'status':
    #print ('Login sequence: ' + self.status);
    if self.status == 'LOGGED_IN':
      loggedIn = True;
    if self.status == 'LOGGED_OUT':
      loggedIn = False;

Skype.Account.OnPropertyChange = AccountOnChange;

#----------------------------------------------------------------------------------
# Retrieving account and logging in with it.

account = MySkype.GetAccount(username);
#print('Logging in with ' + username);
account.LoginWithPassword(password, False, False);

while True:
  if (loggedIn):
    line = sys.stdin.readline()
    try:
      decoded = json.loads(line)
      print decoded
      conversation = MySkype.GetConversationByIdentity(decoded['room'])
      conversation.PostText(decoded['message'])
    except:
      continue
