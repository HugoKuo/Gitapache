<VirtualHost *:80>
    <Directory /var/www/git.myserver.com/gitorious/public>
        Options FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from All
    </Directory>

    DocumentRoot /var/www/git.myserver.com/gitorious/public
    ServerName git.ami.com.tw
    BrowserMatch ".*MSIE.*" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0

    ErrorLog /var/www/git.myserver.com/log/error.log
    CustomLog /var/www/git.myserver.com/log/access.log combined

    # Gzip/Deflate
    # http://fluxura.com/2006/5/19/apache-for-static-and-mongrel-for-rails-with-mod_deflate-and-capistrano-support
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript text/css application/x-javascript
    BrowserMatch ^Mozilla/4 gzip-only-text/html
    BrowserMatch ^Mozilla/4\.0[678] no-gzip
    BrowserMatch \bMSIE !no-gzip !gzip-only-text/html

    # Far future expires date
    <FilesMatch "\.(ico|pdf|flv|jpg|jpeg|png|gif|js|css|swf)$">
        ExpiresActive On
        ExpiresDefault "access plus 1 year"
    </FilesMatch>

    # No Etags
    FileETag None

    RewriteEngine On

    # Check for maintenance file and redirect all requests
    RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
    RewriteCond %{SCRIPT_FILENAME} !maintenance.html
    RewriteRule ^.*$ /system/maintenance.html [L]
</VirtualHost>
