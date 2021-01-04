# mm.sh

Quickly set up self-hosted, containerized (via Docker) [Modmail](https://github.com/kyb3r/modmail) bots from nothing.

I will gladly admit that this guide is lackluster, the script has bugs and I am not perfect at using Docker yet. Feel free to open issues and tell me I'm stupid.

## What do I need to run this?

bash, an Ubuntu-based system, and direct kernel access (if you're using a VPS, you'll want something like QEMU/KVM or VMWare. OpenVZ will not work).

You'll also need [a bot](https://discordapp.com/developers/applications/me) and its token.

## How do I run this?

Read the script first, then open a terminal and:
```
wget https://github.com/antigravities/mm.sh/blob/master/mm.sh
chmod +x mm.sh
sudo ./mm.sh
```

## I made changes to .env. How do I apply them?

I plan on adding functionality to do this automatically in a later release, but for now you'll need to rebuild the container:

```
SUFFIX="your suffix"
cd modmail-$SUFFIX
sudo docker stop modmail-$SUFFIX
sudo docker rm modmail-$SUFFIX
sudo docker run -it --env-file .env --network "modmail-$SUFFIX" --name "modmail-$SUFFIX" --restart always -d kyb3rr/modmail
```

## It's quite worrying that anyone can view modmail logs if they just guess the URL! Is there a way to password-protect them?

Yes. This is out of scope (at least for now), but use HTTP Basic Authentication with a Web server of your choice.

## Do you disable all of the [scary, unnecessary, difficult-to-disable data collection](https://github.com/kyb3r/modmail/blob/master/PRIVACY.md) the bot does?

Yes, by default.

## I want to contribute! How do I go about that?

I am not currently accepting code contributions to this repository. Make sure you've read [the LICENSE](https://github.com/antigravities/mm.sh/blob/master/LICENSE) before making any modifications to the script.

## License this more permissively, you GNU/Traitor.

That isn't a question. And if it was a question, the answer would be "no".

## I need help!

Open an [issue](https://github.com/antigravities/mm.sh/issues).
