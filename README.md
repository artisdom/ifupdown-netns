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

## `zsh` functions to run commands and start a shell in a namespace
```
nse () {
  if [ $# -lt 2 ]; then
    echo "Please specify a network namespace and a command"
    return
  fi
  NS=${1}
  shift
  unshare -m /bin/sh <<-EOF
mount --make-rprivate /
mount --bind /run/network.${NS} /run/network
ip netns exec ${NS} ${@}
EOF
}

nss () {
  if [ $# -ne 1 ]; then
    echo "Please specify a network namespace"
    return
  fi
  nse $1 zsh -i
}
```
