# Use gmk

```
gmk self/config
gmk mailmap
gmk exclude
gmk conf
gmk mailmaps
```

# Generate inventory

```
make -f inventory.mk main
```

# Choose and configure ansible

```
make -C ext/ansible-cfg install
ansible-cfg median
source <(use-ansible)
ansible-cfg exclude
```

# Use ansible with inventory

```
source <(use-ansible)
ansible 'n_admin2:!g_poweredoff' -om ping
```

# Generate user data

```
make -C ext/data-users
```

# Get roles

```
requirements.mk main
```

# Assert ssh-agent and gpg-agent

```
asserts.yml
```
