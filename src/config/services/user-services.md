# Per user services

Sometimes it would be nice to have user-specific runit services.
Services that, for example, open an ssh tunnel as your current user, run
a virtual machine, or regularly run daemons on your behalf. The most
common way to do this to ask a system-level runsv daemon to start a
runsvdir daemon as your user for your personal service directory.

Create a service as `/etc/sv/$username/run` with the below contents:

    #!/bin/sh
    
    UID=$(pwd -P)
    UID=${UID##*/}
    
    if [ -d "/home/${UID}/service" ]; then
        chpst -u"${UID}" runsvdir /home/${UID}/service
    fi

Then you can create runit services and symlink them under
${HOME}/service and then runit will take care of starting and restarting
those services for you.

One important caveat: if any services you have need group permissions
instead of just your user permissions, you will want to append those
groups in a colon separated list to your username, such as
`/etc/sv/anon:void1:void2:void3/run` instead of just `/etc/sv/anon/run`.
