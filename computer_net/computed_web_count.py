import mysql.connector
from mysql.connector import Error
import tkinter as tk
from tkinter import scrolledtext
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib

# 设置字体以支持中文
matplotlib.rcParams['font.sans-serif'] = ['SimHei']  # 在这里设置为您系统中支持中文的字体
matplotlib.rcParams['axes.unicode_minus'] = False  # 解决负号显示问题

def connect_to_db():
    """连接到 MySQL 数据库并返回连接对象"""
    host_name = "localhost"
    user_name = "root"
    user_password = "1234"
    db_name = "crawlerarticledb"  # 替换为您的数据库名称
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=user_password,
            database=db_name
        )
        print("成功连接到数据库")
    except Error as e:
        print(f"数据库连接错误: {e}")
    return connection

def fetch_monthly_growth(connection):
    """按月从数据库中提取网页数量并进行唯一性检查"""
    monthly_data = {}
    unique_titles = set()
    unique_links = set()

    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("""
                SELECT DATE_FORMAT(converted_date, '%Y-%m') AS month, 标题, 百度链接
                FROM articles;
            """)
            rows = cursor.fetchall()
            for row in rows:
                month, title, baidu_link = row
                if title and baidu_link:  # 仅处理有效的标题和链接
                    if title not in unique_titles and baidu_link not in unique_links:
                        unique_titles.add(title)
                        unique_links.add(baidu_link)

                        if month not in monthly_data:
                            monthly_data[month] = 1  # 初始化计数
                        else:
                            monthly_data[month] += 1  # 增加计数

            print("成功获取到月增长数据，并进行了唯一性检查。")
    except Error as e:
        print(f"数据库错误: {e}")
    return monthly_data

def save_to_csv(monthly_data, filename="monthly_growth.csv"):
    """将每月网页数量数据保存至 CSV 文件"""
    if monthly_data:
        df = pd.DataFrame(monthly_data.items(), columns=['月份', '网页数量'])
        df.to_csv(filename, index=False, encoding='utf-8-sig')  # 保存为 CSV 文件
        print(f"数据已成功保存至 {filename}")
    else:
        print("没有可保存的数据。")

def plot_growth(monthly_data):
    """绘制网页数量增长图"""
    if monthly_data:
        months = list(monthly_data.keys())
        counts = list(monthly_data.values())

        # 过滤掉无效数据
        months = [m for m in months if m is not None]
        counts = [monthly_data[m] for m in months if m in monthly_data]

        if months and counts:  # 确保有有效的数据进行绘制
            plt.figure(figsize=(10, 5))
            plt.plot(months, counts, marker='o')
            plt.title('网页数量按月增长图')
            plt.xlabel('月份')
            plt.ylabel('网页数量')
            plt.xticks(rotation=45)
            plt.grid()
            plt.tight_layout()
            plt.show()  # 显示图形
        else:
            print("没有可绘制的数据。")
    else:
        print("没有可绘制的数据。")

def run_statistics():
    """运行统计并更新GUI显示"""
    connection = connect_to_db()
    if connection:
        monthly_data = fetch_monthly_growth(connection)

        result_text.delete(1.0, tk.END)  # 清空文本框
        result_text.insert(tk.END, "按月网页数量增长:\n")
        for month, count in monthly_data.items():
            result_text.insert(tk.END, f"{month}: {count} 条\n")

        # 保存数据到 CSV
        save_to_csv(monthly_data)

        # 绘制增长图
        plot_growth(monthly_data)

        # 关闭数据库连接
        if connection.is_connected():
            connection.close()
            print("数据库连接已关闭。")
    else:
        result_text.insert(tk.END, "无法连接到数据库，跳过处理。\n")

# 创建GUI窗口
window = tk.Tk()
window.title("网页按月增长统计")
window.geometry("400x300")

# 创建按钮以运行统计
run_button = tk.Button(window, text="运行统计", command=run_statistics)
run_button.pack(pady=10)

# 创建文本框以显示结果
result_text = scrolledtext.ScrolledText(window, wrap=tk.WORD, width=50, height=10)
result_text.pack(pady=10)

# 启动GUI循环
window.mainloop()
