# Once, after clone

## Init gmk

```
gmk init self/config mailmap
gmk conf
```

## Choose and configure ansible

See [ansible-cfg][]

```
make -C ext/ansible-cfg install
ansible-cfg median
source <(use-ansible)
ansible-cfg exclude
```

[ansible-cfg]: https://github.com/thydel/ansible-cfg "github repo"

# Make and install everything

```
make main
```
