---
name: personal-servers-admin
description: Administer Evan's personal servers via SSH. Use for checking server status, managing services (systemd, docker), monitoring resources, deploying apps, or any server administrative tasks. Home server (NY) at `ssh evan@server`, offsite server (LA) at `ssh evan@offsite`.
---

# Server Administration

Administer Evan's personal servers by executing commands via SSH.

## Available Servers

### Home Server (New York)
Located in Evan's apartment in New York. This is an Arch Linux server.

Connect using:
```bash
ssh evan@server
```

**Key Details**:
- Uses **Podman** for containers (not Docker)
- Has ZFS pool `documents` (~18TB total capacity, mounted at `/mnt/documents`)
- Service manager: systemd
- **Also serves as home router**: systemd-networkd configures network setup including IP forwarding
- Key services: nginx (serving hass.evanpurkhiser.com, public.evanpurkhiser.com), NFS server, dnsmasq (DHCP/DNS)
- Network: Tailscale mesh network (100.124.157.144/32), local network (10.0.0.1/24 on lan0), WAN interface (wan0)
- Running containers (as systemd services):
  - `atuin-server`, `atuin-postgres`, `atuin-abacus` (shell history sync)
  - `home-assistant` (home automation)
  - `meal-log`, `waitress` (personal apps)
  - `instagram-saver`
- Note: Containers run under root and are managed as `container-*.service` systemd units

**Configuration Management**: This server's configuration is managed by Ansible. The playbooks and configuration can be found at `~/Coding/ansible-personal`. Using this skill does not strictly require that changes be applied through the ansible-personal repo. It is common to run one-off commands directly via SSH for quick tasks or investigations. However, when you need context about how the server is configured, what services are installed, or how things are set up, you can reference the Ansible configuration in that directory.

### Offsite Server (Los Angeles)
Located in Los Angeles (offsite backup/secondary location). This is a diskless Alpine Linux Raspberry Pi 5 primarily used as an offsite ZFS replication target.

Connect using:
```bash
ssh evan@offsite
```

**Key Details**:
- **Diskless system**: Runs entirely from RAM (tmpfs root)
- Has ZFS pool `tank` for storage replication
- Service manager: OpenRC (use `rc-service` and `rc-status`)
- Key services: zrepl (ZFS replication), samba, tailscale, hddfancontrol
- Note: ZFS commands require root access

**Configuration Management**: This server is NOT managed by Ansible. All configuration is done directly via SSH.

## Guidelines

1. **NEVER use sudo**: Do not run commands with sudo under any circumstances. Use root SSH access if elevated privileges are truly required (see Root Access section below).
2. **Use safe commands**: Prefer read-only commands when possible (ls, cat, systemctl status, docker ps, etc.)
3. **Confirm destructive actions**: For commands that modify state (restart, stop, delete, etc.), explain the impact first
4. **Check before acting**: Use status/info commands before making changes
5. **Provide context**: When reporting results, explain what they mean
6. **Multiple commands**: Use SSH command chaining when efficient: `ssh evan@server "cmd1 && cmd2"`
7. **Long output**: For commands with potentially long output, consider using head, tail, or grep to filter
8. **Error handling**: If a command fails, investigate and explain the error

## Common Tasks

### System Status (Home Server - Arch/systemd)
- Check system resources: `uptime`, `free -h`, `df -h`
- Check services: `systemctl status <service>`
- Check logs: `journalctl -u <service> -n 50`
- List Podman containers (as root): `podman ps` or check systemd: `systemctl list-units 'container-*'`
- ZFS status: `zpool status documents`, `zfs list`

### System Status (Offsite Server - Alpine/OpenRC)
- Check services: `rc-status` or `rc-service <service> status`
- Check logs: `tail -f /var/log/messages` or service-specific logs
- ZFS status (requires root): `zpool status tank`, `zfs list`

### Service Management (Home Server)
- Restart service: `systemctl restart <service>`
- Check service logs: `journalctl -u <service> --since "1 hour ago"`
- Podman container logs (as root): `podman logs <container> --tail 100`
- Restart container: `systemctl restart container-<name>.service`

### Service Management (Offsite Server)
- Restart service: `rc-service <service> restart`
- Check service: `rc-service <service> status`

### Monitoring
- Active connections: `ss -tunap`
- Running processes: `ps aux | grep <name>`
- Disk usage: `du -sh /path/*`
- ZFS pool health: `zpool status`

## Script Execution

For complex multi-line scripts or operations, use this pattern:

1. Write the script to a temporary file on the local machine (where Claude is running)
2. Pipe the script into the appropriate interpreter on the remote server

**Example workflow**:
```bash
# Write script locally to /tmp/myscript.sh
# Then execute on server by piping to interpreter
cat /tmp/myscript.sh | ssh evan@server 'bash -s'

# Or for Python scripts:
cat /tmp/myscript.py | ssh evan@server 'python3'

# Can also pass arguments:
cat /tmp/myscript.sh | ssh evan@server 'bash -s -- arg1 arg2'
```

**When to use this approach**:
- Multi-line scripts with complex logic
- Scripts with proper formatting/indentation
- Operations that are cleaner as a script than a one-liner
- Reusable scripts you might need to run multiple times

**Guidelines**:
- Always explain what the script does before executing
- Show the script contents to the user for review
- Clean up temporary files after execution if they contain sensitive data

## Safety Notes

- Avoid commands that could cause data loss without explicit user confirmation
- Don't restart critical services without understanding the impact
- Use `--dry-run` flags when available for destructive operations
- Always check current state before modifying it

## Root Access

It is possible to SSH as the root user on both servers using `ssh root@server` or `ssh root@offsite`.

**IMPORTANT**: Root access should ONLY be used if ABSOLUTELY necessary.

Before running ANY commands as root, you MUST:
1. Explain why root access is required
2. Describe what commands will be run as root
3. Wait for explicit user approval

Once explicit approval is given, you may proceed with root commands. Never run root commands without this approval.
