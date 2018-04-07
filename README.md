# ifupdown-netns

Some simple scripts to simplify configuring network namespaces on Debian-like
systems.  Copy them into the corresponding directories under `/etc/network`.

To configure an interface in a namespace:

```
auto eth1
iface eth1 inet manual
  netns myns
```

On invocation of `ifup` it will create the necessary directories under
`/etc/netns/` and an empty `/etc/netns/<namespace>/network/interfaces` file if
it doesn't already exist.

If it does and the interface is configured it will invoke `ifup` inside the
namespace.
