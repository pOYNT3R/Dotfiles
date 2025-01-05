# .______        ___           _______. __    __  .______        ______ 
# |   _  \      /   \         /       ||  |  |  | |   _  \      /      |
# |  |_)  |    /  ^  \       |   (----`|  |__|  | |  |_)  |    |  ,----'
# |   _  <    /  /_\  \       \   \    |   __   | |      /     |  |     
# |  |_)  |  /  _____  \  .----)   |   |  |  |  | |  |\  \----.|  `----.
# |______/  /__/     \__\ |_______/    |__|  |__| | _| `._____| \______|
                                                                      
# ~/.bashrc

# Needed packages: lynx exa ls

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Adds `~/.local/bin` to $PATH
export PATH="${HOME}/.scripts:/alt/bin:/usr/local/bin:/bin:/usr/bin:."

# CUSTOM PROMPT
PS1="\W > ";
export PS1;

# Shows time-stamps of history and ignores duplicates
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups

use_color=true

source ~/.cache/wal/colors-tty.sh
(cat ~/.cache/wal/sequences &)

# Archive extraction script
extract() 
{
  [ -f "$1" ] || { echo "'$1' is not a valid file"; return; }
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.deb) ar x "$1" ;;
    *.tar.xz) tar xf "$1" ;;
    *.tar.zst) unzstd "$1" ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
  esac
}

# Archive creation script
compress () 
{
   FILE=$1
   shift
   case $FILE in
      *.tar.bz2) tar cjf $FILE $*  ;;
      *.tar.gz)  tar czf $FILE $*  ;;
      *.tgz)     tar czf $FILE $*  ;;
      *.zip)     zip $FILE $*      ;;
      *.rar)     rar $FILE $*      ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

# Show current network information
netinfo ()
{
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	echo ""
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	echo ""
	/sbin/ifconfig | awk /'inet addr/ {print $4}'

	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	echo "---------------------------------------------------"
}

# Searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp $1 $2 && cd $2
	else
		cp $1 $2
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv $1 $2 && cd $2
	else
		mv $1 $2
	fi
}

# Create and go to the directory
mkdirg ()
{
	mkdir -p $1
	cd $1
}

# Search Arch wiki
wiki ()
{
	search_term=$(echo $@ | sed "s/ /+/g")
	lynx https://wiki.archlinux.org/index.php?search=${search_term}
}

