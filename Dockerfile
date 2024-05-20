FROM conda/miniconda3:latest as base

ARG CLING_ENV_NAME=cling

RUN conda init bash \
    && conda update -n base -c defaults conda -y \
    && conda create -y -n $CLING_ENV_NAME \
    && /bin/bash -c "source activate $CLING_ENV_NAME \
    && conda install -y jupyter notebook \
    && conda install -y -c conda-forge xeus-cling" \
    && conda clean --all -y

ENV PATH /opt/conda/envs/$CLING_ENV_NAME/bin:$PATH

WORKDIR /workspace

EXPOSE 8888

# Create an entrypoint script to activate the environment and start Jupyter
RUN echo '#!/bin/bash\nsource activate cling\njupyter notebook --ip=0.0.0.0 --allow-root --NotebookApp.token="" --no-browser' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]