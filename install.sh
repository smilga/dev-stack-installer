#!/bin/bash

###########################################################
#
# Bash script to set up php, js, go dev enviroment
#
###########################################################

# Define install modules
MODULE_PHP=("PHP SDK (php-7.1, php modules, composer)" false)
MODULE_GO=("Go SDK (go-1.9.2, go-tools)" false)
MODULE_JS=("Javascript SDK (nodejs)" false)
MODULE_NGINX=("Nginx" false)
MODULE_REDIS=("Redis" false)
MODULE_MYSQL=("Mysql" false)
MODULE_ELASTIC=("Elasticsearch 6.x" false)
MODULE_EMACS=("Emacs (emacs 25, silversearcher-ag)" false)

CONFIGURE_HOSTS=("Set up nginx virtual hosts" false)
CONFIGURE_CERTS=("Create SSL certificate" false)

# Draws screen with selected modules
draw() {
    clear
    echo -e "Choose install options:"
    echo "---------------------------------------------"
    echo "1 $(printC "${MODULE_PHP[@]}")"
    echo "2 $(printC "${MODULE_GO[@]}")"
    echo "3 $(printC "${MODULE_JS[@]}")"
    echo "4 $(printC "${MODULE_NGINX[@]}")"
    echo "5 $(printC "${MODULE_REDIS[@]}")"
    echo "6 $(printC "${MODULE_MYSQL[@]}")"
    echo "7 $(printC "${MODULE_ELASTIC[@]}")"
    echo "8 $(printC "${MODULE_EMACS[@]}")"
    echo "---------------------------------------------"
    echo "c $(printC "${CONFIGURE_HOSTS[@]}")"
    echo "s $(printC "${CONFIGURE_CERTS[@]}")"
}

# Returns colored output
printGreen() { echo -e "\e[32m$1\n\e[39m"; }
printGray() { echo -e "\e[90m$1\n\e[39m"; }
printYellow() { echo -e "\e[33m$1\n1\e[39m"; }

# Returns colored module name depending on value
function printC() {
    arr=("$@")
    if [ "${arr[1]}" == false ]; then
        echo $(printGray "${arr[0]}")
    else
        echo $(printGreen "${arr[0]}")
    fi
}

# Changes module state
toggle() {
    if [ "$1" == false ]; then
        echo true
    else
        echo false
    fi
}

# Draws screen and waits for user input to change modules
while :
do
    draw
    # read key press
    read -n1 SEL

    case $SEL in
        1) MODULE_PHP[1]=$(toggle "${MODULE_PHP[1]}") ;;
        2) MODULE_GO[1]=$(toggle "${MODULE_GO[1]}") ;;
        3) MODULE_JS[1]=$(toggle "${MODULE_JS[1]}") ;;
        4) MODULE_NGINX[1]=$(toggle "${MODULE_NGINX[1]}") ;;
        5) MODULE_REDIS[1]=$(toggle "${MODULE_REDIS[1]}") ;;
        6) MODULE_MYSQL[1]=$(toggle "${MODULE_MYSQL[1]}") ;;
        7) MODULE_ELASTIC[1]=$(toggle "${MODULE_ELASTIC[1]}") ;;
        8) MODULE_EMACS[1]=$(toggle "${MODULE_EMACS[1]}") ;;
        c) CONFIGURE_HOSTS[1]=$(toggle "${CONFIGURE_HOSTS[1]}") ;;
        s) CONFIGURE_CERTS[1]=$(toggle "${CONFIGURE_CERTS[1]}") ;;
        "") break  ;;
        *) echo "Invalid option" ;;
    esac
done
###########################################################
#
# Add ppa`s and udpate list
#
###########################################################
UPDATE=false
if [ "${MODULE_PHP[1]}" == true ]; then
    UPDATE=true
    sudo add-apt-repository ppa:ondrej/php -y
fi
if [ "${MODULE_ELASTIC[1]}" == true ]; then
    UPDATE=true
    sudo apt-get install build-essential -y
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
fi
if [ "${MODULE_EMACS[1]}" == true ]; then
    UPDATE=true
    sudo add-apt-repository ppa:ubuntu-elisp/ppa -y
fi
if [ UPDATE == true ]; then
    echo $(printYellow "Updating apt list and upgrading system")
    sudo apt-get update -y
    sudo apt-get upgrade -y
