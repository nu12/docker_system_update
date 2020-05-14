external_url 'https://git.breweryda.com'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/my_cert.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/my_cert.key"
nginx['http2_enabled'] = false