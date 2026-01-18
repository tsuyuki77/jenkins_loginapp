#!/bin/bash
set -e

APP_SRC="."
WORKDIR="tempdir_pf2"

IMAGE_NAME="pf2app"
CONTAINER_NAME="pf2running"

docker stop $CONTAINER_NAME >/dev/null 2>&1 || true
docker rm $CONTAINER_NAME >/dev/null 2>&1 || true

rm -rf $WORKDIR
mkdir -p $WORKDIR

cp "$APP_SRC/flask_app.py" $WORKDIR/
cp -r "$APP_SRC/templates" $WORKDIR/
cp -r "$APP_SRC/static" $WORKDIR/

cat > $WORKDIR/Dockerfile << 'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir flask
EXPOSE 8802
CMD ["python", "flask_app.py"]
EOF

docker build -t $IMAGE_NAME $WORKDIR
docker run -t -d -p 5050:8802 --name $CONTAINER_NAME $IMAGE_NAME

echo "App draait op: http://localhost:5050/login"