fi
###########################################################
#
# PHP module
#
###########################################################
if [ "${MODULE_PHP[1]}" == true ]; then
    echo $(printYellow "Setting up PHP SDK")
    sudo apt-get install php7.1 php7.1-bcmath php7.1-bz2 php7.1-fpm php7.1-cli php7.1-curl php7.1-gd php7.1-imap php7.1-intl php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-xml php7.1-zip -y
    sudo apt-get install composer -y
    # Add path
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc
fi
###########################################################
# GO module
###########################################################
if [ "${MODULE_GO[1]}" == true ]; then
    echo $(printYellow "Setting up Go SDK")
    wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
    echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc
    echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.bashrc
    rm go1.9.2.linux-amd64.tar.gz
    #TODO install tools etc
fi
###########################################################
# Javascript module
###########################################################
if [ "${MODULE_JS[1]}" == true ]; then
    echo $(printYellow "Setting up Javscript SDK")
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    sudo apt-get install -y nodejs
    # Move global modules to user path
    npm config set prefix ~/npm
    echo 'export PATH="$PATH:$HOME/npm/bin"' >> ~/.bashrc
    echo 'export NODE_PATH="$NODE_PATH:$HOME/npm/lib/node_modules"' >> ~/.bashrc
fi
###########################################################
# Nginx module
###########################################################
if [ "${MODULE_NGINX[1]}" == true ]; then
    echo $(printYellow "Processing nginx module")
    sudo apt-get install nginx -y
fi
###########################################################
# Redis module
###########################################################
if [ "${MODULE_REDIS[1]}" == true ]; then
    echo $(printYellow "Installing redis")
    sudo apt-get install redis-server -y
fi
###########################################################
# Mysal module
###########################################################
if [ "${MODULE_MYSQL[1]}" == true ]; then
    echo $(printYellow "Installing mysql")
    sudo apt-get install mysql-server -y
fi
###########################################################
# Elasticsearch module
###########################################################
if [ "${MODULE_ELASTIC[1]}" == true ]; then
    echo $(printYellow "Installing elasticsearh")
    sudo apt-get install elasticsearch -y
fi
###########################################################
# Emacs module
###########################################################
if [ "${MODULE_EMACS[1]}" == true ]; then
    echo $(printYellow "Installing emacs")
    sudo apt-get install emacs25 -y
    sudo apt-get install silversearcher-ag -y
fi
###########################################################
# Configure CERT
###########################################################
if [ "${CONFIGURE_CERTS[1]}" == true ]; then
    echo "Enter domain, .local will be added automaticly"
    read domain
    echo "$domain"
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/${domain}.key -out /etc/ssl/${domain}.crt -config <(
    cat <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_ca

[ dn ]
C=US
ST=New York
L=Rochester
O=End Point
OU=$domain
emailAddress=example@$domain.com
CN = www.$domain.local

[v3_ca]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $domain.local
DNS.2 = www.$domain.local
EOF
    )
fi

echo "ssl cert created /etc/ssl/$domain"
###########################################################
# Configure hosts
###########################################################
if [ "${CONFIGURE_HOSTS[1]}" == true ]; then
    echo "Enter domain and project path - [ example /home/username/example ]"
    read domain path
    block="/etc/nginx/sites-available/$domain"
    echo "$domain"
    echo "$path"
    # Create ssl ceritficate
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/${domain}.key -out /etc/ssl/${domain}.crt -config <(
    cat <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_ca

[ dn ]
C=US
ST=New York
L=Rochester
O=End Point
OU=$domain
emailAddress=example@$domain.com
CN = www.$domain.local

[v3_ca]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $domain.local
DNS.2 = www.$domain.local
EOF
    )

# Create the Nginx server block file:
    cat > $block.local <<EOF
server {
        listen 80;
        listen [::]:80;

        root $path/public;
        index index.php index.html index.htm;

        server_name $domain.local;

        location / {
                try_files \$uri \$uri/ /index.php?\$query_string;
        }
        location ~ \.php$ {
                try_files \$uri =404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include fastcgi_params;
        }
}

server {
        listen 443 ssl;

        root $path/public;
        index index.php index.html index.htm;

        server_name $domain.local;

        ssl_certificate /etc/ssl/$domain.crt;
        ssl_certificate_key /etc/ssl/$domain.key;

        location / {
                try_files \$uri \$uri/ /index.php?\$query_string;
        }

        location ~ \.php$ {
                try_files \$uri =404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include fastcgi_params;
        }
}

EOF
# Link to make it available
sudo ln -s ${block}.local /etc/nginx/sites-enabled/
# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload
fi
# Source bashrc to get all working
source ~/.bashrc
