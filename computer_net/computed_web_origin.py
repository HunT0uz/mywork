import mysql.connector
from mysql.connector import Error
import csv
import tkinter as tk
from tkinter import scrolledtext

def connect_to_db():
    """连接到 MySQL 数据库并返回连接对象"""
    host_name = "localhost"  # 数据库主机名
    user_name = "root"       # 数据库用户名
    user_password = "1234"   # 数据库密码
    db_name = "crawlerarticledb"  # 数据库名称
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

def count_source_frequency(connection):
    """统计网站来源的频率"""
    source_frequency = {}

    try:
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT 网站名称 FROM articles")  # 确保表名和字段名正确
            rows = cursor.fetchall()  # 获取所有查询结果

            for row in rows:
                source = row[0]  # 假设来源在第一列
                if source:  # 确保不为空
                    if source in source_frequency:
                        source_frequency[source] += 1
                    else:
                        source_frequency[source] = 1

    except Error as e:
        print(f"数据库错误: {e}")

    # 将字典按值进行排序，返回一个列表（元组列表）
    sorted_source_frequency = sorted(source_frequency.items(), key=lambda item: item[1], reverse=True)

    return sorted_source_frequency  # 返回排序后的来源频率列表

def save_to_csv(source_frequency, filename='source_frequency.csv'):
    """保存频率统计到 CSV 文件"""
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['网站来源', '频率'])  # 写入标题行
        for source, frequency in source_frequency:
            writer.writerow([source, frequency])  # 写入每条数据

    print(f"数据已保存到 {filename}")

def display_results(source_frequency):
    """在 GUI 中显示统计结果"""
    result_window = tk.Tk()
    result_window.title("网站来源频率统计")

    # 创建一个滚动文本框
    text_box = scrolledtext.ScrolledText(result_window, width=40, height=10, font=("Arial", 12))
    text_box.pack(padx=10, pady=10)

    # 将结果写入文本框
    text_box.insert(tk.END, "网站来源频率统计：\n")
    for source, frequency in source_frequency:
        text_box.insert(tk.END, f"{source}: {frequency}\n")

    result_window.mainloop()

def main():
    connection = connect_to_db()

    if connection:
        # 统计来源频率
        source_frequency = count_source_frequency(connection)

        # 保存到 CSV 文件
        save_to_csv(source_frequency)

        # 在 GUI 中显示结果
        display_results(source_frequency)

        # 关闭数据库连接
        if connection.is_connected():
            connection.close()
            print("数据库连接已关闭。")
    else:
        print("无法连接到数据库，跳过处理。")

if __name__ == '__main__':
    main()
