# Meta Project Setup Guide

## Overview

This guide explains how to set up and work with the DShield Security Ecosystem meta project, which coordinates development across three interconnected security tools.

## Repository Structure

```
dshield/
├── .cursor/rules/          # Meta project Cursor rules
├── .gitmodules            # Git submodule configuration
├── docs/                  # Integration documentation
├── README.md              # Meta project overview
├── dshield-mcp/           # AI-powered security analysis (submodule)
├── DShield-SIEM/          # Data collection and storage (submodule)
└── dshield-misp/          # Threat intelligence platform (submodule)
```

## Initial Setup

### 1. Clone the Meta Repository

```bash
# Clone the meta repository
git clone https://github.com/datagen24/dshield.git
cd dshield

# Initialize and update submodules
git submodule init
git submodule update
```

### 2. Alternative: Clone with Submodules

```bash
# Clone with submodules in one command
git clone --recursive https://github.com/datagen24/dshield.git
cd dshield
```

### 3. Verify Setup

```bash
# Check submodule status
git submodule status

# Should show:
# a4ac8a6 dshield-mcp (heads/main)
# a4ac8a6 DShield-SIEM (heads/main)
# a4ac8a6 dshield-misp (heads/main)
```

## Development Workflow

### Working with Individual Projects

#### Navigate to Project Directory
```bash
# Work on dshield-mcp
cd dshield-mcp
# Cursor will automatically apply dshield-mcp-specific rules

# Work on DShield-SIEM
cd DShield-SIEM
# Cursor will automatically apply DShield-SIEM-specific rules

# Work on dshield-misp
cd dshield-misp
# Cursor will automatically apply dshield-misp-specific rules
```

#### Project-Specific Development
- Each project has its own git repository
- Use project-specific Cursor rules for targeted AI assistance
- Follow the project's established patterns and conventions
- Test changes within the project context

### Working on Integration

#### Stay at Meta Project Root
```bash
# Work from the main dshield directory
cd /path/to/dshield
# Cursor will apply meta project rules for integration work
```

#### Integration Development
- Use meta project rules for cross-project coordination
- Consider the complete data flow and architecture
- Test integration points thoroughly
- Update integration documentation

## Git Submodule Management

### Updating Submodules

#### Update All Submodules
```bash
# Update all submodules to latest commits
git submodule update --remote

# Commit the submodule updates
git add .
git commit -m "Update submodules to latest versions"
```

#### Update Specific Submodule
```bash
# Update specific submodule
git submodule update --remote dshield-mcp

# Commit the update
git add dshield-mcp
git commit -m "Update dshield-mcp to latest version"
```

### Working with Submodule Changes

#### Making Changes in Submodules
```bash
# Navigate to submodule
cd dshield-mcp

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push changes to submodule repository
git push origin main

# Return to meta project and update reference
cd ..
git add dshield-mcp
git commit -m "Update dshield-mcp with new feature"
```

#### Pulling Changes from Submodules
```bash
# Pull latest changes from all submodules
git submodule foreach git pull origin main

# Commit the updates
git add .
git commit -m "Pull latest changes from submodules"
```

## Cursor AI Assistance

### Project-Specific Assistance

Each project has specialized Cursor rules:

- **dshield-mcp**: 25+ rules for Python MCP development
- **DShield-SIEM**: 8 rules for ELK stack and SIEM development
- **dshield-misp**: Rules for MISP platform development

### Meta Project Assistance

The meta project provides rules for:

- **meta-project-overview.mdc**: Overall architecture and workflow
- **integration-development.mdc**: Cross-project coordination
- **git-workflow.mdc**: Version management and release process
- **cursor-navigation.mdc**: AI assistance patterns

### Context Switching

#### Between Projects
```bash
# Clear context when switching
cd dshield-mcp
# Work on MCP-specific features

cd ../DShield-SIEM
# Work on SIEM-specific features

cd ../dshield-misp
# Work on MISP-specific features
```

#### Between Individual and Integration Work
```bash
# Individual project work
cd dshield-mcp
# Use project-specific rules

# Integration work
cd ..
# Use meta project rules
```

