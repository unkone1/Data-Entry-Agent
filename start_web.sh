#!/bin/bash
echo ""
echo "  Starting NIELIT Data Entry Agent (Web UI)..."
echo "  Browser will open automatically at http://127.0.0.1:5000"
echo ""
python3 -c "from app.server import run; run()"
