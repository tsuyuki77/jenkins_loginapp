#!/bin/bash
set -e

APP_SRC="Flask_/Pf2_Login_Page"
WORKDIR="tempdir_pf2"

IMAGE_NAME="pf2app"
CONTAINER_NAME="pf2running"

# Opruimen (zoals lab)
docker stop $CONTAINER_NAME >/dev/null 2>&1 || true
docker rm $CONTAINER_NAME >/dev/null 2>&1 || true

rm -rf $WORKDIR
mkdir -p $WORKDIR

# Kopieer app bestanden
cp "$APP_SRC/flask_app.py" tempdir_pf2/
cp -r "$APP_SRC/templates" tempdir_pf2/
cp -r "$APP_SRC/static" tempdir_pf2/

# Maak Dockerfile (zoals lab maakt via script)
cat > $WORKDIR/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir flask

EXPOSE 8802
CMD ["python", "flask_app.py"]
EOF

# Build image
docker build -t $IMAGE_NAME $WORKDIR

# Run container op hostpoort 5050 -> containerpoort 8802
docker run -t -d -p 5050:8802 --name $CONTAINER_NAME $IMAGE_NAME

echo "Container draait op: http://localhost:5050"
