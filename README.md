This repo contains scripts and documentation for setting up my mac development environment.

Specifically I need to be able to run multiple versions of Ruby, and use test kitchen and azure-cli among other things to interact with Azure, build images and test them in Vagrant.

Instructions:
- Refer to setup_rbenv.txt (for setting up rbenv, vagrant, virtual box, azure-cli)
  Refer to setup_rbenv_output.txt (for output for setting up rbenv,
  Refer to azure_cli_upgrade.txt (for output for updating azure-cli)

- Refer to setup_packer.txt for instructions on installing packer and using it to manually build your own Chef bento box from the git repo. This is useful/somewhat necessary
  for testing Microsoft Windows server builds since most publicly available stuff is either a) not vanilla, and/or b) just not available because of Windows licensing.



