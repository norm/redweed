redweed
=======

Infrastructure setup for my personal websites and things.

This code might be useful to study, but you probably don't want to **use**
it directly.


## Setup

### Install software (OS X)

*   Install [homebrew]

    ```bash
    # follow instructions on website
    ```

*   Install [terraform]

    ```bash
    brew install terraform
    ```

[homebrew]: http://brew.sh
[terraform]: https://www.terraform.io

### Check out the keys repository

From within your local checkout of this repo, bring in the dependencies with
`git submodule update --init`.

This will fail on the `keys` repo if you aren't me, so you will need some
things if you are intending to actually try this out (may not work for you
without some more customisation; this is me documenting what I've done as I've
created this repository):

```bash
mkdir keys

# fill out missing values for AWS operations
cp sample_aws.vars.tf keys/aws.vars.tf
${EDITOR} keys/aws.vars.tf
```

## Using

When changing the underlying infrastructure:

```bash
# make changes to terraform configuration...

cd terraform
terraform plan

# if it looks good, run it...
terraform apply
```
