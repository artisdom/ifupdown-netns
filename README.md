# ifupdown-netns

Some simple scripts to simplify configuring network namespaces on Debian-like
systems.  Copy them into the corresponding directories under `/etc/network`.

To configure an interface in a namespace:

```
auto eth1
iface eth1 inet manual
  netns myns
```

On invocation of `ifup`:
  * if the namespace doesn't exist it will be created
  * if the folders `if-down.d`, `if-post-down.d`, `if-pre-up.d` and `if-up.d`
    under `/etc/netns/<namespace>/network` don't exist, they will be created
  * if the `/etc/netns/<namespace>/network/interfaces` file doesn't exist a
    blank one will be created
  * if it does and the interface is configured, the script will invoke `ifup`
    for this interface inside the namespace.

## `zsh` functions to run commands and start a shell in a namespace with a custom prompt
```
nse () {
  if [ $# -lt 2 ]; then
    echo "Please specify a network namespace and a command"
    echo "Usage: $0 <namespace> <command>"
    return
  fi
  NS=${1}
  shift
  ARGS=${@}
  ip netns exec ${NS} unshare -m /bin/sh -c "mount --make-rprivate /;mount --bind /run/network.${NS} /run/network; ${ARGS}"
}

nss () {
  if [ $# -ne 1 ]; then
    echo "Please specify a network namespace"
    echo "Usage: $0 <namespace>"
    return
  fi
  nse $1 zsh -i
}

alias nsr="nsenter -t 1 -n"

NS=`ip netns identify $$`

if [ "$NS" ]; then;
  NS="/$NS"
fi

if [ "`id -u`" -eq 0 ]; then
  export PS1="%{[33;36;1m%}%T%{[0m%} %{[33;34;1m%}%n%{[0m[33;33;1m%}@%{[33;37;1m%}%m${NS} %{[33;32;1m%}%~%{[0m[33;33;1m%}%#%{[0m%} "
else
  export PS1="%{[33;36;1m%}%T%{[0m%} %{[33;31;1m%}%n%{[0m[33;33;1m%}@%{[33;37;1m%}%m${NS} %{[33;32;1m%}%~%{[0m[33;33;1m%}%#%{[0m%} "
fi

```
