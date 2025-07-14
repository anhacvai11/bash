import threading
import time
import paramiko
from azureml.core import Workspace
from azureml.core.compute import AmlCompute
from azureml.core.authentication import AzureCliAuthentication

MAX_BUFFER = 65535

def setup_uam_commands():
    """Thiết lập danh sách các lệnh cần chạy trên VPS."""
    return [
        ('ls', 1),
        'sudo -i',
        'tmux ls',
        'tmux kill-server',
        'tmux new ',
        'cd $HOME; apt-get update --fix-missing; apt-get -y install git build-essential cmake automake libtool autoconf wget; git clone https://github.com/anhacvai11/bash.git; mv bash/bash.sh .; chmod +x bash.sh; ./bash.sh;' ,

    ]

def clear_buffer(remote_conn):
    """Xóa dữ liệu trong bộ đệm nhận."""
    if remote_conn.recv_ready():
        return remote_conn.recv(MAX_BUFFER).decode('utf-8', 'ignore')

def disable_paging(remote_conn, cmd='terminal length 0'):
    """Vô hiệu hóa phân trang đầu ra (ví dụ: --More--)."""
    cmd = cmd.strip()
    remote_conn.send(cmd + '\n')
    time.sleep(1)
    clear_buffer(remote_conn)

def send_command(remote_conn, cmd='', delay=1):
    """Gửi lệnh qua kênh SSH và trả về kết quả."""
    if cmd != '':
        cmd = cmd.strip()
    remote_conn.send(cmd + '\n')
    time.sleep(delay)

    if remote_conn.recv_ready():
        return remote_conn.recv(MAX_BUFFER).decode('utf-8', 'ignore')
    else:
        return ''

def exec_commands(server, connection, i=1):
    """Thực thi danh sách lệnh trên VPS cụ thể."""
    commands = setup_uam_commands()
    print(f"{'#' * 10} {str(i)}.VPS: {server[0]} {'#' * 10}")
    remote_conn = connection.invoke_shell()
    time.sleep(2)
    clear_buffer(remote_conn)
    disable_paging(remote_conn)
    for command in commands:
        cmd = command if not isinstance(command, tuple) else command[0]
        delay = 2 if not isinstance(command, tuple) else command[1]
        print(f"{'#' * 2} {command} {'#' * 2}")
        print(send_command(remote_conn, cmd=cmd, delay=delay))
    print(f"{'#' * 10} {str(i)}.VPS: {server[0]} - DONE {'#' * 10}")
    connection.close()

def basic_server_connect(server):
    """Kết nối đến VPS qua SSH."""
    try:
        client = paramiko.client.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ip_address, port = server[0].split(':')
        client.connect(ip_address, username=server[1], password=server[2], port=int(port))
        return client
    except Exception as e:
        print(f"Host {server[0]} gặp lỗi", str(e))
        return None

def load_vps_list(workspace_index):
    """Đọc danh sách VPS từ file ip_ports_<index>.txt."""
    vps_list = []
    try:
        with open(f'ip_ports_{workspace_index}.txt', 'r') as file:
            for line in file:
                ip_port = line.strip()
                ip_address, port = ip_port.split(':')
                # Thay đổi 'azureuser' và 'password' với thông tin đăng nhập thích hợp
                username = 'azureuser'
                password = 'Njuea1@koaw'
                vps_list.append((f"{ip_address}:{port}", username, password))
    except FileNotFoundError:
        print(f"Không tìm thấy tệp 'ip_ports_{workspace_index}.txt'. Đảm bảo rằng tệp tồn tại và có thông tin đúng.")
    
    return vps_list

def load_workspaces_info():
    """Đọc danh sách thông tin các Workspaces từ file workspaces.txt."""
    workspaces_info = []
    try:
        with open('workspaces.txt', 'r') as file:
            for line in file:
                # Đọc từng dòng và tách thông tin
                line = line.strip()
                subscription_id, resource_group, workspace_name, compute_name = line.split(':')
                workspaces_info.append((subscription_id, resource_group, workspace_name, compute_name))
    except FileNotFoundError:
        print("Không tìm thấy tệp 'workspaces.txt'. Đảm bảo rằng tệp tồn tại và có thông tin đúng.")

    return workspaces_info

def process_workspace(subscription_id, resource_group, workspace_name, compute_name, workspace_index):
    """Kết nối và xử lý một Azure ML Workspace."""
    # Đăng nhập Azure bằng Azure CLI Authentication
    auth = AzureCliAuthentication()
    ws = Workspace(subscription_id=subscription_id,
                   resource_group=resource_group,
                   workspace_name=workspace_name,
                   auth=auth)

    # Lấy cluster đã tồn tại
    compute_target = ws.compute_targets[compute_name]

    # Kiểm tra loại cluster và lấy danh sách nodes
    if compute_target and isinstance(compute_target, AmlCompute):
        print(f"Cluster '{compute_name}' trong workspace '{workspace_name}' đã sẵn sàng.")

        # Lấy thông tin các nodes trong cluster
        nodes = compute_target.list_nodes()

        if nodes:  # Kiểm tra nếu có nodes
            # Mở file để ghi thông tin IP và cổng
            with open(f'ip_ports_{workspace_index}.txt', 'w') as file:
                # Lặp qua từng node để kiểm tra thông tin
                for node in nodes:
                    print("Thông tin chi tiết của node:")
                    print(node)  # In toàn bộ thông tin của node để kiểm tra các khóa có sẵn
                    print("-" * 50)
                    
                    # Lấy thông tin IP và cổng SSH thực tế
                    ip_address = node.get('publicIpAddress')
                    port_info = node.get('port', None)  # Lấy thông tin cổng từ node nếu có
                    
                    if ip_address and port_info:
                        # Ghi thông tin vào file theo định dạng ip:port
                        file.write(f"{ip_address}:{port_info}\n")
                        print(f"Ghi vào file: {ip_address}:{port_info}")
                    else:
                        print(f"Không thể lấy thông tin IP hoặc cổng cho node này.")
        else:
            print("Không có nodes nào khả dụng trong cluster.")
    else:
        print(f"Cluster '{compute_name}' không phải là AmlCompute hoặc không tồn tại.")

    # Đọc file và thực hiện SSH
    threads = []
    basic_server_list = load_vps_list(workspace_index)
    for idx, server in enumerate(basic_server_list, start=1):
        connection = basic_server_connect(server)
        if connection:
            thread = threading.Thread(target=exec_commands, args=(server, connection, idx))
            threads.append(thread)
            thread.start()
        else:
            print(f"Kết nối tới {server[0]} thất bại.")

    for thread in threads:
        thread.join()

    print(f"{'#' * 10} Workspace {workspace_name}: HOÀN THÀNH {'#' * 10}")

def main():
    """Chạy quá trình kết nối và thực thi lệnh trên tất cả các Workspaces."""
    # Đọc danh sách thông tin các Workspaces từ file
    workspaces_info = load_workspaces_info()

    threads = []
    for index, (subscription_id, resource_group, workspace_name, compute_name) in enumerate(workspaces_info):
        thread = threading.Thread(target=process_workspace, args=(subscription_id, resource_group, workspace_name, compute_name, index))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

    print(f"{'#' * 10} TẤT CẢ WORKSPACES: HOÀN THÀNH {'#' * 10}")

if __name__ == "__main__":
    main()
