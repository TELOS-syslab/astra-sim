#!/bin/bash
# 获取此脚本的绝对路径
SCRIPT_DIR=$(dirname "$(realpath $0)") # 使用realpath获得当前脚本的绝对路径，再用dirname获取目录路径
# 设置其他有用的目录的绝对路径
ASTRA_SIM_DIR="${SCRIPT_DIR:?}"/../../astra-sim # 指定Astra-Sim的目录路径
NS3_DIR="${SCRIPT_DIR:?}"/../../extern/network_backend/ns-3 # 指定NS3的目录路径
# 设置一些输入文件路径 - 可以根据需要更改
WORKLOAD="${SCRIPT_DIR:?}"/../../extern/graph_frontend/chakra/one_comm_coll_node_allgather # 工作负载配置文件路径
SYSTEM="${SCRIPT_DIR:?}"/../../inputs/system/Switch.json # 系统配置文件路径
MEMORY="${SCRIPT_DIR:?}"/../../inputs/remote_memory/analytical/no_memory_expansion.json # 远程内存配置文件路径
LOGICAL_TOPOLOGY="${SCRIPT_DIR:?}"/../../inputs/network/ns3/sample_8nodes_1D.json # 网络拓扑配置文件路径
# 只有这个文件是相对于NS3_DIR/simulation的相对路径
NETWORK="../../../ns-3/scratch/config/config.txt" # 网络配置文件的相对路径
# 定义一些函数
function setup {
    # 使用protoc编译et_def.proto文件，生成对应的C++代码文件
    protoc et_def.proto\
        --proto_path ${SCRIPT_DIR}/../../extern/graph_frontend/chakra/et_def/\
        --cpp_out ${SCRIPT_DIR}/../../extern/graph_frontend/chakra/et_def/
}
function compile {
    # 进入NS3目录进行编译
    cd "${NS3_DIR}"
    ./ns3 configure --enable-mpi # 配置NS3以支持MPI（并行计算）
    ./ns3 build AstraSimNetwork -j 12 # 并行编译AstraSimNetwork模块，使用12个线程
    cd "${SCRIPT_DIR:?}" # 返回脚本目录
}
function run {
    # 进入NS3的构建目录，运行程序
    cd "${NS3_DIR}/build/scratch"
    ./ns3.42-AstraSimNetwork-default \
        --workload-configuration=${WORKLOAD} \ # 指定工作负载配置
        --system-configuration=${SYSTEM} \ # 指定系统配置
        --network-configuration=${NETWORK} \ # 指定网络配置
        --remote-memory-configuration=${MEMORY} \ # 指定远程内存配置
        --logical-topology-configuration=${LOGICAL_TOPOLOGY} \ # 指定网络拓扑配置
        --comm-group-configuration=\"empty\" # 指定通信组配置（空配置）
    cd "${SCRIPT_DIR:?}" # 返回脚本目录
}
function cleanup {
    # 清理编译生成的文件
    cd "${NS3_DIR}"
    ./ns3 distclean # 清理NS3的编译文件
    cd "${SCRIPT_DIR:?}" # 返回脚本目录
}
function cleanup_result {
    # 输出0，可能是清理结果的占位符
    echo '0'
}
function debug {
    # 以调试模式编译NS3，并启动GDB调试器
    cd "${NS3_DIR}"
    ./ns3 configure --enable-mpi --build-profile debug # 配置为调试模式并启用MPI
    ./ns3 build AstraSimNetwork -j 12 -v # 以详细模式并行编译
    cd "${NS3_DIR}/build/scratch"
    gdb --args "${NS3_DIR}/build/scratch/ns3.42-AstraSimNetwork-debug" \
        --workload-configuration=${WORKLOAD} \ # 工作负载配置
        --system-configuration=${SYSTEM} \ # 系统配置
        --network-configuration=${NETWORK} \ # 网络配置
        --remote-memory-configuration=${MEMORY} \ # 远程内存配置
        --logical-topology-configuration=${LOGICAL_TOPOLOGY} \ # 网络拓扑配置
        --comm-group-configuration=\"empty\" # 通信组配置（空）
}
function special_debug {
    # 使用Valgrind检测内存泄漏并运行程序
    cd "${NS3_DIR}/build/scratch"
    valgrind --leak-check=yes "${NS3_DIR}/build/scratch/ns3.42-AstraSimNetwork-default" \
        --workload-configuration=${WORKLOAD} \ # 工作负载配置
        --system-configuration=${SYSTEM} \ # 系统配置
        --network-configuration=${NETWORK} \ # 网络配置
        --remote-memory-configuration=${MEMORY} \ # 远程内存配置
        --logical-topology-configuration=${LOGICAL_TOPOLOGY} \ # 网络拓扑配置
        --comm-group-configuration=\"empty\" # 通信组配置（空）
}
# 主程序
case "$1" in
-l|--clean)
    cleanup;; # 如果选项为-l或--clean，调用cleanup函数
-lr|--clean-result)
    cleanup # 调用cleanup函数
    cleanup_result;; # 调用cleanup_result函数
-d|--debug)
    setup # 调用setup函数
    debug;; # 调用debug函数
-c|--compile|"")
    setup # 调用setup函数
    compile;; # 调用compile函数
-r|--run)
    # setup # 注释掉setup
    # compile # 注释掉compile
    run;; # 调用run函数
-h|--help|*)
    printf "Prints help message";; # 打印帮助信息
esac
