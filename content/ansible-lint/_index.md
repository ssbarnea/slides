+++
title = "Mastering ansible-lint"
outputs = ["Reveal"]
[logo]
src = "github-logo.png"
alt = "GitHub logo with Octocat"
[reveal_hugo]
custom_theme = "reveal-hugo/themes/robot-lung.css"
margin = 0.2
slide_number = true
transition = 'none'
transition_speed = 'fast'
showNotes = true
totalTime = 900 # 15*60
notes = true
highlight_theme = "xcode" # "zenburn"
+++

## Taming ansible-lint

based on v4.2

---

## Why linting

* adopt proven coding-practices
* code needs to maintained
* avoid style debates
* prevent bugs
* ease migrations

...  your code will ever be seen by others.

---

## Bit of background

* Authored by Will Thames in 2013
* Moved under Ansible Galaxy wing in 2019
* Official tool used to rate Galaxy roles
* 100% community project

---

## Time cosuming aspects

* Linting is like cleaning
* Harder in active repos
* Do it gradually!

{{% note %}}

* clean often, not once a year
* do not hide dirt under the rag

{{% /note %}}

---

### Gradual adoption steps

1. Bootstrap ansible-lint with all rules ignored
2. Incrementally addressed rules by either:
   * fixing
   * whitelist specific occurences
   * documented global ignore
3. Bump linters once a month

---

{{% section %}}

#### Installing

```bash
pip install 'ansible-lint>=4.2.0,<5'
```

#### Running

```bash
$ ansible-lint
tasks/main.yml:2: [E502] All tasks should be named
tasks/main.yml:35: [E502] All tasks should be named
tasks/main.yml:65: [E301] Commands should not change things if nothing needs doing
tasks/main.yml:65: [E305] Use shell only when shell functionality is required
# Exit code 1 if issues detected, zero if not found.
```

---

## Adding more verbosity

```bash
# Extra stderr output when using -v switch
Discovering files to lint: git ls-files *.yaml *.yml
# ^ when specific files are not given, ansible-lint tries to detect them
Unknown file type: apps/emby/docker-compose.yml
# ^ Minor warning about unknown file type, no reason to worry
Found roles: roles/dsm-entware
Found playbooks: apps/prom/deploy.yml apps/rss-bot/deploy.yml
Examining roles/router/tasks/main.yml of type tasks
Examining templates/dump-vars.yaml of type playbook
# ^ Useful in case some file types are wrongly detected
```

{{% /section %}}

---

### Local bypassing a false-positive

```yaml
- name: upgrade git
  package:
    name: git
    state: latest  # noqa 403
```

{{% fragment %}}Favour local ignores instead of global ones.
{{% /fragment %}}

{{% note %}}

* `noqa` is based on flake8, introduced in v4.2

{{% /note %}}

---

### Global rule skipping

```yaml
# .ansible-lint
skip_list:
  # Only excuses for adding skips: bugs in linter and recent linter bumping
  # E602 https://github.com/ansible/ansible-lint/issues/450
  - '602'  # [E602] Don't compare to empty string
  # This role is not published:
  - '701'  # [E701] No 'galaxy_info' found
  # TODO(ssbarnea): address in follow-ups
  - '999'
```

---

### When to ignore files or directories

* parsing errors:
  * ecrypted data
  * files using missing ansible modules
* if no other workaround is usable

{{% fragment %}}
Always mention why:
```
# .ansible-lint
exclude_paths:
  # https://github.com/ansible/ansible-lint/issues/372 missing custom module
  - roles/messy-role
```
{{% /fragment %}}

---

### Orchestrate linters using pre-commit

* [pre-commit](https://pre-commit.com/) tool
  * git commit hook is optional
* very **fast** linting
* small disk footprint (linters venvs reused across repos)
* easy linters updates ```pre-commit autoupdate```
* **scales** well with lots of linters

---

### Adding ansible-lint to pre-commit:

```yaml
# .pre-commit-config.yaml
  - repo: https://github.com/ansible/ansible-lint.git
    rev: v4.2.0
    hooks:
      - id: ansible-lint
        always_run: true
        pass_filenames: false
        # https://github.com/ansible/ansible-lint/issues/611
        entry: env ANSIBLE_LIBRARY=library ansible-lint --force-color -p -v
```

![pre-commit-run](https://sbarnea.com/ss/Screen-Shot-2020-03-29-11-25-00.26.png)

---

## 🤗

### That's it! Any Questions?

* [#ansible-galaxy](irc://#ansible-galaxy) channel on irc
* [PRs](https://github.com/ansible/ansible-lint/pulls) welcomed
* Check exiting [tickets](https://github.com/ansible/ansible-lint/issues)


Presentation source is available at [sbarnea/slides](https://github.com/ssbarnea/slides)