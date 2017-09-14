#!/bin/bash

#放置安装文件
installPath="$HOME/installFile"
if [[ ! -d $installPath ]];then
    mkdir $installPath
fi

#日志信息
LoggingFile="$HOME/install.log"
touch $LoggingFile
exec 2>$LoggingFile

aptFile="softList"

cat $aptFile | while read Line
do
    sudo apt-get install $Line
    if [[ ! $? -eq 0 ]];then
        echo "Install $Line Fail" >&2
    fi
done
exit

#首先删除不必要的软件
sudo apt-get remove libreoffice-common unity-webapps-common thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install onboard deja-dup
sudo apt autoremove

#把源设置为阿里云源
sudo ./sources/setSource.sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt autoremove


#安装vim配置文件
wget -qO- https://raw.github.com/ma6174/vim/master/setup.sh | sh -x


#安装python相关
#1.pyenv，python环境管理
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
#2.安装python3.6
sudo pyenv install 3.6.1


#安装autojump
git clone git://github.com/joelthelion/autojump.git $installPath/autojump && cd $installPath/autojump && ./install.py
#终端的颜色表
wget -O xt  http://git.io/v3Dll && chmod +x xt && ./xt && rm xt
#安装oh-my-git
git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~/.bashrc
#oh-my-git需要的字体，需手动设置终端字体为SourceCodePro+Powerline+Awesome Regular
cd /tmp && git clone http://github.com/gabrielelana/awesome-terminal-fonts && cd awesome-terminal-fonts && git checkout patching-strategy && mkdir -p ~/.fonts && cp patched/*.ttf ~/.fonts
sudo fc-cache -fv ~/.fonts
