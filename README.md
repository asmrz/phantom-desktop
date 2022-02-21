## phantom-desktop

Docker container providing remote Linux desktop in browser.

After startup, open http://localhost:7000/ in your browser for VNC client; http://localhost:8000/ for the file manager.\
Default user is 'phantom' (if asked), default password (if not set in Docker command line) is 'password'.

Container also exposes port 5900 for regular VNC clients, though exposing it is not required.

### Launch

Command line to launch (will survive container restarts):
```bash
docker run --restart=unless-stopped --name=desktop \ 
  -p 5900:5900 -p 7000:7000/tcp -p 8000:8000 \ 
  -e PASSWORD=very_secure_password \ 
  -d asmoroz/phantom-desktop
```

Completely ephemeral (without TLS):
``` bash
docker run --rm --name=desktop -p 7000:7000 -e PASSWORD=very_secure_password -d asmoroz/phantom-desktop
```

Non-ephemeral (and with TLS certificate in /tls_config):
``` bash
docker run --restart=unless-stopped --name=desktop \
 -p 5900:5900/tcp -p 7000:7000/tcp -p 8000:8000/tcp \
 -v $HOME/desktop-home:/home/phantom \
 -e PASSWORD=very_secure_password \
 -e TLS_CERTIFICATE_CHAIN=/certificate.crt \
 -e TLS_CERTIFICATE_PRIVATE_KEY=/private_key.pem \
 -v /tls_config/snakeoil.crt:/certificate.crt \
 -v /tls_config/snakeoil.pem:/private_key.pem \
 -d asmoroz/phantom-desktop
```

Use ``-v $HOME/desktop-home:/home/phantom`` option to setup home directory in host's '$HOME/desktop-home'.

### Environment

There are 3 environment variable one can set:
  - ``PASSWORD`` - VNC password
  - ``TLS_CERTIFICATE_CHAIN`` - path to the TLS certificate chain file in PEM format, should have a corresponding bind mount (see TLS example above). 
  - ``TLS_CERTIFICATE_PRIVATE_KEY`` - path to the TLS certificate private key in PEM format, should have a corresponding bind mount (see TLS example above). 

There is also a ``USERNAME`` environment variable, in addition to the standard environment Linux has.
