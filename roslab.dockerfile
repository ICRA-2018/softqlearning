FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

################################## JUPYTERLAB ##################################

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get -o Acquire::ForceIPv4=true update && apt-get -yq dist-upgrade \
 && apt-get -o Acquire::ForceIPv4=true install -yq --no-install-recommends \
	locales cmake git build-essential \
    python-pip \
	python3-pip python3-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install jupyterlab==0.35.4 bash_kernel==0.7.1 tornado==5.1.1 \
 && python3 -m bash_kernel.install

ENV SHELL=/bin/bash \
	NB_USER=jovyan \
	NB_UID=1000 \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8

ENV HOME=/home/${NB_USER}

RUN adduser --disabled-password \
	--gecos "Default user" \
	--uid ${NB_UID} \
	${NB_USER}

EXPOSE 8888

CMD ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''"]

##################################### APT ######################################

RUN apt-get -o Acquire::ForceIPv4=true update \
 && apt-get -o Acquire::ForceIPv4=true install -yq --no-install-recommends \
    git make cmake unzip \
    zlib1g-dev \
    libglfw3-dev \
    libxrandr2 libxinerama-dev libxi6 libxcursor-dev \
    vim ack-grep \
    python-pygame \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

##################################### PIP3 #####################################

RUN pip3 install --upgrade pip

RUN pip3 install  \
    awscli \
    Pillow \
    cached-property \
    cloudpickle \
    mkl-service==1.1.2 \
    mkl==2017.0.4 \
    numpy==1.14.5 \
    path.py \
    PyOpenGL \
    six \
    cffi \
    cma==1.1.06 \
    flask \
    gtimer \
    gym[all]==0.10.8 \
    jsonmerge \
    joblib==0.12 \
    git+https://github.com/Lasagne/Lasagne.git@a61b76fd991f84c50acdb7bea02118899b5fefe1#egg=lasagne \
    mako \
    matplotlib \
    mujoco-py==1.50.1 \
    nose2 \
    git+https://github.com/plotly/plotly.py.git@2594076e29584ede2d09f2aa40a8a195b3f3fc66#egg=plotly \
    psutil \
    pyprind \
    ray \
    tensorflow==1.9.0

##################################### COPY #####################################

RUN mkdir ${HOME}/softqlearning

COPY . ${HOME}/softqlearning

##################################### TAIL #####################################

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

WORKDIR ${HOME}/softqlearning