# Goes up a specified number of directories  (i.e. up 4)
up ()
{
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Prints out more readable form ofman pages
whatis ()
{
	curl "https://cheat.sh/$1"
}

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Disabl ctrl-s & ctrl-q
stty -ixon

# Enable case-insensitive tab completion & shows all options
bind "set completion-ignore-case On"
bind "set show-all-if-ambiguous On"

#Allows you to cd into a directory without typing full path
shopt -s autocd 

# autocorrect typos in path names when using `cd`
shopt -s cdspell

# When the command contains an invalid history operation (for instance when
# using an unescaped "!" (I get that a lot in quick e-mails and commit
# messages) or a failed substitution (e.g. "^foo^bar" when there was no "foo"
# in the previous command line), do not throw away the command line, but let me
# correct it.
shopt -s histreedit;

# append to the Bash history file, rather than overwriting it
shopt -s histappend

# rezize the windows-size if needed
shopt -s checkwinsize

# Do not autocomplete when accidentally pressing Tab on an empty line. (It takes
# forever and yields "Display all 15 gazillion possibilites?")
shopt -s no_empty_cmd_completion

#      ___       __       __       ___           _______.
#     /   \     |  |     |  |     /   \         /       |
#    /  ^  \    |  |     |  |    /  ^  \       |   (----`
#   /  /_\  \   |  |     |  |   /  /_\  \       \   \    
#  /  _____  \  |  `----.|  |  /  _____  \  .----)   |   
# /__/     \__\ |_______||__| /__/     \__\ |_______/    

# pkg-install        - install one or more packages
# pkg-update         - upgrade all packages to their newest version
# pkg-remove         - uninstall one or more packages
# pkg-search         - search for a package using one or more keywords
# pkg-install-info   - show information about a package
# pkg-installed      - show if a package is installed
# pkg-installed      - list all installed packages
# pkg-orphan         - list all packages which are orphaned
# pkg-delete-orphan-files       - delete all not currently installed package files
# pkg-show-package-files        - list all files installed by a given package
# pkg-show-owner - show what package owns a given file
# pkg-show-config       - list config files installed by a given package
# pkg-clean          - Removes orphan packages
# pkg-help          - Help for package manager

if [ -e "/usr/bin/apt" ] ; then # Apt-based distros (Debian, Ubuntu, etc.)
  alias pkg-install="sudo apt install "
  alias pkg-update="sudo apt update && sudo apt upgrade"
  alias pkg-clean='sudo apt autoremove'
  alias pkg-yeet='sudo apt purge '
  alias pkg-search="aptcache search "
  alias pkg-installnfo="aptcache show "
  alias pkg-installed="sudo apt list --installed"
  alias pkg-show-package-files="dpkg -L"
  alias pkg-help='sudo apt --help'
elif [ -e "/usr/bin/pacman" ] ; then # Arch Linux
  alias pkg-install="sudo pacman -S "
  alias pkg-update="sudo pacman -Syu"
  alias pkg-yeet="sudo pacman -Rns "
  alias pkg-help='sudo pacman --help'
  alias pkg-search="sudo pacman -Ss "
  alias pkg-install-info="sudo pacman -Si "
  alias pkg-installed="sudo pacman -Q"
  alias pkg-orphan="sudo pacman -Qdt"
  alias pkg-yeet-orphan-files="sudo pacman -Scc"
  alias pkg-show-package-files="sudo pacman -Ql"
  alias pacexpl="sudo pacman -D --asexp"
  alias pkg-installmpl="sudo pacman -D --asdep"
elif [ -e "/usr/bin/yay" ] ; then # Arch Linux AUR
  alias aur-install='sudo yay -S '
  alias aur-update='sudo yay -Sua'
  alias aur-yeet='sudo yay -Rns '
  alias aur-clean='sudo yay -Yc'
  alias aur-search='sudo yay -Ss '
  alias aur-help='yay --help'
elif [ -e "/usr/bin/yum" ] ; then # RPM-based distros
  alias pkg-install="sudo yum install "
  alias pkg-update="sudo yum update"
  alias pkg-yeet="sudo yum remove "
  alias pkg-help='sudo yum --help'
  alias pkg-search="yum search "
  alias pkg-show-package-files="repoquery -lq --installed"
  alias pkg-show-owner="yum whatprovides"
  alias pkg-install-info="yum info"
  alias paclfc="yum -qc"
  alias paccheckforupdates="sudo yum list updates"
elif [ -e "/usr/local/bin/brew" ] ; then # homebrew
  alias pkg-install="brew install "
  alias pkg-update="brew update"
  alias pkg-updatep="brew upgrade"
  alias pkg-help='brew --help'
  alias pkg-search="brew search "
  alias pkg-yeet="brew uninstall "
elif [ -e "/usr/bin/dnf" ] ; then # Fedora-based distros
  alias pkg-install="sudo dnf install "
  alias pkg-help='sudo dnf --help'
  alias pkg-update="sudo dnf update"
  alias pkg-yeet="sudo dnf remove "
  alias pkg-search="dnf search "
  alias pkg-installed="sudo dnf list installed"
  alias pkg-clean='sudo dnf autoremove'
fi

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Colorize output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi"
alias ip="ip -color=auto"

# confirm before overwriting something
alias copy="cp -rvi"
alias move='mv -vi'
alias yeet='rm -i'

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

alias ln="ln -i"
 
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

alias wget='wget -c'

#alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Search command line history
alias h="history | grep "

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

alias home='cd ~'

alias open="xdg-open "

# Repete last command with sudo
alias please='sudo !!'

# Allows sudo with use of alias
alias sudo='sudo '

# Get weather for set location.
alias weather="curl wttr.in/milnthorpe"

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Internal IP Lookup
	echo -n "Internal IP: " ; ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'
	# External IP Lookup
	echo -n "External IP: " ; curl -4 https://icanhazip.com
}

# Usage (requires sudo)
# wifikey
alias wifikey="sudo grep -r '^psk=' /etc/NetworkManager/system-connections/"

# Remove a directory and all files
alias yeetdir='/bin/rm  --recursive --force --verbose '

#  __    __  .__   __.  __    __       _______. _______  _______  
# |  |  |  | |  \ |  | |  |  |  |     /       ||   ____||       \ 
# |  |  |  | |   \|  | |  |  |  |    |   (----`|  |__   |  .--.  |
# |  |  |  | |  . `  | |  |  |  |     \   \    |   __|  |  |  |  |
# |  `--'  | |  |\   | |  `--'  | .----)   |   |  |____ |  '--'  |
#  \______/  |__| \__|  \______/  |_______/    |_______||_______/ 
                                                         
# Alias's for multiple directory listing commands
#alias la='ls -Alh' # show hidden files
#alias ls='ls -aFh --color=always' # add colors and file type extensions
#alias lx='ls -lXBh' # sort by extension
#alias lk='ls -lSrh' # sort by size
#alias lc='ls -lcrh' # sort by change time
#alias lu='ls -lurh' # sort by access time
#alias lr='ls -lRh' # recursive ls
#alias lt='ls -ltrh' # sort by date
#alias lm='ls -alh |more' # pipe through 'more'
#alias lw='ls -xAh' # wide listing format
#alias ll='ls -Fls' # long listing format
#alias labc='ls -lap' #alphabetical sort
#alias lf="ls -l | egrep -v '^d'" # files only
#alias ldir="ls -l | egrep '^d'" # directories only

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Connects to wifi faster if installed
#dhcpcd -A wlan0

### ARCHIVE EXTRACTION ###
# usage: ex <file>

# navigation
#up() {
#  cd $(printf '../%.0s' $(seq ${1:-1})) || echo "Couldn't go up $1 dirs."
#}

# If ~/.inputrc doesn't exist yet: First include the original /etc/inputrc
# so it won't get overriden
#if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi

# Add shell-option to ~/.inputrc to enable case-insensitive tab completion
#echo 'set completion-ignore-case On' >> ~/.inputrc
#echo 'set show-all-if-ambiguous On' >> ~/.inputrc

#alias offrecord='history -d $(history 1)'


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
