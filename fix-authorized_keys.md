# Fix missing `.ssh/authorized_keys`

[fix-authorized_keys.yml][] from [infra-play-users][] is a simple
idempotent playbook that can create missing `.ssh/authorized_keys`
file so that we can make them immutable.

Usually used before [immutable.yml][] (see [immutable.md][])

- Apply to all users in `ssh` group not in `sudo` group
- Apply on a single user when `one` var is defined to an user
- Give an error message via [ansible.builtin.lines][] lookup
- WARNING: default to all avalaible node

```bash
fix-authorized_keys.yml -l $node -e one=$user
fix-authorized_keys.yml -l $node
```

[immutable.md]:
    https://github.com/thydel/infra-play-users/blob/master/immutable.md
    "github.com file"

[fix-authorized_keys.md]:
    https://github.com/thydel/infra-play-users/blob/master/fix-authorized_keys.md
    "github.com file"

[immutable.yml]:
    https://github.com/thydel/infra-play-users/blob/master/immutable.yml
    "github.com file"

[fix-authorized_keys.yml]:
    https://github.com/thydel/infra-play-users/blob/master/fix-authorized_keys.yml
    "github.com file"

[ansible.builtin.lines]:
	https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lines_lookup.html
    "docs.ansible.com"

[infra-play-users]:
	https://github.com/thydel/infra-play-users
    "github.com repo"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
