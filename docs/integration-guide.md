# DShield Security Ecosystem Integration Guide

## Overview

This guide provides comprehensive instructions for integrating the three components of the DShield Security Ecosystem:

1. **DShield-SIEM**: Data collection and storage
2. **dshield-mcp**: AI-powered analysis and automation
3. **dshield-misp**: Threat intelligence sharing

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  DShield        │    │  DShield-SIEM   │    │  dshield-mcp    │
│  Sensors        │───▶│  (ELK Stack)    │───▶│  (MCP Server)   │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
                                              ┌─────────────────┐
                                              │  dshield-misp   │
                                              │  (MISP Platform)│
                                              │                 │
                                              └─────────────────┘
```

## Prerequisites

### System Requirements
- **DShield-SIEM**: Ubuntu 20.04+ with 8GB+ RAM, Docker
- **dshield-mcp**: Python 3.8+, 4GB+ RAM, LaTeX distribution
- **dshield-misp**: Docker, 4GB+ RAM, 1Password CLI

### Network Requirements
- All components must be able to communicate with each other
- DShield sensors must reach DShield-SIEM
- dshield-mcp must reach DShield-SIEM and dshield-misp
- dshield-misp must reach external threat intelligence sources

## Installation Order

### 1. DShield-SIEM Setup
First, set up the data collection infrastructure:

```bash
# Clone and configure DShield-SIEM
git clone https://github.com/your-org/DShield-SIEM.git
cd DShield-SIEM

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Start the ELK stack
docker-compose up -d

# Verify all services are running
docker-compose ps
```

**Verification Steps:**
- Kibana accessible at http://localhost:5601
- Elasticsearch accessible at http://localhost:9200
- Logstash processing logs

### 2. dshield-mcp Setup
Next, configure the AI analysis platform:

```bash
# Clone and configure dshield-mcp
git clone https://github.com/your-org/dshield-mcp.git
cd dshield-mcp

# Set up Python environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with Elasticsearch and DShield API settings

# Test Elasticsearch connection
python test_es_connection.py

# Start the MCP server
python mcp_server.py
```

**Verification Steps:**
- MCP server starts without errors
- Can connect to Elasticsearch
- Can query DShield API (if configured)

### 3. dshield-misp Setup
Finally, deploy the threat intelligence platform:

```bash
# Clone and configure dshield-misp
git clone https://github.com/your-org/dshield-misp.git
cd dshield-misp

# Run setup script
./setup.sh

# Configure credentials (choose one method)
# Option A: Local environment file
cp .env.template .env
# Edit .env with your settings

# Option B: 1Password integration (recommended)
# Follow custom/config/1password-setup.md

# Start the MISP stack
docker-compose up -d
```

**Verification Steps:**
- MISP web interface accessible
- Database connection established
- Email relay configured

## Configuration Integration

### Shared Environment Variables

Create a shared configuration file or use environment variables:

```bash
# Common configuration for all components
export DSHIELD_API_KEY="your-dshield-api-key"
export ELASTICSEARCH_URL="http://localhost:9200"
export ELASTICSEARCH_USERNAME="elastic"
export ELASTICSEARCH_PASSWORD="your-elastic-password"
export MISP_URL="https://localhost:443"
export MISP_API_KEY="your-misp-api-key"
```

### 1Password Integration

For secure credential management across all components:

```bash
# Install 1Password CLI
# Follow: https://developer.1password.com/docs/cli/get-started/

# Configure 1Password items for each component
op item create --category=password --title="DShield API Key" --vault="DShield"
op item create --category=password --title="Elasticsearch Credentials" --vault="DShield"
op item create --category=password --title="MISP API Key" --vault="DShield"
```

## Integration Testing

### 1. Data Flow Testing

Test the complete data flow from sensors to analysis:

```bash
# 1. Verify DShield-SIEM is receiving data
curl -X GET "http://localhost:9200/cowrie-*/_search?pretty" \
  -u "elastic:your-password"

# 2. Test dshield-mcp can query DShield-SIEM
cd dshield-mcp
python -c "
from src.elasticsearch_client import ElasticsearchClient
client = ElasticsearchClient()
results = client.search_events('cowrie-*', size=10)
print(f'Found {len(results)} events')
"

# 3. Test dshield-mcp can enrich with DShield API
python -c "
from src.dshield_client import DShieldClient
client = DShieldClient()
result = client.get_ip_reputation('8.8.8.8')
print(f'Reputation: {result}')
"
```

### 2. MCP Tool Testing

Test the MCP server functionality:

```bash
# Start MCP server
cd dshield-mcp
python mcp_server.py

