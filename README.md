This repo contains scripts and documentation for setting up my mac development environment.

Specifically I need to be able to run multiple versions of Ruby, and use test kitchen and azure-cli among other things to interact with Azure, build images and test them in Vagrant.

OVERVIEW OF PROCESS:
- Install/Configure RBENV
- Fetch the Chef Bento project in git
- Install/Configure PACKER (to create VIRTUAL BOX ISO for Windows 2019 Server standalone)
- Install/Configure VAGRANT, VIRTUAL BOX (for vagrant hosts)
- Install/Configure AZURE-CLI (for Azure madlab, bluelab hosts)

Instructions:
- Refer to setup_rbenv.txt (for setting up rbenv, vagrant, virtual box, azure-cli)
  Refer to setup_rbenv_output.txt (for output for setting up rbenv,
  Refer to azure_cli_upgrade.txt (for output for updating azure-cli)

- Refer to setup_packer.txt (for setting up packer and creating a windows 2019 standard virtual box ISO using the chef bento git project)
- Refer to setup_packer.txt for instructions on installing packer and using it to manually build your own Chef bento box from the git repo (or virtual box ISO). This is useful/somewhat necessary
  for testing Microsoft Windows server builds since most publicly available stuff is either a) not vanilla, and/or b) just not available because of Windows licensing.  For example,
  Hashicorp Vagrant Cloud provides various 3rd party builds but nothing as specific as what we want (actual MS evaluation biuld)



