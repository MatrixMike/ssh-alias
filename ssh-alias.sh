#!/bin/sh
echo "This will setup keypair-authentication so you would not need password to connect to server anymore"

# ssh_alias=""
echo "SSH alias?"; read ssh_alias

# ssh_user="root"
echo "Username?"; read ssh_user

# ssh_server=""
echo "Server IP?"; read ssh_server

# ssh_port="22"
echo "Port?"; read ssh_port


ssh_keyfile=$HOME"/.ssh/"${ssh_alias}"_rsa"
echo -e "\n\n\n" | ssh-keygen -t rsa -f $ssh_keyfile -N ""

if [ ! -f /usr/local/bin/ssh-copy-id ]; then
	echo "Installing ssh-copy-id"
	curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh
fi

echo "Installing the key on the server "$ssh_server
ssh_string=$(echo $ssh_user"@"$ssh_server" -p"$ssh_port" -o PubkeyAuthentication=no")
echo "ssh_string: $ssh_string"
ssh-copy-id -i $ssh_keyfile "$ssh_string"

echo "Updating .ssh/config on your machine"
echo "\n\n# An alias to connect to "$ssh_alias" server\nHost "$ssh_alias"\n\tHostname "$ssh_server"\n\tUser "$ssh_user"\n\tPort "$ssh_port"\n\tIdentityFile "$ssh_keyfile"\n\tIdentitiesOnly yes\n\n" >> $HOME/.ssh/config

echo "SSH into server using the alias"
ssh $ssh_alias
