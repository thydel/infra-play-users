# Generate ansible config

```
ansible-cfg.mk median
ansible-cfg.yml
```

# Generate minimal inventory

```
node-local.mk main
```

# Less verbose assert

```
unverbose-assert.mk main
```

# Define private variables

- Define `password-store`, `data-users`, `data-nodes`, `nodes-groups`
  in `private-repos.yml` (starting from private `infra-data-repos`)
- Optionnaly define `gpg-store`
- Define `default_key` in `keys.yml` (eg `default_key: t.delamare@epiconcept.fr`)

# Get private stuff

```
private-repos-get.yml
```

# Assert ssh-agent and gpg-agent

```
asserts.yml
```

# Generate private inventory

```
nodes-oxa.mk main
nodes-epiconcept.net.mk main
nodes-charenton.tld.mk main
```

# Generate poweredoff inventory

```
nodes-poweredoff.mk main
```

# Generate groups inventory

```
make -C ext/nodes-groups -f ansible-cfg.mk nodes_groups
proot -w ext/nodes-groups ./ansible-cfg.yml
make -C ext/nodes-groups -f local.mk main
make -C ext/nodes-groups -f requirements.mk main
ext/nodes-groups/groups4vms-play.yml
nodes-groups.mk main
```

# Generate user data

```
make -C ext/data-users
```
