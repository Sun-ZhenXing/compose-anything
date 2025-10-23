# Notion MCP Server

Official Notion MCP Server providing integration with Notion workspace through the Model Context Protocol.

## Features

- 📝 **Page Management** - Create and manage pages
- 📋 **Database Queries** - Query Notion databases
- 🔍 **Content Search** - Search workspace content
- 📊 **Data Management** - Manage database records

## Environment Variables

| Variable                     | Default  | Description                         |
| ---------------------------- | -------- | ----------------------------------- |
| `MCP_NOTION_VERSION`         | `latest` | MCP Notion image version            |
| `MCP_NOTION_PORT_OVERRIDE`   | `8000`   | MCP service port                    |
| `INTERNAL_INTEGRATION_TOKEN` | -        | Notion integration token (required) |
| `TZ`                         | `UTC`    | Timezone                            |

## Getting Started

1. Create a Notion integration at <https://developers.notion.com>
2. Set the `INTERNAL_INTEGRATION_TOKEN` in your `.env` file
3. Run `docker compose up -d`
