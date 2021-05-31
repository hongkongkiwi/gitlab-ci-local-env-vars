Gitlab CI Env Vars (for local repos)
===================================

I use gitlab for most of my pipelines and jobs.

Testing .gitlab-ci.yml is always annoying locally as you don't have the enviornment variables available.

Well not you do! Just clone the repo and `source "gitlab-ci-env-vars.sh"`

If you wat a list of the local environment variables you can use `./gitlab-ci-env-vars.sh`
