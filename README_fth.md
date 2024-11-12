安装教程
https://astra-sim.github.io/astra-sim-docs/getting-started/setup.html

sudo apt update
sudo apt install \
  gcc g++ make cmake \
  libboost-dev libboost-program-options-dev \
  libprotobuf-dev protobuf-compiler \
  openmpi-bin openmpi-doc libopenmpi-dev \
  python3 python3-pip git

Installing protobuf 3.6.1 locally
./configure
make -j$(nproc)
make check -j$(nproc)  # checking compilation finished successfully

make -j$40 # fth 
make check -j$40 # fth

sudo make install  # register protobuf to PATH
which protoc  # system should be able to locate protoc
protoc --version  # should be 3.6.1

conda create -n astra-sim python=3.7
conda activate astra-sim
conda install graphviz python-graphviz pydot

$ git clone --recurse-submodules git@github.com:astra-sim/astra-sim.git

git clone --recurse-submodules git@github.com:TELOS-syslab/astra-sim.git
$ cd astra-sim

# Create Docker Image
$ docker build -t astra-sim .

# Run Docker Image
$ docker run -it astra-sim

方法 1：使用 conda 安装特定版本
如果你的环境中使用 conda，可以使用以下命令安装 3.6.1 版本：

bash
复制代码
conda install -c conda-forge protobuf=3.6.1

protoc --version


export Protobuf_INCLUDE_DIR=/path/to/protobuf-3.6.1/include
export Protobuf_LIBRARY=/path/to/protobuf-3.6.1/lib/libprotobuf.so
export Protobuf_PROTOC_EXECUTABLE=/path/to/protobuf-3.6.1/bin/protoc

export Protobuf_INCLUDE_DIR=/root/anaconda3/envs/astra-sim/include
export Protobuf_LIBRARY=/root/anaconda3/envs/astra-sim/lib/libprotobuf.so
export Protobuf_PROTOC_EXECUTABLE=/root/anaconda3/envs/astra-sim/bin/protoc


# For Analytical Network Backend
$ ./build/astra_analytical/build.sh

# For NS3 Network Backend
$ ./build/astra_ns3/build.sh -c

# ASTRA-sim 2.0
[ASTRA-sim](https://astra-sim.github.io/) is a distributed machine learning system simulator developed by Intel, Meta, and Georgia Tech. It enables the systematic study of challenges in modern deep learning systems, allowing for the exploration of bottlenecks and the development of efficient methodologies for large DNN models across diverse future platforms.

The previous version, ASTRA-sim 1.0, is available in the `ASTRA-sim-1.0` [branch](https://github.com/astra-sim/astra-sim/tree/ASTRA-sim-1.0).

Here is a concise visual summary of our simulator:
![alt text](https://github.com/astra-sim/astra-sim/blob/master/docs/images/astrasim_overview_codesign.png)

For a comprehensive understanding of the tool, and to gain insights into its capabilities, please visit our [website](https://astra-sim.github.io/).

For information on how to use ASTRA-sim, please visit our [Wiki](https://astra-sim.github.io/astra-sim-docs/index.html).

ASTRA-sim accepts Chakra Execution Traces as workload-layer inputs. For details, please visit [Chakra Github](https://github.com/mlcommons/chakra).

We appreciate your interest and support in ASTRA-sim!

## Contact Us
For any questions about using ASTRA-sim, you can email the ASTRA-sim User Mailing List: astrasim-users@googlegroups.com

To join the mailing list, please fill out the following form: https://forms.gle/18KVS99SG3k9CGXm6
