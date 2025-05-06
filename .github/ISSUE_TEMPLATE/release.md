---
name: Release
about: Release checklist for the Oracle Inventory Management cookbook
title: 'Release: v2.x.x'
labels: release
assignees: ''
---

## Release Checklist

### Pre-Release Tasks

- [ ] Update version in `metadata.rb`
- [ ] Update `CHANGELOG.md` with new version and changes
- [ ] Verify all tests pass locally:
  - [ ] `chef exec cookstyle`
  - [ ] `chef exec rspec`
  - [ ] `kitchen test`
- [ ] Update documentation if needed

### Release Process

- [ ] Create and push tag:
  ```bash
  git tag v2.x.x
  git push origin v2.x.x
  ```
- [ ] Verify GitHub workflow "Package" runs and completes successfully
- [ ] Verify cookbook package is published to GitHub Packages
- [ ] Create a new release on GitHub with release notes
  - [ ] Include key changes
  - [ ] Include upgrade instructions if needed
  - [ ] Include any deprecation notices
  
### Supermarket Release (if applicable)

- [ ] Verify GitHub workflow "Release" runs and completes successfully
- [ ] Verify cookbook is available on Chef Supermarket

### Post-Release Tasks

- [ ] Announce the release in appropriate channels
- [ ] Update any related documentation or websites
- [ ] Create new development version (increment patch version and add -dev suffix)

### Notes

Any additional notes about this release: