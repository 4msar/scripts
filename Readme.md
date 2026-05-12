# Scripts

## Available scripts

- [Setup Husky](#setup-husky)
- [Add Hosts Domain](#add-hosts-domain)
- [Set default editor](#set-default-editor)

### Setup Husky

Run the following command to setup Husky:

```bash
curl -sSL https://scripts.msar.me/setup-husky.sh | bash
```

---

### Add Hosts Domain

Run the following command to add a domain to the hosts file:

```bash
curl -sSL https://scripts.msar.me/add-hosts-domain.sh | sudo bash -s -- domain1.test domain2.test
```

or Download the script and run it:

```bash
curl -sSL https://scripts.msar.me/add-hosts-domain.sh -o add-hosts-domain.sh
sudo bash add-hosts-domain.sh domain1.test domain2.test
# or
./add-hosts-domain.sh domain1.test domain2.test
```

---

### Set default editor

Run the following command to set the default editor:

```bash
curl -sSL https://scripts.msar.me/set-editor.sh | bash
```
