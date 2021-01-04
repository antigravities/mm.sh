#!/bin/bash
set -e

echo "Enter your bot token below. Use a new bot for each guild you plan to set up: "
read TOKEN

echo "Enter the target guild ID. To find this, enable developer mode and right click the picture of the guild: "
read GUILD

echo "Enter your discord ID. To find this, enable developer mode and right click your name: "
read OWNER

echo "Enter the port to run the modmail logs server on. This must be unique if you plan on running multiple bots and should be higher than 1024. Enter 8000 if you're not sure and do not plan on running multiple bots: "
read PORT

echo "Enter a suffix for your modmail bot's containers. This must be unique if you plan on running multiple bots, and should have NO spaces: "
read SUFFIX

echo -n "Now is a good time to add your bot to the target guild. Do this and then press ENTER: "
read

echo "Your modmail bot will be installed in 5 seconds. Press Ctrl-C and try again if any of the following aren't correct:"
echo "Bot token         $TOKEN"
echo "Target guild      $GUILD"
echo "Bot owner         $OWNER"
echo "Container suffix  $SUFFIX"

sleep 5

# install docker
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# create docker vnet
sudo docker network create "modmail-$SUFFIX"

# install mongodb
sudo docker run -it --name "modmail-mongodb-$SUFFIX" --restart always -d mongo

# prepare modmail env
mkdir "modmail-$SUFFIX"
cd "modmail-$SUFFIX"
echo "TOKEN=$TOKEN
LOG_URL=http://$(hostname -I | cut -d' ' -f1):$PORT/
GUILD_ID=$GUILD
MODMAIL_GUILD_ID=$GUILD
OWNERS=$OWNER
CONNECTION_URI=mongodb://modmail-mongodb-$SUFFIX:27017/modmail_bot
MONGO_URI=mongodb://modmail-mongodb-$SUFFIX:27017/modmail_bot
DATA_COLLECTION=off" > .env

# create and run modmail, modmail-logs and link them to mongodb
sudo docker run -it --env-file .env --network "modmail-$SUFFIX" --name "modmail-$SUFFIX" --restart always -d kyb3rr/modmail
sudo docker run -it -p $PORT:8000 --env-file .env --network "modmail-$SUFFIX" --name "modmail-logs-$SUFFIX" --restart always -d kyb3rr/logviewer

echo "Modmail is now installed. Access the logs at http://$(hostname -I | cut -d' ' -f1):$PORT/."
