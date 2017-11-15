#!/bin/bash

# Bash script for building the ACM ICPC contest image
# Version: 0.9

set -xe

if [ -z $LIVE_BUILD ]
then
    export USER=acm
    export HOME=/home/$USER
else
    export USER=root
    export HOME=/etc/skel
fi


# ----- Initilization -----

cat << EOF >/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ xenial main restricted universe
deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe
EOF


# Add missing repositories
add-apt-repository -y ppa:damien-moore/codeblocks-stable
apt-add-repository -y ppa:mmk2410/intellij-idea
add-apt-repository -y ppa:webupd8team/atom
echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -sc)-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list
wget -q -O - http://archive.getdeb.net/getdeb-archive.key | apt-key add -

# Update packages list
apt-get -y update
apt-get -y purge thunderbird example-content

# Upgrade everything if needed
apt-get -y upgrade


# ----- Install software from Ubuntu repositories -----

# Compilers
apt-get -y install gcc-5 g++-5 openjdk-8-jdk openjdk-8-source

# Editors and IDEs
apt-get -y install codeblocks codeblocks-contrib emacs geany geany-plugins netbeans
apt-get -y install gedit vim-gnome vim kate nano
apt-get -y install intellij-idea-community
apt-get -y install pycharm
apt-get -y install atom
apt-get -y install idle-python2.7 idle-python3.5

# Debuggers
apt-get -y install ddd libappindicator1 libindicator7 libvte9 valgrind visualvm

# Interpreters
apt-get -y install python2.7 python3.5 ruby pypy

# Documentation
apt-get -y install stl-manual openjdk-8-doc python2.7-doc python3.5-doc pypy-doc

# Other Software
apt-get -y install firefox konsole mc


# ----- Install software not found in Ubuntu repositories -----

cd /tmp/

# CPP Reference
wget http://upload.cppreference.com/mwiki/images/7/78/html_book_20151129.zip
unzip html_book_20151129.zip -d /opt/cppref

# Visual Studio Code
apt-get -y install git
wget -O vscode-amd64.deb https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable
dpkg -i vscode-amd64.deb
su $USER -c "mkdir -p $HOME/.config/Code/User"

# Visual Studio Code - extensions
su $USER -c "mkdir -p $HOME/.vscode/extensions"
su $USER -c "HOME=$HOME code --user-data-dir=$HOME/.config/Code/ --install-extension ms-vscode.cpptools"
su $USER -c "HOME=$HOME code --user-data-dir=$HOME/.config/Code/ --install-extension georgewfraser.vscode-javac"
su $USER -c "HOME=$HOME code --user-data-dir=$HOME/.config/Code/ --install-extension magicstack.MagicPython"

# Eclipse 4.7 and CDT plugins
wget http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/oxygen/R/eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz
tar xzvf eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz -C /opt/
mv /opt/eclipse /opt/eclipse-4.7
/opt/eclipse-4.7/eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.eclipse.org/releases/oxygen \
-installIUs \
org.eclipse.cdt.feature.group,\
org.eclipse.cdt.build.crossgcc.feature.group,\
org.eclipse.cdt.launch.remote,\
org.eclipse.cdt.gnu.multicorevisualizer.feature.group,\
org.eclipse.cdt.testsrunner.feature.feature.group,\
org.eclipse.cdt.visualizer.feature.group,\
org.eclipse.cdt.debug.ui.memory.feature.group,\
org.eclipse.cdt.autotools.core,\
org.eclipse.cdt.autotools.feature.group,\
org.eclipse.linuxtools.valgrind.feature.group,\
org.eclipse.linuxtools.profiling.feature.group,\
org.eclipse.remote.core,\
org.eclipse.remote.feature.group,\
org.python.pydev.feature.feature.group
ln -s /opt/eclipse-4.7/eclipse /usr/bin/eclipse

