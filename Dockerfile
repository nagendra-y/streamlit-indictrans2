# Use a base image with necessary dependencies
FROM ubuntu:latest
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Update and install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    unzip \
    g++ \
    python3-pip

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

# Clone IndicTrans2 repository and install
RUN git clone https://github.com/nagendra-y/streamlit-indictrans2.git && \
    cd streamlit-indictrans2/inference && \
    pip install -r requirements.txt

# Install required Python packages
RUN pip install mammoth streamlit python-docx pypdf2

# Copy the app.py into the IndicTrans2 Docker image directory
COPY ct2_model streamlit-indictrans2/ct2_model

# Set the working directory to IndicTrans2
WORKDIR /streamlit-indictrans2

# Command to run the Streamlit app
CMD ["streamlit", "run", "streamlit_app.py"]
