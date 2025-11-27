# 🔍 GSC MCP Server v2 - Remote Edition

A hosted MCP server that connects Claude AI to Google Search Console with **OAuth 2.0 web authentication**. Users simply sign in with Google—no API keys or credentials to manage!

![MCP](https://img.shields.io/badge/MCP-Compatible-00ff88)
![Python](https://img.shields.io/badge/Python-3.11+-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ What's Different About v2?

| Feature | v1 (Local) | v2 (Remote) |
|---------|------------|-------------|
| Authentication | Local credentials file | OAuth 2.0 web flow |
| Setup | Complex | Just sign in with Google! |
| Hosting | Your machine | Any cloud platform |
| Multi-user | Single user | Multiple users supported |

## 🏗️ Architecture

```
┌─────────────────┐     OAuth 2.0      ┌──────────────────────┐
│     User's      │ ──────────────────→│   Your Hosted        │
│     Browser     │←──────────────────→│   MCP Server         │
└─────────────────┘                    └──────────────────────┘
                                                 ↓
┌─────────────────┐    MCP over SSE    ┌──────────────────────┐
│  Claude Desktop │ ←─────────────────→│  Stored User Token   │
└─────────────────┘                    └──────────────────────┘
                                                 ↓
                                       ┌──────────────────────┐
                                       │  Google Search       │
                                       │  Console API         │
                                       └──────────────────────┘
```

## 🚀 Quick Start

### 1. Set Up Google OAuth (Web Application)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable APIs:
   - [Search Console API](https://console.cloud.google.com/apis/library/searchconsole.googleapis.com)
   - [Indexing API](https://console.cloud.google.com/apis/library/indexing.googleapis.com) (optional)
4. Go to **Credentials** → **Create Credentials** → **OAuth client ID**
5. Select **Web application**
6. Add authorized redirect URI: `https://your-domain.com/oauth/callback`
7. Save your Client ID and Client Secret

### 2. Deploy

#### Option A: Railway (Easiest)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

1. Click the button above
2. Set environment variables:
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_CLIENT_SECRET`
   - `GOOGLE_REDIRECT_URI` (your Railway URL + `/oauth/callback`)
   - `BASE_URL` (your Railway URL)

#### Option B: Docker

```bash
# Build
docker build -t gsc-mcp-server .

# Run
docker run -p 8000:8000 \
  -e GOOGLE_CLIENT_ID="your-client-id" \
  -e GOOGLE_CLIENT_SECRET="your-secret" \
  -e GOOGLE_REDIRECT_URI="https://your-domain.com/oauth/callback" \
  -e BASE_URL="https://your-domain.com" \
  -v ./data:/app/data \
  gsc-mcp-server
```

#### Option C: Manual

```bash
# Clone
git clone https://github.com/AminForou/google-search-console-mcp-v2.git
cd google-search-console-mcp-v2

# Install
pip install -r requirements.txt

# Set environment variables
export GOOGLE_CLIENT_ID="your-client-id"
export GOOGLE_CLIENT_SECRET="your-secret"
export GOOGLE_REDIRECT_URI="http://localhost:8000/oauth/callback"

# Run
uvicorn gsc_server_remote:app --host 0.0.0.0 --port 8000
```

### 3. User Flow

1. **Users visit your server** → `https://your-domain.com`
2. **Click "Sign in with Google"** → OAuth flow
3. **Get unique API key** → Displayed after login
4. **Configure Claude Desktop**:

```json
{
  "mcpServers": {
    "gscServer": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://your-domain.com/mcp/USER_API_KEY/sse"]
    }
  }
}
```

5. **Start chatting!** → "List my GSC properties"

## 🛠️ Available Tools

| Tool | Description |
|------|-------------|
| `list_properties` | List all GSC properties |
| `get_search_analytics` | Search performance data |
| `get_performance_overview` | Performance summary |
| `find_keyword_opportunities` | Find ranking opportunities |
| `get_top_pages` | Top performing pages |
| `get_device_comparison` | Mobile vs desktop |
| `get_country_breakdown` | Traffic by country |
| `inspect_url` | URL indexing status |
| `get_sitemaps` | List sitemaps |
| `submit_sitemap` | Submit new sitemap |
| `request_indexing` | Request URL indexing |
| `export_analytics` | Export to CSV/JSON |

## 🔒 Security Considerations

- **HTTPS Required**: Always use HTTPS in production
- **API Keys**: Each user gets a unique key - treat it like a password
- **Token Storage**: Uses SQLite by default - use PostgreSQL for production
- **CORS**: Restrict origins in production
- **Rate Limiting**: Add rate limiting for production

## 📁 Project Structure

```
google-search-console-mcp-v2/
├── gsc_server_remote.py    # Main server application
├── requirements.txt        # Python dependencies
├── Dockerfile             # Docker configuration
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

## 🌐 Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GOOGLE_CLIENT_ID` | ✅ | OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | ✅ | OAuth client secret |
| `GOOGLE_REDIRECT_URI` | ✅ | OAuth callback URL |
| `BASE_URL` | ⚡ | Public server URL |
| `SECRET_KEY` | ⚡ | Session encryption key |
| `DATABASE_PATH` | ❌ | SQLite path (default: gsc_tokens.db) |

## 📊 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Home page with login |
| `/oauth/login` | GET | Start OAuth flow |
| `/oauth/callback` | GET | OAuth callback |
| `/oauth/revoke/{user_id}` | GET | Revoke user access |
| `/mcp/{user_id}/sse` | GET | MCP SSE endpoint |
| `/health` | GET | Health check |
| `/api/status/{user_id}` | GET | User auth status |

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

## 👨‍💻 Author

**Amin Foroutan** - SEO Consultant & Developer

- 🌐 [aminforoutan.com](https://aminforoutan.com/)
- 💼 [LinkedIn](https://www.linkedin.com/in/ma-foroutan/)
- 🐦 [Twitter](https://x.com/aminfseo)
- 📺 [YouTube](https://www.youtube.com/channel/UCW7tPXg-rWdH4YzLrcAdBIw)

---

⭐ If you find this useful, please star the repo!

