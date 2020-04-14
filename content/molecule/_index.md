+++
title = "Using Molecule to test Ansible roles"
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

# Molecule notes

not a tutorial, more of a tricks session


Based on molecule v3.0.2

---

# Why to test?

* code needs to be maintained
* avoid production outages
* assert change risks

{{% fragment %}}Manual testing does not pay well!
{{% /fragment %}}

---

## Terminology

* **driver** (provider) - inventory management backend
* **scenario** - basically a functional test
* **command**
    * usually a playbook and optional
    * can be embedded
* **sequence** - a list of commands
* **verifier** - tools use to validate success run

---

## What can Molecule test

* roles
* playbooks
* anything you can run

Molecule provisions virtualized test hosts, run commands on them
and assert the success.

---

## What Molecule cannot do

* run multiple scenarios at once
    * [pytest-molecule](https://pypi.org/project/pytest-molecule/) does it
* produce HTML reports of runs
    * [pytest-html](https://pypi.org/project/pytest-html/) does it

{{% fragment %}}
# ☕️
{{% /fragment %}}

---

## Installing

```
pip3 install 'molecule[docker]' molecule-azure
# most drivers are now plugins and with their own packages
# docker driver is part of core
```

## Getting more information
```bash
$ molecule --version
molecule 3.0.3.dev41+gbe117525
   ansible==2.9.6 python==3.7

$ molecule drivers
name
---------
azure  # <-- this is here because we installed molecule-azure
delegated
docker
podman
```

---

#### Command line help

![molecule-help](https://sbarnea.com/ss/Screen-Shot-2020-03-28-19-25-19.74.png)

---

### Molecule driver (provider)

* A driver is used to manage test hosts:
    * **create** (so ansible can manage them)
    * **destroy** (dealocate them)
* Core drivers:
    * delegated -- aka "DIY"
    * **docker**
    * podman
* Plugins: [azure](https://pypi.org/project/molecule-azure/), [ec2](https://pypi.org/project/molecule-ec2/),
  [gce](https://pypi.org/project/molecule-gce/), [openstack](https://pypi.org/project/molecule-openstack/),
  [vagrant](https://pypi.org/project/molecule-vagrant/), [lxd](https://pypi.org/project/molecule-lxd/),
  [libvirt](https://pypi.org/project/molecule-libvirt/)*, ...

---

### Which driver to use

* **Containers** (docker/podman) unless you need systemd
* **Delegated** tests already existing inventory
* If you need real VMs use either:
    * Any cloud provider
    * Vagrant which can run locally and make use of virtualbox or libvirt
---

### Molecule verifiers

Tools used to assert success of your test

* `ansible`: default verifier
* [`testinfra`](https://pypi.org/project/testinfra/): a pytest plugin useful recommended for advanced use-cases
* [`goss`](https://pypi.org/project/molecule-goss/): 3rd party plugin

---

### Molecule commands and sequences

* command ~= a playbook (often embeded)
* a sequence is a list of commands to be run, :
    * create
    * check
    * converge
    * destroy
    * **test** - most complete one!

---

### Molecule test sequence

Default `test` sequence includes:

```bash
$ molecule matrix test
--> Test matrix

└── default  # <-- this is the name of the scenario
    ├── dependency
    ├── lint
    ├── cleanup
    ├── destroy
    ├── syntax
    ├── create
    ├── prepare  # bring host to testable status
    ├── converge  # <-- only one required
    ├── idempotence
    ├── side_effect
    ├── verify  # asserts best location
    ├── cleanup
    └── destroy
```

---

### Each scenario has a persistent state

![](https://sbarnea.com/ss/Screen-Shot-2020-03-28-19-40-51.32.png)

* `create` and `destroy` affect the `created` state
* `converge` and `cleanup` affect the `converged` state
* disable auto-destroy by adding `--destroy=never`

---

### A minimalist scenario layout

```bash
$ tree  # from inside a role directory
├── README.md
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── molecule
│   └── default  # scenario name
│       ├── converge.yml  # should contain at least "include_role: foo"
│       ├── molecule.yml  # <-- required
│       └── verify.yml
├── tasks
│   └── main.yml
└── vars
    └── main.yml
```


---

### Using config file to avoid repetition

* config file defines only default values for `molecule.yml` files
* config file can be stored at repository level or user:
    * `~/.config/molecule/config.yml` - user level
    * `{REPO}/.config/molecule/config.yml` - repo level (recommended)
* any key defined in `molecule.yml` will override values from `config.yml`

---

### Practical config example:

```yaml
# .config/molecule/config.ym
driver:
  name: delegated  # <-- now default driver will be delegated
lint: ansible-lint -v
```

```yaml
# molecule.yml
driver:
  name: docker
```

```yaml
# what is effectively loaded
driver:
  name: docker
lint: ansible-lint -v
```

Hint: Use `config.yml` to follow [`DRY principle`](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

---

## 🤗

### That's it! Any Questions?

* [#ansible-molecule](irc://#ansible-molecule) channel on irc
* [Docs](https://molecule.readthedocs.io)
* Pull Requests welcome
* Check exiting tickets
