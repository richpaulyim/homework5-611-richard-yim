FROM rocker/verse:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    texlive-latex-extra \
    texlive-fonts-recommended \
    emacs \
    elpa-ess \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Install R packages
RUN R -e "install.packages( \
    c( \
        'survival',  \
        'caret',  \
        'plotly',  \
        'magick',  \
        'tidytext',  \
        'tidyverse',  \
        'cluster'),  \
    repos='https://cloud.r-project.org/')"

WORKDIR /home/rstudio

CMD ["/init"]
