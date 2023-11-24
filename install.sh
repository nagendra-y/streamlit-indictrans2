#!/bin/bash

OS=$(uname)

if [[ "$OS" == "Linux" ]]; then
    # Install required packages on Linux
    apt-get update
    apt-get install -y \
        wget \
        git \
        unzip \
        g++ \
        python3-pip
elif [[ "$OS" == "Darwin" ]]; then
    # Install Homebrew on macOS (if not already installed)
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install required packages on macOS
    brew update
    brew install wget git g++ python@3.9
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# Download and install Miniconda
if [[ "$OS" == "Linux" ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
elif [[ "$OS" == "Darwin" ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

mkdir ~/.conda
bash Miniconda3-latest-$OS-x86_64.sh -b
rm -f Miniconda3-latest-$OS-x86_64.sh
conda --version

# Clone repository and install Python requirements
git clone https://github.com/nagendra-y/streamlit-indictrans2.git
cd streamlit-indictrans2
pip install -r ./inference/requirements.txt

# Install required Python packages
pip install mammoth streamlit python-docx pypdf2

streamlit run streamlit_app.py
