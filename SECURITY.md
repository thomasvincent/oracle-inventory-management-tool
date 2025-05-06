# Security Policy

## Supported Versions

Only the latest major version is currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | :white_check_mark: |
| 1.x.x   | :x:                |

## Reporting a Vulnerability

We take the security of the Oracle Inventory Management cookbook seriously. If you believe you've found a security vulnerability, please follow these steps:

1. **Do not disclose the vulnerability publicly**
2. **Email the details to security@thomasvincent.xyz**
3. Include as much information as possible, such as:
   - Type of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix if available

You will receive an acknowledgment within 48 hours. We'll work with you to understand and validate the issue.

## Security Best Practices

When using this cookbook, consider the following security best practices:

- Run Oracle software with the principle of least privilege
- Ensure the Oracle inventory directory has proper permissions (default: 0775)
- Lock the Oracle user account when not required for interactive use
- Regularly rotate backups of the inventory
- Monitor changes to the inventory directory
- Use the audit logging feature to track changes

## Implementation Details

The cookbook implements several security measures:

- Secure file permissions
- User account lockdown
- Input validation
- Audit logging
- Backup functionality

## Responsible Disclosure

We follow responsible disclosure principles and will:

- Acknowledge receipt of your vulnerability report
- Provide an estimated timeline for a fix
- Notify you when the vulnerability has been fixed
- Credit you in the release notes (unless you prefer to remain anonymous)

Thank you for helping keep Oracle Inventory Management and its users secure!