# Sublime Text 3
wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
dpkg -i sublime-text_build-3126_amd64.deb
# Update C++ build command
wget http://ioi2017.org/files/htc/C++.sublime-package
mv C++.sublime-package /opt/sublime_text/Packages

# Atom
apm install atom-beautify autocomplete-python autocomplete-java language-cpp14

chmod +x /opt/*.sh

# ----- Create desktop entries -----

cd /usr/share/applications/

cat << EOF > python3.5-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 3.5 Documentation
Comment=Python 3.5 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python3.5/html/index.html
Terminal=false
Categories=Documentation;Python3.5;
EOF

cat << EOF > python2.7-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 2.7 Documentation
Comment=Python 2.7 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python2.7/html/index.html
Terminal=false
Categories=Documentation;Python2.7;
EOF

cat << EOF > pypy-doc.desktop
[Desktop Entry]
Type=Application
Name=PyPy 2.7 Documentation
Comment=PyPy 2.7 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/pypy-doc/html/index.html
Terminal=false
Categories=Documentation;Python2.7;
EOF

cat << EOF > eclipse.desktop
[Desktop Entry]
Type=Application
Name=Eclipse Neon
Comment=Eclipse Integrated Development Environment
Icon=/opt/eclipse-4.7/icon.xpm
Exec=eclipse
Terminal=false
Categories=Development;IDE;Java;
EOF

cat << EOF > cpp-doc.desktop
[Desktop Entry]
Type=Application
Name=C++ Documentation
Comment=C++ Documentation
Icon=firefox
Exec=firefox /opt/cppref/reference/en/index.html
Terminal=false
Categories=Documentation;C++;
EOF

cat << EOF > java-doc.desktop
[Desktop Entry]
Type=Application
Name=Java Documentation
Comment=Java Documentation
Icon=firefox
Exec=firefox /usr/share/doc/openjdk-8-doc/api/index.html
Terminal=false
Categories=Documentation;Java;
EOF

cat << EOF > stl-manual.desktop
[Desktop Entry]
Type=Application
Name=STL Manual
Comment=STL Manual
Icon=firefox
Exec=firefox /usr/share/doc/stl-manual/html/index.html
Terminal=false
Categories=Documentation;STL;
EOF

mkdir -p "$HOME/Desktop/Editors & IDEs"
mkdir -p "$HOME/Desktop/Utils"
mkdir -p "$HOME/Desktop/Docs"

chown $USER "$HOME/Desktop/Editors & IDEs"
chown $USER "$HOME/Desktop/Utils"
chown $USER "$HOME/Desktop/Docs"

# Copy Editors and IDEs
for i in gedit codeblocks emacs24 geany org.kde.kate sublime_text eclipse code vim gvim intellij-idea-community idle-python2.7 idle-python3.5 pycharm atom netbeans
do
    cp "$i.desktop" "$HOME/Desktop/Editors & IDEs"
done

# Copy Docs
for i in cpp-doc stl-manual java-doc python2.7-doc python3.5-doc pypy-doc
do
    cp "$i.desktop" "$HOME/Desktop/Docs"
done

# Copy Utils
for i in ddd gnome-calculator gnome-terminal mc org.kde.konsole visualvm
do
    cp "$i.desktop" "$HOME/Desktop/Utils"
done

chmod a+x "$HOME/Desktop/Editors & IDEs"/*
chmod a+x "$HOME/Desktop/Utils"/*
chmod a+x "$HOME/Desktop/Docs"/*


# Set desktop settings
apt-get install -y xvfb
if [ -z $LIVE_BUILD ]
then
    cp live/files/wallpaper.png /opt/wallpaper.png
fi
xvfb-run gsettings set org.gnome.desktop.background primary-color "#000000000000"
xvfb-run gsettings set org.gnome.desktop.background picture-options "centered"
xvfb-run gsettings set org.gnome.desktop.background picture-uri "file:///opt/wallpaper.png"
