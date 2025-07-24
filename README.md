# DShield Security Ecosystem

A comprehensive security platform combining threat intelligence, automated analysis, and data collection for DShield honeypot environments.

## Project Overview

This meta project orchestrates three interconnected security tools that work together to provide end-to-end threat detection and analysis:

### 🎯 **dshield-mcp** - AI-Powered Security Analysis
- **Purpose**: Model Context Protocol (MCP) server for automated threat hunting and incident response
- **Technology**: Python 3.8+, aiohttp, Elasticsearch, LaTeX reporting
- **Key Features**: Campaign analysis, IOC expansion, automated reporting, DShield API integration
- **Status**: Production ready

### 🕵️ **DShield-SIEM** - Data Collection & Storage  
- **Purpose**: Elasticsearch-based SIEM for collecting and storing DShield sensor data
- **Technology**: ELK Stack (Elasticsearch, Logstash, Kibana), Docker
- **Key Features**: Log parsing, data normalization, search capabilities, visualization
- **Status**: Production ready

### 🚨 **dshield-misp** - Threat Intelligence Platform
- **Purpose**: MISP (Malware Information Sharing Platform) for threat intelligence sharing
- **Technology**: Docker containers, MISP, Redis, MySQL
- **Key Features**: Threat intel sharing, 1Password integration, email relay options
- **Status**: Development

## Architecture Flow

```
DShield Sensors → DShield-SIEM → dshield-mcp → dshield-misp
     ↓              ↓              ↓              ↓
  Raw Logs    Structured Data   AI Analysis   Threat Intel
```

### Data Flow
1. **Collection**: DShield sensors send logs to DShield-SIEM
2. **Storage**: DShield-SIEM parses and stores data in Elasticsearch
3. **Analysis**: dshield-mcp queries DShield-SIEM and performs AI-powered analysis
4. **Sharing**: dshield-misp shares threat intelligence and enriches the ecosystem

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Python 3.8+ (for dshield-mcp)
- 1Password CLI (recommended for secrets management)
- LaTeX distribution (for report generation)

### Setup Order
1. **DShield-SIEM**: Set up data collection infrastructure
2. **dshield-mcp**: Configure AI analysis capabilities  
3. **dshield-misp**: Deploy threat intelligence sharing

### Individual Project Setup
Each sub-project has its own setup instructions:

- [dshield-mcp Setup](dshield-mcp/README.md)
- [DShield-SIEM Setup](DShield-SIEM/README.md)  
- [dshield-misp Setup](dshield-misp/README.md)

## Development Workflow

### Project Structure
```
dshield/
├── .cursor/                    # Meta project Cursor rules
├── dshield-mcp/               # AI Analysis Platform
│   ├── .cursor/              # MCP-specific rules
│   ├── .git/                # Independent repo
│   └── src/                 # Python source code
├── dshield-misp/             # Threat Intelligence
│   ├── .git/                # Independent repo
│   └── custom/              # MISP configuration
└── DShield-SIEM/            # Data Collection
    ├── .cursor/             # SIEM-specific rules
    ├── .git/               # Independent repo
    └── logstash/           # ELK configuration
```

### Git Strategy
- **Meta Repository**: Tracks overall project structure and integration
- **Sub-modules**: Each project maintains its own git repository
- **Integration**: Meta repo references specific commits/versions of sub-modules

### Development Guidelines
- Work on individual projects in their respective directories
- Use project-specific Cursor rules for targeted AI assistance
- Coordinate integration changes through the meta project
- Follow the established data flow patterns

## Integration Points

### Data Sharing
- **DShield-SIEM → dshield-mcp**: Elasticsearch queries for event data
- **dshield-mcp → dshield-misp**: Threat intelligence enrichment
- **dshield-misp → dshield-mcp**: IOC and threat data feeds

### Configuration Management
- Shared environment variables for common settings
- 1Password integration across all projects
- Centralized documentation and setup guides

## Contributing

1. **Choose your focus**: Work on the specific project that matches your expertise
2. **Follow project rules**: Each sub-project has its own development guidelines
3. **Test integration**: Ensure changes work across the ecosystem
4. **Update documentation**: Keep both project-specific and meta documentation current

## Support

- **dshield-mcp**: [Project Issues](https://github.com/your-org/dshield-mcp/issues)
- **DShield-SIEM**: [Project Issues](https://github.com/your-org/DShield-SIEM/issues)  
- **dshield-misp**: [Project Issues](https://github.com/your-org/dshield-misp/issues)
- **Meta Project**: [Meta Issues](https://github.com/your-org/dshield/issues)

## License

Each sub-project maintains its own license. See individual project directories for details. 