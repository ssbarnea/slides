+++
title = "Linting with pre-commit tool"
outputs = ["Reveal"]
[logo]
src = "github-logo.png"
alt = "logo"
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

## Linting with pre-commit

hearding all your linters

---

## Why linting

* adopt proven coding-practices
* code needs to maintained
* prevent bugs
* ease migrations
* simplify code-reviews
  * avoids style debates on future changes

---

## Ansible linting challenges

* Playbooks and roles uses YAML
* YAML linters do not check Ansible syntax
* Ansible syntax check does not cover style or formatting
* **Python** modules
* **Shell** scripts
* Generic text errors

---

## pre-commit

the tool, not the git hook

* a **meta-linter**, or **orchestrator**
* **pre-commit tool** does not require a git-hook
* git-hook is totally optional

---

### Terminology

* a pre-commit `hook` is mainly a linter
* a repo is the source of a linter
* a repo can have multiple hooks defined inside

---

#### Installing

```bash
pip install pre-commit
```

#### Configuring

```yaml
# .pre-commit-config.yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/ansible/ansible-lint
    rev: v4.3.0a0
    hooks:
    -   id: ansible-lint
```

---

#### Running

```plain
$ pre-commit run
[INFO] Installing environment for local.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/ansible/ansible-lint.git.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...

Fix End of Files.........................................................Passed
Trim Trailing Whitespace.................................................Passed
Mixed line ending........................................................Passed
Check for byte-order marker..............................................Passed
Check that executables have shebangs.....................................Passed
Check for merge conflicts................................................Passed
Check for broken symlinks................................................Passed
Debug Statements (Python)................................................Passed
Flake8...................................................................Passed
Check Yaml...............................................................Passed
yamllint.................................................................Passed
Ansible-lint.............................................................Passed
bashate..................................................................Passed
```

---

{{% section %}}

### Two months later

Are my linters outdated?

```bash
# just try to bump all linters
$ pre-commit auto-update
Updating https://github.com/pre-commit/pre-commit-hooks ... updating v2.4.0 -> v3.1.0.
Updating https://github.com/PyCQA/flake8.git ... [INFO] Initializing environment for https://github.com/PyCQA/flake8.git.
updating 3.7.9 -> 3.8.2.
Updating https://github.com/adrienverge/yamllint.git ... updating v1.20.0 -> v1.23.0.
Updating https://github.com/ansible/ansible-lint ... updating v4.2.0 -> v4.3.0a1.
Updating https://github.com/openstack-dev/bashate.git ... updating 0.6.0 -> 2.0.0.

# run on *all* files
$ pre-commit run -a

# if all good, save changes
$ git commit -a
```

---

#### What auto-update changes

![auto-update screenshot](https://sbarnea.com/ss/Screen-Shot-2020-06-03-14-06-57.28.png)

{{% /section %}}

---

### pre-commit benefits

* lower disk footprint
  * any tool:version is installed only once
* ease bumping
* **scales well** with lots of linters
* keeps console output clean
* **predictable** results
  * via enforced use of git tags/revisions

---

### Why not just using old tox

* tox itself uses pre-commit for linting its code
* tox is slower
* tox takes more disk space
* tox can install only python tools

---

### pre-commit limitations

* relies on git cloning
  * Caching ``~/.cache/pre-commit`` on CI/CD highly recommended
* Partial support for containers
  * Not working with remote docker hosts
  * Not working with podman
* Single core developer behind

---

### Most useful pre-commit hooks

* [pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks) a collection of generic mini-hooks maintained by pre-commit author
* [ansible-lint](https://github.com/ansible/ansible-lint)
* [yamllint](https://github.com/adrienverge/yamllint)
* [flake8](https://flake8.pycqa.org/en/latest/), [black](https://github.com/psf/black) and [mypy](http://mypy-lang.org/) for python code
* [doc8](https://github.com/PyCQA/doc8) for RST docs
* [bashate](https://github.com/openstack/bashate) for shell scripts
* you can write your own local check!

---

## I'm sold, how do I start?

* [.pre-commit-config.yaml](https://github.com/ansible-community/protogen/blob/master/.pre-commit-config.yaml) from protogen project
* activate only one repo at a time
* start with more pressing ones
* temporary add rule skips when adding new linter
* gradually remove skips in follow-ups

---

## 🤗

### That's it! Any Questions?

* [pre-commit.com](https://pre-commit.com/) official documentation
* Follow [asottile](https://github.com/asottile) on [twitter](https://twitter.com/codewithanthony) or [twitch](https://www.twitch.tv/anthonywritescode)
* Discover existing [pre-commit-hook](https://github.com/topics/pre-commit-hook)s
* Check exiting [tickets](https://github.com/pre-commit/pre-commit)

Presentation source is available at [sbarnea/slides](https://github.com/ssbarnea/slides)
