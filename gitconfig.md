https://gist.github.com/radiaku/d3ffb60c50c9a4e2dec5be57db7272c8

make ssh for your git profile

```
ssh-keygen -t ed25519 -C "global@gmail.com" -f ~/.ssh/id_ed25519_global
ssh-keygen -t ed25519 -C "work@gmail.com" -f ~/.ssh/id_ed25519_work
ssh-keygen -t ed25519 -C "personal@gmail.com" -f ~/.ssh/id_ed25519_personal
```

usually I cp global to only id_ed25519 for default user
```
; optional but if you want
cp id_ed25519_global.pub id_ed25519.pub
cp id_ed25519_global id_ed25519
```

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_global
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```


```
git config --global user.email "aku.radiaku@gmail.com"
git config --global user.name "radiaku"
```

edit ~/.gitconfig

and then edit it like this


```
; this is for global users
[user]
	name = yourusername
	email = youremailgmail.com

[includeIf "gitdir:~/Dev/personal/"]
    path = ~/Dev/personal/.gitconfig

[includeIf "gitdir:~/Dev/work/**"]
    path = ~/Dev/work/.gitconfig

[includeIf "gitdir:~/Dev/tutorial/"]
    path = ~/Dev/tutorial/.gitconfig

```

and this is value of ~/Dev/work/.gitconfig

```
[user]
    name = work
    email = work@gmail.com

[core]
    sshCommand = "ssh -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes"

```

close and 

try clone one of your project 

on cloned folder run this:
```
git config --get core.sshCommand
; its will show something like this : "ssh -i ~/.ssh/id_ed25519_global -o IdentitiesOnly=yes"
; or this if command above not working
git config --get --show-origin core.sshCommand

```

you're done
