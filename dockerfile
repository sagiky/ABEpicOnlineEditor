FROM python:3.12-slim

# Install Java, wget (to download your big files), and clean up
RUN apt-get update && \
    apt-get install -y default-jre-headless wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download BOTH massive files directly into the container.
# IMPORTANT: Replace these URLs with your actual direct download links!
RUN wget -q -O Epic.ipa "https://github.com/sagiky/ABEpicOnlineEditor/releases/download/almost-default/Epic.ipa"
RUN wget -q -O Epic.apk "https://github.com/sagiky/ABEpicOnlineEditor/releases/download/default/Epic.apk"

# Install Python deps (Make sure 'gunicorn' is added to your requirements.txt!)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code into the container
COPY . .

# Make sure you uploaded the Linux version of this tool!
RUN if [ -f abe_multitool ]; then chmod +x abe_multitool; fi

EXPOSE 5000

# Start with Gunicorn to fix the warning and prevent instant crashes
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "300", "server:app"]