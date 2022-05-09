FROM amazonlinux:2.0.20220426.0 

# Wallet address
ARG words 

# Create the keys file
RUN echo ${words} > /root/keys.txt

# Install packages

RUN  yum -y update 
RUN  yum list | grep python3
RUN  yum -y install python3.7 
RUN  yum -y install gcc python-setuptools python-devel  
RUN  yum -y install python3-devel
RUN  yum -y install python3-pip




# Create chia folder
RUN mkdir /chia-blockchain
RUN mkdir /root/.chia
RUN mkdir /root/.chia/mainnet
WORKDIR /chia-blockchain

# Copy the code files
COPY ./ssl /root/.chia/mainnet/config/ssl
COPY ./requirements.txt /chia-blockchain/requirements.txt
COPY docker-start.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
COPY docker-healthcheck.sh /usr/local/bin/


# Variables
ENV CHIA_ROOT=/root/.chia/mainnet
ENV TZ="UTC"
ENV log_to_file="true"
ENV keys=/root/keys.txt 
ENV service="wallet"
ENV token_tail="aa53978aaac154e32380aaf6322cd316696442248f1d15051007bc48b011694b"
ENV token_name="CTK"





# Install chia blockchain of pip repositories
RUN python3.7 -m venv /chia-blockchain/venv/ 
RUN source /chia-blockchain/venv/bin/activate & pip3 install -r requirements.txt --upgrade pip
RUN source /chia-blockchain/venv/bin/activate & chia init
RUN source /chia-blockchain/venv/bin/activate & chia version

RUN sed -i 's/localhost/127.0.0.1/g' /root/.chia/mainnet/config/config.yaml

RUN mv /chia-blockchain/venv/bin/activate /chia-blockchain/activate

# Uninstall build packages
# RUN yum remove gcc
# RUN yum remove python-setuptools
# RUN yum remove python-devel  
# RUN yum remove python3-devel
RUN yum clean all

# Only expose RPC, P2P wallet port
EXPOSE 8555 8449


ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["docker-start.sh"]
