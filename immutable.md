# Protect `.ssh/authorized_keys` with immutable attribute

[immutable.yml][] from [infra-play-users][] is a single task
idempotent playbook that can

- Set `Immutable` [File_attribute][] on `.ssh` and
  `.ssh/authorized_keys` using [Chattr][] via [ansible.builtin.file][]
  module designated users
- Reset to `Immutable` when `reset` var is defined
- Apply to all users in `ssh` group not in `sudo` group
- Apply on a single user when `one` var is defined to an user
- WARNING: default to all avalaible node

May required that [fix-authorized_keys.yml][] be run first to create
missing `.ssh/authorized_keys` (see [fix-authorized_keys.md][])

```bash
./immutable.yml -l pretstfnta1 -e one=kevin
./immutable.yml -l pretstfnta1 -e one=kevin -e reset
./immutable.yml -l pretstfnta1
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

[Chattr]:
    https://en.wikipedia.org/wiki/Chattr
    "wikipedia.org"

[File_attribute]:
    https://en.wikipedia.org/wiki/File_attribute
    "wikipedia.org"

[ansible.builtin.file]:
	https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html
    "docs.ansible.com"

[infra-play-users]:
	https://github.com/thydel/infra-play-users
    "github.com repo"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
