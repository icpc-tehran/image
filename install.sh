#!/bin/bash

# Bash script for building the ACM ICPC contest image
# Version: 1.4

set -xe

if [ -z $LIVE_BUILD ]
then
    export USER=icpc
    export HOME=/home/$USER
else
    export USER=root
    export HOME=/etc/skel
fi


# ----- Initilization -----

cat << EOF >/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ bionic main restricted universe
deb http://security.ubuntu.com/ubuntu/ bionic-security main restricted universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe
EOF

# Add missing repositories
add-apt-repository -y ppa:webupd8team/atom

# Update packages list
apt-get -y update

# Purge extra packages
apt-get -y autoremove --purge libreoffice\* thunderbird example-content gimp inkscape shotwell webbrowser-app simple-scan vino remmina transmission\* evolution gnome-calendar brasero cheese rhythmbox totem

# Upgrade everything if needed
apt-get -y upgrade

# ----- Install software from Ubuntu repositories -----

# Compilers
apt-get -y install gcc-5 g++-5 openjdk-8-jdk openjdk-8-source cmake

# Editors and IDEs
apt-get -y install codeblocks codeblocks-contrib emacs geany geany-plugins
apt-get -y install gedit vim-gnome vim kate kdevelop nano
apt-get -y install atom
apt-get -y install idle-python2.7 idle-python3.6

# Debuggers
apt-get -y install ddd libappindicator1 libindicator7 libvte9 valgrind visualvm

# Interpreters
apt-get -y install python2.7 python3.6 ruby pypy

# Documentation
apt-get -y install stl-manual openjdk-8-doc python2.7-doc python3.6-doc

# Other Software
apt-get -y install firefox konsole mc goldendict gnome-calculator axel


# ----- Install software not found in Ubuntu repositories -----
cd /tmp/


# CPP Reference
axel http://upload.cppreference.com/mwiki/images/7/78/html_book_20151129.zip
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

# netbeans
axel https://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-javase-linux.sh
chmod +x ./netbeans-8.2-javase-linux.sh
./netbeans-8.2-javase-linux.sh --silent

# Idea
axel https://download.jetbrains.com/idea/ideaIC-2018.3.tar.gz
tar xzvf ideaIC-2018.3.tar.gz -C /opt/

# PyCharm
axel https://download.jetbrains.com/python/pycharm-community-2018.3.tar.gz
tar xzvf pycharm-community-2018.3.tar.gz -C /opt/


# Eclipse 4.7 and CDT plugins
axel http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/oxygen/R/eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz
tar xzvf eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz -C /opt/
mv /opt/eclipse /opt/eclipse-4.7
wget -O pydev.zip https://sourceforge.net/projects/pydev/files/pydev/PyDev%205.8.0/PyDev%205.8.0.zip/download
unzip pydev.zip -d /opt/eclipse-4.7/dropins
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
org.eclipse.remote.feature.group
ln -s /opt/eclipse-4.7/eclipse /usr/bin/eclipse

# Sublime Text 3
axel https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
dpkg -i sublime-text_build-3126_amd64.deb
# Atom
apm install atom-beautify autocomplete-python autocomplete-java language-cpp14

# ----- Create desktop entries -----

cd /usr/share/applications/

cat << EOF > netbeans-8.2.desktop
[Desktop Entry]
Encoding=UTF-8
Name=NetBeans IDE 8.2
Comment=The Smarter Way to Code
Exec=/usr/local/netbeans-8.2/bin/netbeans --jdkhome  /usr/lib/jvm/java-8-openjdk-amd64/
Icon=/usr/local/netbeans-8.2/nb/netbeans.png
Categories=Application;Development;Java;IDE
Version=1.0
Type=Application
Terminal=0
EOF

cat << EOF > idea.desktop
[Desktop Entry]
Type=Application
Name=Intellij IDEA
Comment=Intellij IDEA
Icon=/opt/idea-IC-183.4284.148/bin/idea.png
Exec=/opt/idea-IC-183.4284.148/bin/idea.sh
Terminal=false
Categories=IDE;Intellij;IDEA;Code;Java;
EOF

cat << EOF > pycharm.desktop
[Desktop Entry]
Type=Application
Name=PyCharm
Comment=PyCharm
Icon=/opt/pycharm-community-2018.3/bin/pycharm.png
Exec=/opt/pycharm-community-2018.3/bin/pycharm.sh
Terminal=false
Categories=IDE;PyCharm;Code;Python;
EOF


cat << EOF > python3.6-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 3.6 Documentation
Comment=Python 3.6 Documentation
Icon=firefox
Exec=firefox /usr/share/doc/python3.6/html/index.html
Terminal=false
Categories=Documentation;Python3.6;
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

cat << EOF > eclipse.desktop
[Desktop Entry]
Type=Application
Name=Eclipse Oxygen
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
for i in gedit codeblocks emacs25 geany org.kde.kate sublime_text eclipse code vim gvim org.kde.kdevelop idea idle-python2.7 idle-python3.6 pycharm atom netbeans-8.2
do
    cp "$i.desktop" "$HOME/Desktop/Editors & IDEs"
done

# Copy Docs
for i in cpp-doc stl-manual java-doc python2.7-doc python3.6-doc
do
    cp "$i.desktop" "$HOME/Desktop/Docs"
done

# Copy Utils
for i in ddd org.gnome.Calculator gnome-terminal mc org.kde.konsole visualvm goldendict
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
    cp live/files/C++.sublime-package /opt/sublime_text/Packages
    mkdir -p /usr/share/dictd
    cp live/files/dicts/* /usr/share/dictd
fi

xvfb-run gsettings set org.gnome.desktop.background primary-color "#000000000000"
xvfb-run gsettings set org.gnome.desktop.background picture-options "scaled"
xvfb-run gsettings set org.gnome.desktop.background picture-uri "file:///opt/wallpaper.png"

echo "Done!"

