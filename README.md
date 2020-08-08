# org-secrets

```
$ docker run --rm -it tomoyamachi/org-secrets -t <github_token> -o goodwithtech
$ docker run --rm -it tomoyamachi/org-secrets -t <github_token> -u tomoyamachi
$ docker run --rm -it tomoyamachi/org-secrets -t <gitlab_token> -u tomoyamachi -s gitlab
```

## Usage

```
 -t: scm token to clone with
 -u: user name
 -o: organization name
 -s: type of scm used, github, gitlab or bitbucket (default github)
 -b: branch left checked out for each repo cloned (default master)
```

## Dependency
This image uses [gabrie30/ghorg](https://github.com/gabrie30/ghorg) and [eth0izzle/shhgit](https://github.com/eth0izzle/shhgit).  