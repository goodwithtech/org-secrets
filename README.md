# org-secrets

A disposable Sensitive Information Scanners for your git hosting services. You can check whole repositories belongs to target user/organization.

Support GitHub, GitLab, BitBuekct, Gitea and self-hosted git repositiries. [See gabrie30/ghorg for details](https://github.com/gabrie30/ghorg#supported-providers).

<img src="docs/usage.png" width="700">

Note: This image needs to put personal access tokens from stdin. You should revoke used your personal access token after run.

## Quick start

1. Copy Personal Access Token from git hosting services. [See gabrie30/ghorg for details](https://github.com/gabrie30/ghorg#github-setup).
2. Run commands below. 
3. Delete Personal Access Token from git hosting services.

```shell
# Check target organization's repositories (-o)
$ docker run --rm -it goodwithtech/org-secrets -o goodwithtech -t <github_token> -f -a
...
Success cloning repo: https://github.com/goodwithtech/dummy-for-org-secrets.git -> branch: main
Success cloning repo: https://github.com/goodwithtech/org-secrets.git -> branch: master
Success cloning repo: https://github.com/goodwithtech/dockle.git -> branch: master
Success cloning repo: https://github.com/goodwithtech/dockertags.git -> branch: master
Start scanning /secrets_ghorg/dockle
Start scanning /secrets_ghorg/dummy-for-org-secrets
[/secrets_ghorg/dummy-for-org-secrets] Matching file /.env for Environment configuration file
[/secrets_ghorg/dummy-for-org-secrets] 1 match for AWS Access Key ID Value in file /config.toml: AKIA1111111111111111

# Check target user's repositories (-u)
$ docker run --rm -it goodwithtech/org-secrets -u tomoyamachi -t <github_token> -f -a
...
121 repos found in tomoyamachi
Success cloning repo: https://github.com/tomoyamachi/docker-transcribe.git -> branch: master
Success cloning repo: https://github.com/tomoyamachi/adoptimizer.git -> branch: master
Success cloning repo: https://github.com/tomoyamachi/cucumber-api.git -> branch: master
Success cloning repo: https://github.com/tomoyamachi/bazel-cpp-sample.git -> branch: master
...
Start scanning /root/git/mnt_ghorg/invt
[/root/git/mnt_ghorg/invt] Matching file /config/database.yml for Potential Ruby On Rails database configuration file
[/root/git/mnt_ghorg/invt] 1 match for Facebook Client ID in file /config/environment.rb: FACEBOOK_APP_ID = "17XXXXXXXXX"
[/root/git/mnt_ghorg/invt] Matching file /config/initializers/secret_token.rb for Ruby On Rails secret token configuration file
[/root/git/mnt_ghorg/goodwithCompany] Matching file /.env for Environment configuration file
Start scanning /root/git/mnt_ghorg/dotfiles
[/root/git/mnt_ghorg/dotfiles] Matching file /.bash_profile for Shell profile configuration file
[/root/git/mnt_ghorg/dotfiles] Matching file /.gitconfig for Git configuration file
[/root/git/mnt_ghorg/dotfiles] Matching file /.zshrc for Shell configuration file
[/root/git/mnt_ghorg/dotfiles] 1 match for Username and password in URI in file /shells/backup_dev_es.sh: http://user:pass@xxx.xxx.xxx.xxx/${target}
```

## Usage

```shell
$ docker run --rm -it goodwithtech/org-secrets -t {token} -u {user} -f -a
 -t: scm token to clone with
 -u: user name
 -o: organization name
 -s: type of scm used, github, gitlab or bitbucket (default: github)
 -b: branch left checked out for each repo cloned (default: default branch)
 -h: host url, for on self hosted git repository (default: uses github/gitlab public api)
 -f: Include repos are forks (default: skip fork repository)
 -a: Include repos are archived (default: skip archived repository)
```

## Common Examples

### For your orgnization
```
$ docker run --rm -it goodwithtech/org-secrets -t <github_token> -o goodwithtech
$ docker run --rm -it goodwithtech/org-secrets -t <gitlab_token> -u goodwithtech -s gitlab
```

### For self-hosted git hosting services
```
# For GitHub Enterprise
$ docker run --rm -it goodwithtech/org-secrets -t <github_token> -u <user> -h https://github.domain.com/api/v3/

# For GitLab CC
$ docker run --rm -it goodwithtech/org-secrets -t <gitlab_token> -u <user> -h https://gitlab.domain.com/ -s gitlab
```

### Using an original shhgit config file

```
$ docker run --rm -it -v $(pwd)/original-config.yml:/config.yaml goodwithtech/org-secrets -t <token> -u <user>
```


### Save repositories to local directory

```shell
$ docker run --rm -it -v /path/to/save/:/secrets_ghorg/ goodwithtech/org-secrets -t <token> -u <user>
$ ls /path/to/save
<repo1> <repo2>
```

## Dependency
This image uses [gabrie30/ghorg](https://github.com/gabrie30/ghorg) and [eth0izzle/shhgit](https://github.com/eth0izzle/shhgit).  
