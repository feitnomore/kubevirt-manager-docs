# Usa uma imagem base oficial do Python
FROM python:3.9-slim

# Instala o MkDocs e o tema Material
RUN pip install --upgrade pip && \
    pip install mkdocs mkdocs-material

# Define o diretório de trabalho padrão
WORKDIR /docs