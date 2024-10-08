# Install ip.
FROM python:3.10-slim-bullseye
RUN apt-get update
RUN apt-get install -y curl procps gnupg git
RUN apt-get install -y net-tools ethtool iproute2

# Add the Google Cloud SDK package repository
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install the Google Cloud SDK
RUN apt-get update && apt-get install -y google-cloud-sdk

# Set the default Python version to 3.10
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.10 1

# Set environment variables for Google Cloud SDK and Python 3.10
ENV PATH="/usr/local/google-cloud-sdk/bin:/usr/local/bin/python3.10:${PATH}"

RUN pip install  --no-cache-dir  jax[tpu] -f https://storage.googleapis.com/jax-releases/libtpu_releases.html
RUN pip install  --no-cache-dir -U --pre jaxlib -f https://storage.googleapis.com/jax-releases/jaxlib_nightly_releases.html
RUN pip install git+https://github.com/google/jax
RUN pip uninstall jaxlib -y
RUN pip install -U --pre jax[tpu] --no-cache-dir  -f https://storage.googleapis.com/jax-releases/jax_nightly_releases.html -f https://storage.googleapis.com/jax-releases/libtpu_releases.html
RUN pip install git+https://github.com/mlperf/logging.git

RUN git clone https://github.com/google/maxdiffusion.git

WORKDIR maxdiffusion

RUN git checkout 00150750841e9155669fd1ac4c6f2fcd0e0654e0
RUN pip install -r requirements.txt

RUN pip install .