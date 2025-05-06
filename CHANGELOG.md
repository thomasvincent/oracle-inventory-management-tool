# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2023-07-15

### Added
- Complete rewrite with enterprise-grade features
- New custom resource `inventory_entry` for managing Oracle products
- Automated backup system with rotation
- Scheduled backups via cron
- Security enhancements and audit logging
- Comprehensive user and group management
- Helper library with utility functions
- Detailed documentation and examples

### Changed
- Renamed cookbook from `acx-oracle-inventory` to `oracle-inventory-management`
- Updated attribute namespace from `['acx-oracle']` to `['oracle']`
- Improved configuration options with comprehensive defaults
- Enhanced template with better security
- Updated metadata with proper licensing and dependencies
- Modernized file structure following Chef best practices

### Fixed
- Corrected permission issues in the original implementation
- Fixed group creation logic
- Improved error handling

## [1.0.0] - 2015

### Added
- Initial release of acx-oracle-inventory 
- Basic functionality to maintain an Oracle inventory file