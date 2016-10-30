# How to Rebase

```bash
git push origin BitcoinUnlimited
git checkout bitcoincore
git rebase -i BitcoinUnlimited
git push --force
git checkout -
```

Yeah, force updates can be bad, but I think they are okay for this since its a 2 line patch being rebased.
