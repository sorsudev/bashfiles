robo3tName=robo3t-1.2.1-linux-x86_64-3e50a65
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod start
cd /tmp
wget https://download.robomongo.org/1.2.1/linux/$robo3tName.tar.gz
sudo tar -zxvf $robo3tName.tar.gz  -C /opt
sudo ln -s /opt/$robo3tName/bin/robo3t /usr/bin/robo3t
rm $robo3tName.tar.gz
sudo wget -O /opt/$robo3tName/robo3t.png https://robomongo.org/static/robomongo-128x128-129df2f1.png
cat > ~/.local/share/applications/robo3t.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Robo3T
Exec=/opt/$robo3tName/bin/robo3t
Icon=/opt/$robo3tName/robo3t.png
Terminal=false
Type=Application
Categories=Development;
StartupNotify=true
EOL
sudo rm /opt/robo3t-1.1.1-linux-x86_64-c93c6b0/lib/libstdc++*