## Release Coordination

### Version Management

#### Check Current Versions
```bash
# Check submodule versions
git submodule foreach 'echo "$name: $(git describe --tags --always)"'
```

#### Coordinate Releases
```bash
# 1. Update version numbers in each project
cd dshield-mcp && git tag v1.3.0
cd ../DShield-SIEM && git tag v2.2.0
cd ../dshield-misp && git tag v0.6.0

# 2. Update meta project documentation
cd ..
# Update docs/version-compatibility.md

# 3. Commit and tag meta project
git add .
git commit -m "Coordinate release v1.3.0 across all projects"
git tag v1.3.0
```

### Breaking Changes

#### Major Version Updates
```bash
# 1. Plan breaking changes
# 2. Update compatibility matrix
# 3. Create migration guides
# 4. Test integration thoroughly
# 5. Coordinate releases
```

## Testing Integration

### Complete Workflow Testing

```bash
# 1. Test DShield-SIEM data collection
cd DShield-SIEM
docker-compose up -d
# Verify data is being collected

# 2. Test dshield-mcp analysis
cd ../dshield-mcp
python mcp_server.py
# Test MCP tools and Elasticsearch queries

# 3. Test dshield-misp threat intelligence
cd ../dshield-misp
docker-compose up -d
# Verify MISP is accessible

# 4. Test complete integration
cd ..
# Run integration tests from meta project
```

### Integration Test Script

Create a test script for the complete workflow:

```bash
#!/bin/bash
# test-integration.sh

echo "Testing DShield Security Ecosystem Integration..."

# Test DShield-SIEM
echo "1. Testing DShield-SIEM..."
cd DShield-SIEM
docker-compose ps | grep -q "Up" || exit 1

# Test dshield-mcp
echo "2. Testing dshield-mcp..."
cd ../dshield-mcp
python -c "from src.elasticsearch_client import ElasticsearchClient; print('ES connection OK')" || exit 1

# Test dshield-misp
echo "3. Testing dshield-misp..."
cd ../dshield-misp
docker-compose ps | grep -q "Up" || exit 1

echo "All integration tests passed!"
```

## Troubleshooting

### Common Issues

#### Submodule Not Initialized
```bash
# Initialize submodules
git submodule init
git submodule update
```

#### Submodule Out of Sync
```bash
# Reset submodules to tracked commits
git submodule update --init --recursive
```

#### Cursor Rules Not Applied
```bash
# Ensure you're in the correct directory
pwd
# Should show the project directory you want to work in

# Check Cursor rules are loaded
# Look for .cursor/rules/ directory in current location
```

#### Integration Issues
```bash
# Check all services are running
docker-compose ps

# Check network connectivity
curl -X GET "http://localhost:9200"

# Check logs
docker-compose logs
```

## Best Practices

### Development Workflow

1. **Choose Your Context**: Work in project-specific directories for focused development
2. **Use Appropriate Rules**: Let Cursor apply the right rule set for your work
3. **Test Integration**: Always test cross-project functionality
4. **Update Documentation**: Keep both project and integration docs current

### Git Management

1. **Regular Updates**: Keep submodules up to date
2. **Coordinated Releases**: Plan and coordinate releases across projects
3. **Version Compatibility**: Maintain compatibility matrices
4. **Migration Planning**: Plan for breaking changes

### Documentation

1. **Project-Specific Docs**: Keep in respective project directories
2. **Integration Docs**: Maintain in meta project
3. **Version Tracking**: Keep compatibility matrices current
4. **Migration Guides**: Document breaking changes

## Support

### Getting Help

- **Project-Specific Issues**: Use the respective project's issue tracker
- **Integration Issues**: Use the meta project issue tracker
- **Documentation**: Check the docs/ directory for guides
- **Community**: Join the DShield community discussions

### Resources

- [Integration Guide](docs/integration-guide.md)
- [Version Compatibility](docs/version-compatibility.md)
- [dshield-mcp Documentation](dshield-mcp/docs/)
- [DShield-SIEM Documentation](DShield-SIEM/README.md)
- [dshield-misp Documentation](dshield-misp/README.md) 