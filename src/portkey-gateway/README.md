# Portkey AI Gateway

[Portkey AI Gateway](https://github.com/Portkey-AI/gateway) is a blazing fast, open-source AI Gateway that allows you to route to 200+ language, vision, audio, and image models from a single API. It provides reliable routing, security features, cost management, and enterprise-ready deployment options.

## Features

- **Multi-LLM Routing**: Route to 200+ LLMs with a single API
- **Reliable Routing**: Fallbacks, automatic retries, load balancing, and request timeouts
- **Security & Accuracy**: Guardrails, secure key management, RBAC, SOC2/HIPAA/GDPR compliance
- **Cost Management**: Smart caching, usage analytics, provider optimization
- **Collaboration**: Agent framework support, prompt template management
- **Enterprise Ready**: Private deployments with advanced capabilities

## Quick Start

```bash
docker compose up -d
```

The gateway will be available at `http://localhost:8787`

Access the console at `http://localhost:8787/public/`

## Environment Variables

- `PORTKEY_GATEWAY_VERSION`: Docker image version (default: `latest`)
- `PORTKEY_GATEWAY_PORT_OVERRIDE`: Host port to expose (default: `8787`)
- `TZ`: Timezone (default: `UTC`)

## Documentation

- [Portkey Gateway Documentation](https://portkey.ai/docs)
- [GitHub Repository](https://github.com/Portkey-AI/gateway)
- [API Reference](https://portkey.ai/docs/welcome/make-your-first-request)

## Default Port

- **Gateway API**: `8787` (<http://localhost:8787/v1>)
- **Console**: `8787` (<http://localhost:8787/public/>)

## Configuration

The gateway provides an extensive configuration system through the console. Key features include:

- Model routing rules and conditions
- Fallback and retry strategies
- Input/output guardrails
- Custom plugins and integrations
- Key management and virtual keys

Visit the console at `http://localhost:8787/public/` to configure the gateway.

## Integrations

Portkey Gateway integrates with:

- **LLM Frameworks**: LangChain, LlamaIndex, Autogen, CrewAI
- **Agent Frameworks**: Support for custom agents
- **Monitoring**: Logging and tracing capabilities

## License

Portkey AI Gateway is open-source and available under the MIT License.
