# vHosts Creator
Mac utility for easy and fast apache virtual hosts creation

![vHosts Creator ScreenShot](https://raw.githubusercontent.com/giuseppesalvo/vhostscreator/master/screenshot.png)

## How it works

The utility generate: 

**in file /etc/apache2/extra/httpd-vhosts.conf**

    # Server Name
    <VirtualHost *:80>
        ServerAdmin [ Server Name ]
        DocumentRoot [ Document Root ]
        ServerName [ Server Name ]
        ServerAlias www.[ Server Name ]
        ErrorLog /private/var/log/apache2/[ Server Name ]-error_log
        CustomLog /private/var/log/apache2/[ Server Name ]-access_log comm$
    </VirtualHost>


**in file /etc/hosts**

    # Server Name
    127.0.0.1 servername   www.servename