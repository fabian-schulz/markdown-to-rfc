FROM ruby:4-slim

ARG XML_FONT_VERSION=3.22.0

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    # gnome xml library
    libxml2 \
    # Layout and rendering of internationalized text
    libpango-1.0-0 libpangoft2-1.0-0 \
    # font setting
    fontconfig wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Install IETF fonts
RUN wget -qO fonts.zip "https://github.com/ietf-tools/xml2rfc-fonts/archive/refs/tags/${XML_FONT_VERSION}.zip" && \
    unzip -q fonts.zip && \
    mkdir -p /usr/share/fonts/truetype/xml2rfc && \
    cp -r xml2rfc-fonts-${XML_FONT_VERSION}/noto xml2rfc-fonts-${XML_FONT_VERSION}/roboto_mono /usr/share/fonts/truetype/xml2rfc/ && \
    fc-cache -f && \
    rm -rf fonts.zip xml2rfc-fonts-${XML_FONT_VERSION}

# Setup python virtual environment (for xml2rfc)
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install XML2RFC
RUN pip install --upgrade pip && \
    pip install --no-cache-dir "xml2rfc[pdf]"

# Install kramdown-rfcc
RUN gem install kramdown-rfc

# Set up a working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
