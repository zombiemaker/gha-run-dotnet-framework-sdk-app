# Re-Tag GitHub Action

A GitHub action is called from a GitHub Action Workflow using a git tag (e.g., {github-repo-name}@v1).  Every time changes to the GitHub action that affects the action, it has to be re-tag to the git commit that has the new repo state.

## Procedure

As you are iterating through changes to the action definition, and assuming you want to re-use a previously defined tag, you have to perform the following:

* delete old tag
> git tag -d <tagname>

* push deleted tag to remote repository
> git push <branch> --delete <tagname>

* create tag using new commit
> git tag <tagname>

* push new tag to remote repository
> git push <branch> --tags