# In another terminal, test MCP tools
python mcp_test_client.py
```

### 3. MISP Integration Testing

Test threat intelligence sharing:

```bash
# Test MISP API access
curl -H "Authorization: your-misp-api-key" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "https://localhost:443/attributes/restSearch"

# Test dshield-mcp can access MISP
cd dshield-mcp
python -c "
from src.misp_client import MispClient
client = MispClient()
events = client.get_recent_events()
print(f'Found {len(events)} MISP events')
"
```

## Monitoring and Health Checks

### Health Check Endpoints

```bash
# DShield-SIEM Health
curl -X GET "http://localhost:9200/_cluster/health?pretty"

# dshield-mcp Health
curl -X GET "http://localhost:8000/health"

# MISP Health
curl -X GET "https://localhost:443/servers/getVersion"
```

### Log Monitoring

Monitor logs across all components:

```bash
# DShield-SIEM logs
docker-compose -f DShield-SIEM/docker-compose.yml logs -f

# dshield-mcp logs
tail -f dshield-mcp/logs/mcp_server.log

# MISP logs
docker-compose -f dshield-misp/docker-compose.yml logs -f misp
```

## Troubleshooting

### Common Issues

#### 1. Elasticsearch Connection Issues
```bash
# Check Elasticsearch is running
docker ps | grep elasticsearch

# Check network connectivity
curl -X GET "http://localhost:9200"

# Verify credentials
curl -u "elastic:your-password" "http://localhost:9200/_cluster/health"
```

#### 2. MCP Server Issues
```bash
# Check Python dependencies
pip list | grep -E "(aiohttp|elasticsearch|pydantic)"

# Check configuration
python -c "from src.config_loader import ConfigLoader; print(ConfigLoader().load_config())"

# Check logs
tail -f logs/mcp_server.log
```

#### 3. MISP Connection Issues
```bash
# Check MISP containers
docker-compose -f dshield-misp/docker-compose.yml ps

# Check MISP logs
docker-compose -f dshield-misp/docker-compose.yml logs misp

# Test MISP API
curl -k -H "Authorization: your-api-key" "https://localhost:443/servers/getVersion"
```

### Performance Optimization

#### 1. Elasticsearch Optimization
```yaml
# In DShield-SIEM/docker-compose.yml
elasticsearch:
  environment:
    - "ES_JAVA_OPTS=-Xms2g -Xmx2g"
    - "discovery.type=single-node"
```

#### 2. dshield-mcp Optimization
```python
# In dshield-mcp/src/config_loader.py
ELASTICSEARCH_TIMEOUT = 30
ELASTICSEARCH_MAX_RETRIES = 3
DSHIELD_API_RATE_LIMIT = 60  # requests per minute
```

#### 3. MISP Optimization
```yaml
# In dshield-misp/docker-compose.yml
misp:
  environment:
    - "MYSQL_MISP_DB_HOST=db"
    - "REDIS_FQDN=redis"
```

## Security Considerations

### Network Security
- Use HTTPS for all external communications
- Implement proper firewall rules
- Use VPN for remote access
- Monitor network traffic for anomalies

### Access Control
- Use strong passwords and API keys
- Implement role-based access control
- Regular credential rotation
- Audit access logs

### Data Protection
- Encrypt data in transit and at rest
- Implement proper backup procedures
- Regular security updates
- Vulnerability scanning

## Maintenance

### Regular Tasks

#### Daily
- Check system health and logs
- Monitor data flow and performance
- Review security alerts

#### Weekly
- Update threat intelligence feeds
- Review and rotate credentials
- Backup configuration and data
- Update documentation

#### Monthly
- Security updates and patches
- Performance optimization
- Capacity planning
- Integration testing

### Backup Procedures

```bash
# Backup Elasticsearch data
curl -X PUT "localhost:9200/_snapshot/backup_repo/snapshot_$(date +%Y%m%d)" \
  -H "Content-Type: application/json" \
  -d '{"indices": "cowrie-*"}'

# Backup MISP data
docker exec dshield-misp_misp_1 /var/www/MISP/app/Console/cake Admin backup

# Backup dshield-mcp configuration
tar -czf dshield-mcp-config-$(date +%Y%m%d).tar.gz dshield-mcp/config/
```

## Support and Resources

### Documentation
- [dshield-mcp Documentation](dshield-mcp/docs/)
- [DShield-SIEM Documentation](DShield-SIEM/README.md)
- [dshield-misp Documentation](dshield-misp/README.md)

### Community
- [DShield Community](https://isc.sans.edu/)
- [MISP Community](https://www.misp-project.org/)
- [Elasticsearch Community](https://discuss.elastic.co/)

### Issue Reporting
- Report issues in the respective project repositories
- Include relevant logs and configuration details
- Provide steps to reproduce the issue
- Mention the integration context when relevant 